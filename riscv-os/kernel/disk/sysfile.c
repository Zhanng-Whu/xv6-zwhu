#include "include/types.h"
#include "include/riscv.h"
#include "include/defs.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/spinlock.h"
#include "include/proc.h"
#include "include/vm.h"
#include "include/fs.h"
#include "include/sleeplock.h"
#include "include/file.h"
#include "include/fcntl.h"
#include "include/stat.h"

static void iunlockput(struct inode* ip){
    iunlock(ip);
    iput(ip);
}

static struct inode*
create(char* path, short type, short major, short minor){
    struct inode* ip;
    struct inode* dp;
    char name[DIRSIZ];

    // 找到父目录
    if((dp = nameiparent(path, name)) == 0)
        return 0;
    ilock(dp);

    if((ip = dirlookup(dp, name, 0)) != 0){
        // 那么文件已经存在
        iunlock(dp);
        iput(dp);
    
        ilock(ip);

        // 这个文件类型和要创建的文件类型相同
        if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
            return ip;
        
        iunlockput(ip);
        return 0;
    }

    // 分配一个inode
    if((ip = ialloc(dp->dev, type)) == 0){
        iunlockput(dp);
        return 0;
    }

    // 初始化这个inode 并且将其写入磁盘中
    ilock(ip);
    ip->major = major;
    ip->minor = minor;
    ip->nlink = 1;
    iupdate(ip);

    // 如果是目录文件 那么为. 和 .. 创建目录项  
    if(type == T_DIR){
        if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
            goto fail;
    }

    // 创建父目录向当前目录的目录项
    if(dirlink(dp, name, ip->inum) < 0)
        goto fail;

    if(type == T_DIR){
        dp->nlink++;  // for ".."
        iupdate(dp);
    }

    iunlockput(dp);

    return ip;


fail:
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}

// 为当前进程的文件分配文件描述符
static int fdalloc(struct file* f){
    int fd;
    struct PCB* p = myproc();

    for(fd = 0; fd < NOFILE; fd++){
        if(p->ofile[fd] == 0){
            p->ofile[fd] = f;
            return fd;
        }
    }

    return -1;
}

// 获取第n个参数对应的文件描述符号 
// 是argin和ofile的一个封装
// 如果pfd不为0 那么将文件描述符写入*pfd
// 如果pf不为0 那么将文件的结构体写入
static int 
argfd(int n, int *pfd, struct file** pf){
    int fd;
    struct file* f;
    argint(n, &fd);

    if(fd < 0 || fd >= NOFILE || (f=myproc() ->ofile[fd]) == 0 )
        return -1;  
    if(pfd)
        *pfd = fd;
    if(pf)
        *pf = f;
    return 0;
}

uint64
sys_dup(void){
    struct file* f;
    int fd;
    if(argfd(0,0, &f) < 0){
        return -1;
    }
    if((fd = fdalloc(f))< 0)
        return -1;
    filedup(f);
    return fd;
}

// 用于创建一个新文件节点
uint64
sys_mknod(void){
    struct inode* ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    argint(1, &major);
    argint(2, &minor);
    if((argstr(0, path, MAXPATH)) < 0 ||
       (ip = create(path, T_DEVICE, major, minor)) == 0){
        end_op();
        return -1;
    }
    iunlockput(ip);
    end_op();
    return 0;
}

uint64 
sys_open(void){
    char path[MAXPATH];
    int omode;
    struct file* f;
    int fd;
    int n;
    struct inode* ip;

    argint(1, &omode);

    if((n = argstr(0, path, MAXPATH)) < 0)
        return -1;
    begin_op();
    

    // 如果权限中有创造文件,那么创造一个新的文件并且返回file
    if(omode & O_CREATE){
        // 如果文件已经存在 那么直接返回该文件
        ip = create(path, T_FILE, 0, 0);

        if(ip == 0){
            end_op();
            return -1;
        }
    }else{
        // 否则 自己根据文件系统找
        if((ip = namei(path)) == 0){
            end_op();
            return -1;
        }
        ilock(ip);
        // 如果是目录文件 并且不是只读模式 那么报错
        if(ip->type == T_DIR && omode != O_RDONLY){
            iunlock(ip);
            iput(ip);
            end_op();
            return -1;
        }
    }

    // 如果这个文件是设备但是设备号不正确 那么关闭
    if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
        iunlockput(ip);
        end_op();
        return -1;
    }

    // 分配文件描述符
    if((f = filealloc()) == 0 || (fd = fdalloc(f) < 0)){
        if(f) fileclose(f);
        iunlockput(ip);
        end_op();
        return -1;
    }    

    // 接下来判断文件的类型 根据类型进行初始化
    if(ip->type == T_DEVICE){
        f->type = FD_DEVICE;
        f->major = ip->major;
    }else{
        f->type = FD_INODE;
        f->off = 0;
    }

    f->ip = ip;
    f->readable = !(omode & O_WRONLY);
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

    if((omode & O_TRUNC) && ip->type == T_FILE){
    itrunc(ip);
    }

    iunlock(ip);
    end_op();
    return fd;

}

uint64
sys_write(void)
{
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
  argint(2, &n);
  if(argfd(0, 0, &f) < 0)
    return -1;

  return filewrite(f, p, n);
}

// fd void* src int len
uint64
sys_read(void){
    struct file* f;
    int n;
    uint64 p;
    argfd(0,0, &f);
    argaddr(1, &p);
    argint(2, &n);
    if(f < 0)
        return -1;

    return fileread(f, p, n);
}