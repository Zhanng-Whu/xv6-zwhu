#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/defs.h"
#include "include/spinlock.h"



static int nsizes;                                  // 这里的nsize表示的是能够分多少级别
static void *bd_base;                               // 伙伴系统的起始地址
typedef struct list List;

// 这里的sz_info 每一个对象都代表伙伴系统中的一类
// 而这里的alloc和split分别代表这一类中的分配和分裂情况
struct sz_info {
  List free;
  char *alloc;
  char *split;
};

typedef struct sz_info Sz_info;
struct spinlock lock;
static Sz_info *bd_sizes; 


// 伙伴系统的最小分配单元为一页
#define LEAF_SIZE PGSIZE                            // 分配的最小的页面大小
#define MAXSIZE (nsizes-1)                          // 最大的种类大小的索引
#define BLK_SIZE(k)   ((1L << (k)) * LEAF_SIZE)     // 第k种索引的块的大小
#define HEAP_SIZE     BLK_SIZE(MAXSIZE)             // 整个内存空间的大小 当然这里就是最大的种类的大小
#define NBLK(k)      (HEAP_SIZE / BLK_SIZE(k))      // 第k种索引的块的数量
#define ROUNDUP(n, sz)  (((((n)-1)/(sz))+1)*(sz))   // 向上取整

void* addr(int k, int bi){
  int n = bi * BLK_SIZE(k);
  return (char*) bd_base +n ;
}

// 计算地址addr在第k种索引中的块的编号
int 
blk_index(int k, void *addr) {
  return ((uint64)addr - (uint64)bd_base) / BLK_SIZE(k);
}

int 
bit_isset(char* bitmap, int index){
  char b = bitmap[index/8];
  char m = (1 << (index % 8));
  return (b & m) == m;
}

void bit_set(char* bitmap,int index){
  char b = bitmap[index/8];
  char m = (1 <<(index % 8));
  bitmap[index / 8] = (b | m);
}

// Clear bit at position index in array
void bit_clear(char *bitmap, int index) {
  char b = bitmap[index/8];
  char m = (1 << (index % 8));
  bitmap[index/8] = (b & ~m);
}

// 计算地址addr在第k种索引中的下一个块的编号
int 
blk_index_next(int k, void *addr) {
    int n = blk_index(k, addr);
    if(((uint64)addr - (uint64)bd_base) % BLK_SIZE(k) != 0)
        n++;
    return n;
}



// 如果一个块被标记为已经分配并且他的伙伴没有被分配，
// 那么把他的伙伴放在放在第k的伙伴列表上
// 如何两者都没有被分配，那么直接跳过并且返回空间 0
int
bd_initfree_pair(int k, int bi) {
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
  int free = 0;
  // 检查在两个伙伴之间在bitmap中的状态是否相同。
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    free = BLK_SIZE(k);
    if(bit_isset(bd_sizes[k].alloc, bi))
      lst_push(&bd_sizes[k].free, addr(k, buddy));   // put buddy on free list
    else
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
  }
  return free;
}

// 将bd_left到bd_right之间的所有空间标注为没有使用
int 
bd_initfree(void* bd_left, void* bd_right){
  int free = 0 ;

  for(int k = 0; k < MAXSIZE; k++){
    int left = blk_index_next(k, bd_left);
    int right = blk_index(k, bd_right);
    free += bd_initfree_pair(k, left);

    if(right <= left)
      continue;
    free += bd_initfree_pair(k, right);

  }
  return free;
}

// 将[start, stop)范围内的内存标记为已经分配
void
bd_mark(void *start, void *stop)
{
  int bi, bj;

  if (((uint64) start % LEAF_SIZE != 0) || ((uint64) stop % LEAF_SIZE != 0))
    panic("bd_mark");

  for (int k = 0; k < nsizes; k++) {
    bi = blk_index(k, start);
    bj = blk_index_next(k, stop);
    for(; bi < bj; bi++) {
      if(k > 0) {
        // 这里很好理解 如果一个块被分配了
        // 那么他肯定不能再分割了
        bit_set(bd_sizes[k].split, bi);
      }
      bit_set(bd_sizes[k].alloc, bi);
    }
  }
}

// 将从bd_base到p的全部空间标记为已经使用
// 唯一的用处就是用来处理bd_sizes本身所占用的空间
// 返回这一段空间的大小
int
bd_mark_data_structures(char *p) {
  int meta = p - (char*)bd_base; 
  printf("伙伴系统的从%p开始的%d字节为,总大小为%d字节的内存的元数据\n", (char*)bd_base, meta, BLK_SIZE(MAXSIZE));
  bd_mark(bd_base, p);
  return meta;
}

// 这里直接把最后一段内存提取出来标记为无用
// 这里传入的两个参数是 自由空间的起始位置和他右侧的元数据的大小
int bd_mark_unavailable(void* end, void * left){
    int unavailable = BLK_SIZE(MAXSIZE)-(end-bd_base);
    if(unavailable > 0)
        unavailable = ROUNDUP(unavailable, LEAF_SIZE);
    printf("bd: 0x%x bytes unavailable\n", unavailable);

    // 标记可以使用的内存
    // 这里的 unavailable就是 由于需要向上取整而实际上无效的空间
    void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;

    printf("%p\n", bd_end);

    bd_mark(bd_end, bd_base+BLK_SIZE(MAXSIZE));
    
    
    return unavailable;
}


void bd_init(void* start, void* end){
    char*p =(char* ) PGROUNDUP((uint64)start);
    initlock(&lock, "buddy");
    
    // 计算一下能够管理的块的种类的多少，比如最小的种类就是一个完整的页 
    // 最大的是一整个剩余的空间
    nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;

    if((char*)end-p > BLK_SIZE(MAXSIZE)) {
        nsizes++;  // round up to the next power of 2
    }
    printf("伙伴系统初始化，包含%d个级别,最小的单位为%d\n", nsizes, LEAF_SIZE);
    printf("from %p to %p\n", p, end);

    bd_base = (void*)p;
    // 为每一级别的分配和分裂情况分配空间
    bd_sizes = (Sz_info *) p;
    p += sizeof(Sz_info) * nsizes;
    memset(bd_sizes, 0, sizeof(Sz_info) * nsizes);

    // 为每一级别的列表分配空间
    for(int k = 0; k < nsizes; k++){
        lst_init(&bd_sizes[k].free);

        // printf("第%d类有%d个块\n", k + 1, NBLK(k));
        // printf("每一个块大小为0x%x字节\n", BLK_SIZE(k));    

        //这里的sz表示在alloc，也就是bitmap中需要分配多少字节 
        int sz = sizeof(char)* (ROUNDUP(NBLK(k), 8)) / 8;

        // printf("第%d类有%d个块\n", k + 1, NBLK(k));
        // printf("每一个块大小为0x%x字节\n", BLK_SIZE(k));    

        bd_sizes[k].alloc = p;
        memset(bd_sizes[k].alloc, 0, sz);
        p += sz;

    }

    for(int k = 1; k < nsizes; k++){
        int sz = sizeof(char)* (ROUNDUP(NBLK(k), 8)) / 8;
        bd_sizes[k].split = p;
        memset(bd_sizes[k].split, 0, sz);
        p += sz;
    }


    p = (char *) ROUNDUP((uint64) p, LEAF_SIZE);
    
    // 到这里为止，bd_sizes的所有空间的都分配完成了，剩下的内容就是真正的自由的内存
    // 但是在这里，还需要先对前面的内存打上标签，因为他们也是属于伙伴系统的一部分 

    int meta = bd_mark_data_structures(p);
    // 这里测试一下 可以发现最高的一位实际上已经使用了 这是很符合直觉的
    //printf("%d", bd_sizes[MAXSIZE].alloc[0] & 0xff);

    // 由于分配内存的时候需要向上取整，很明显最后需要多出一段内存
    // 这里直接使用对应的方法处理[end + 128MB, HEAP_SIZE)的空间
    int unavailable = bd_mark_unavailable(end, p);

    void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;

    int free = bd_initfree(p, bd_end);

    if(free != BLK_SIZE(MAXSIZE)-meta-unavailable){
      printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
      panic("bd_init: free mem");
    }

    printf("伙伴系统可用空间从%p到%p\n", p, (char*)bd_base+BLK_SIZE(MAXSIZE)-unavailable);

}

// 对于我们的需求，找到第一个满足要求的k索引
int firstk(uint64 n){
  int k = 0;
  uint64 size = LEAF_SIZE;

  while(size < n){
    k++;
    size *= 2;
  }
  return k;

}

void* bd_malloc(uint64 nbytes){
  int fk, k;
  acquire(&lock);

  fk = firstk(nbytes);
  for(k = fk; k < nsizes; k++){
    if(!lst_empty(&bd_sizes[k].free))
      break;
  }

  if(k >= nsizes){
    release(&lock);
    return 0;
  }

  
  char *p = lst_pop(&bd_sizes[k].free);
  bit_set(bd_sizes[k].alloc, blk_index(k, p));
  for(; k > fk; k--) {
    // split a block at size k and mark one half allocated at size k-1
    // and put the buddy on the free list at size k-1
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    bit_set(bd_sizes[k].split, blk_index(k, p));
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    lst_push(&bd_sizes[k-1].free, q);
  }
  release(&lock);

  return p;


}