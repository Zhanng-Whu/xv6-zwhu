#include "include/types.h"
#include "include/riscv.h"
#include "include/defs.h"
#include "include/param.h"
#include "include/stat.h"
#include "include/spinlock.h"
#include "include/proc.h"
#include "include/sleeplock.h"
#include "include/fs.h"
#include "include/buf.h"
#include "include/file.h"


struct superblock sb;


struct{
    struct spinlock lock;
    struct inode inode[NBUF];
} itable;

static void
bfree(int dev, int bbnum){
    struct buf* bp;
    int bi, m;

    // 这里的是数据块的Bitmap
    bp = bread(dev, BBLOCK(bbnum, sb));
    bi = bbnum % BPB;
    m = 1 << (bi % 8);
    if((bp->data[bi/8] & m) == 0)
        panic("bfree: freeing free block");
    bp->data[bi/8] &= ~m;
    log_write(bp);
    brelse(bp);
}

static char*
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  return path;
}

// 清零一个块
void bzero(int dev, int bno){
    struct buf* bp;

    bp = bread(dev, bno);
    memset(bp->data, 0, BSIZE);
    log_write(bp);
    brelse(bp);
}

// 从sb的bimtmap中找到一个空闲块
// 把他标记为已使用并返回块号
// 这个过程中会把块清零
// 并且通过日志系统写回硬盘
static uint
balloc(int dev){
    int b, bi, m;
    struct buf* bp;

    bp = 0;
    for(b = 0; b < sb.size; b += BPB){
        bp = bread(dev, BBLOCK(b, sb));
        for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
            m = 1 << (bi % 8);
            if((bp->data[bi/8] & m) == 0){ // Is block free?
                bp->data[bi/8] |= m; // Mark block in use.
                log_write(bp);
                brelse(bp);
                bzero(dev, b + bi);
                return b + bi;
            }
        }
        brelse(bp);
    }
      printf("balloc: out of blocks\n");
  return 0;
}

// 这个函数的逻辑是
// 获取ip下的第bn个块对应的磁盘块号
// 如果这个块没有被分配
// 那么调用balloc分配一个新的块
// 由于二级页表的存在
// 所以处理会稍微麻烦一点
static uint
bmap(struct inode* ip, uint bn){
    uint addr, *a;
    struct buf* bp;
    
    if(bn < NDIRECT){
        if((addr = ip->addrs[bn]) == 0){
            addr = balloc(ip->dev);
            if(addr == 0)
                return 0;
            ip->addrs[bn] = addr;
        }
        return addr;
    }

    bn -= NDIRECT;

    if(bn < NINDIRECT){
        
        // 如果这个二级页表还没有分配
        // 那么给他分配一个新的块
        if((addr = ip->addrs[NDIRECT]) == 0){
            addr = balloc(ip->dev);
            if(addr == 0)
                return 0;
            ip->addrs[NDIRECT] = addr;
        }

        // 然后从二级页表中读取对应的块号
        // 如果没有分配就分配一个新的块号
        bp = bread(ip->dev, addr);
        a = (uint*)bp->data;
        if((addr = a[bn]) == 0){
        addr = balloc(ip->dev);
        if(addr){
            a[bn] = addr;
            log_write(bp);
        }
        }
        brelse(bp);
        return addr;
    }
    
    panic("bmap: out of range");
    return -1;

}

static void 
readsb(int dev, struct superblock *sb){
    struct buf* bp;

    bp = bread(dev, 1);
    memmove(sb, bp->data, sizeof(*sb));
    brelse(bp);
}

void 
iinit(){
    int i = 0;

    initlock(&itable.lock, "itable");
    for(i = 0; i < NBUF; i++){
        initsleeplock(&itable.inode[i].lock, "inode");
    }
}

static struct inode*
iget(uint dev, uint inum){
    struct inode* ip, *empty;
        acquire(&itable.lock);

    empty = 0;
    for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
        ip->ref++;
        release(&itable.lock);
        return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
        empty = ip;
    }

    if(empty == 0)
        panic("iget: no inodes");

    ip = empty;
    ip->dev = dev;
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    release(&itable.lock);

    return ip;
}

void ilock(struct inode* ip){
    struct buf* bp;
    struct dinode* dip;

    if(ip == 0 || ip->ref < 1)
        panic("ilock");

    acquiresleep(&ip->lock);

    if(ip->valid == 0){
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
        dip = (struct dinode*)bp->data + ip->inum%IPB;
        ip->type = dip->type;
        ip->major = dip->major;
        ip->minor = dip->minor;
        ip->nlink = dip->nlink;
        ip->size = dip->size;
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
        brelse(bp);
        ip->valid = 1;
        if(ip->type == 0)
        panic("ilock: no type");
    }
}
void iunlock(struct inode* ip){
    if(ip == 0 || ip->ref < 1 || !holdingsleep(&ip->lock))
        panic("iunlock");
    releasesleep(&ip->lock);
}

void iupdate(struct inode* ip){
    if(ip == 0 || !holdingsleep(&ip->lock))
        panic("iupdate");
    
    struct buf* bp;
    struct dinode* dip;
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    dip->type = ip->type;
    dip->major = ip->major;
    dip->minor = ip->minor;
    dip->nlink = ip->nlink;
    dip->size = ip->size;
    memmove(dip->addrs, ip->addrs, sizeof(dip->addrs));
    log_write(bp);
    brelse(bp);
}

void itrunc(struct inode* ip){
    int i, j;
    struct buf* bp;
    uint* a;

    // 这里对一级页表
    // 明天从这里开始
    // 昨天在写文件系统初始化 
    // 写完这里就可以去牢forkret
    // 然后开始了牢exec了
    
    for( i = 0; i < NDIRECT; i++){
        if(ip->addrs[i]){
            bfree(ip->dev, ip->addrs[i]);
            ip->addrs[i] = 0;                   
        }
    }

    if(ip->addrs[NDIRECT]){
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
        a = (uint*) bp->data;

        for(j = 0 ; j < NINDIRECT; j++){
            if(a[j]){
                bfree(ip->dev, a[j]);
            }
        }
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    iupdate(ip);
}


void iput(struct inode* ip){
    acquire(&itable.lock);
    if(ip->ref == 1  && ip->nlink == 0){
        acquiresleep(&ip->lock);

        release(&itable.lock);
        
        itrunc(ip);
        ip->type = 0;
        iupdate(ip);
        ip->valid = 0;

        releasesleep(&ip->lock);
        acquire(&itable.lock);

    }
    ip->ref--;
    release(&itable.lock);
}

// 这位更是重量级
// 读取文件的API
// 从ip的文件中读取数据
// 复制到dst的地址中,
// off代表偏移
// n代表读取的字节数
// user_dst代表是用户地址还是内核地址
// 如果是内核地址直接通过memmove复制
// 如果是用户地址 需要使用当前PCB的pagetable 分配内存 
// 然后用mapPage实现物理内存到pagetable的映射
// 然后再复制
// 返回值为成功读取的字节数

#define min(a,b) ((a) < (b) ? (a) : (b))
int
readi(struct inode* ip, int user_dst, uint64 dst, uint off, uint n){
    uint tot, m;
    struct buf* bp;

    if(off > ip->size || off + n < off)
        return 0;
    
    if(off + n > ip->size)
        n = ip->size - off;

    for(tot = 0; tot < n; tot += m, off += m, dst += m){
        uint addr = bmap(ip, off / BSIZE);

        if(addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
        if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1){
            brelse(bp);
            tot = -1;
            break;
        }
        brelse(bp);
    }

    return tot;
}


// 在当前目录inode下搜索name对应的文件
// 并且返回对应的inode和偏移量
// poff是在当前文件夹inode->data的偏移量
// 如果不需要 那么直接让poff=NULL即可

struct inode*
dirlookup(struct inode* dp, char* name, uint* poff){
    uint off, inum;
    struct dirent de;
    
    if(dp->type != T_DIR)
        panic("dirlookup not DIR");

    for(off = 0; off < dp->size; off += sizeof(de)){   
        if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
            panic("dirlookup read");
        if(de.inum == 0)
            continue;
        if(strncmp(name, de.name, DIRSIZ) == 0){
            // entry found
            if(poff)
                *poff = off;
            inum = de.inum;
            return iget(dp->dev, inum);
        }
    }

    return 0;
}

struct inode*
idup(struct inode* ip){
    acquire(&itable.lock);
    ip->ref++;
    release(&itable.lock);
    return ip;
}

void 
ireclaim(int dev){
    // 为什么从1开始?
    // 因为1是根目录的inode号
    // 不存在0的inode
    for(int inum = 1; inum < sb.ninodes; inum++){
        struct inode* ip = 0;
        struct buf* bp = bread(dev, IBLOCK(inum, sb));
        struct dinode* dip = (struct dinode *)bp->data + inum % IPB;

        if(dip -> type != 0 && dip->nlink == 0){
            printf("ireclaim : 一个异常文件 %d\n", inum);
            ip = iget(dev, inum);       
        }

        brelse(bp);
        if(ip){
            begin_op();

            // 其实这几个函数写的不算很好
            // ilock的功能是 从itable里面找到符合要求的inode (被iget处理好了位置)
            // 如果itable里面没有 那么根据sb的内容从disk里面读取
            // 并且把它上给当前的进程的锁
            ilock(ip);
            // 但是iunlock又只有放锁的内容
            iunlock(ip);
            // iput也不算是释放内存的 
            // 因为inode的逻辑实际上是抢占的(当然不是抢占正在使用的inode) 
            // 是抢占没有在使用的inode 所以其实不需要释放内存
            // iput的功能更像是判断disk的情况 如果disk里面没有硬link并且内存也不需要他
            // 那么直接释放对应的disk空间和内存空间.
            iput(ip);

            end_op();
        }
    }
}

void
fsinit(int dev){
    readsb(dev, &sb);
    if(sb.magic != FSMAGIC)
        panic("invalid file system");
    initlog(dev, &sb);
    ireclaim(dev);
}




static struct inode*
namex(char* path, int nameiparent, char* name){
    struct inode* ip, *next;

    if(*path == '/')
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);

    while((path = skipelem(path, name)) != 0){
        ilock(ip);
        if(ip->type != T_DIR){
            iunlock(ip);
            iput(ip);
            return 0;
        }

        if(nameiparent && *path == '\0'){
            // stop one level early
            iunlock(ip);
            return ip;
        }

        if((next = dirlookup(ip, name, 0)) == 0){
            iunlock(ip);
            iput(ip);
            return 0;
        }

        iunlock(ip);
        iput(ip);
        ip = next;
    }

    if(nameiparent){
        iput(ip);
        return 0;
    }
    return ip;
    
}

struct inode* 
namei(char* path){
    char name[DIRSIZ];
    return namex(path, 0, name);
}

// 根据路径找到路径的目录的inode
// 并且将对应的文件存入name中
// 比如 /a/b/c 这个路径
// 传入 /a/b/c 以及 name
// 那么返回 /a/b 目录的inode
// 并且将 c 存入 name 中
// 如果路径不存在就会返回NULL
struct inode*
nameiparent(char* path, char* name){
    return namex(path, 1, name);
}
