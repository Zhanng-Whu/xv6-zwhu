// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/spinlock.h"
#include "include/riscv.h"
#include "include/defs.h"

void freerange(void *pa_start, void *pa_end);


extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
  char* bitmap;
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}


void* addr_base;

#define PAGE_INDEX(addr) (((uint64)addr - (uint64)addr_base) / PGSIZE)

// 从 addr_base 的第几个空间开始
void list_bit_set(int index){
    int c = index / 8;
    int b = index % 8;
    kmem.bitmap[c] |= (1 << b);
}

void list_bit_clear(int index){
    int c = index / 8;
    int b = index % 8;
    kmem.bitmap[c] &= ~(1 << b);
}

int list_bit_isset(int index){
    int c = index / 8;
    int b = index % 8;
    return (kmem.bitmap[c] >> b) & 1;
}

void
freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char*)PGROUNDUP((uint64)pa_start);

    addr_base = p;

    int cnt = ((char*)pa_end - p + PGSIZE - 1) / PGSIZE;

    printf("内存中一共包含%d个页\n", cnt);
    printf("from 0x%x to 0x%x\n", p, pa_end);
    int meta_sz = (cnt + 8 * PGSIZE - 1) / (8 * PGSIZE);
    printf("%d页的位图空间被分配用于内存管理\n", meta_sz);
    printf("from 0x%x to 0x%x\n", p, p + meta_sz * PGSIZE);
    memset(p, 0, meta_sz * PGSIZE);
    
    p += meta_sz * PGSIZE;
    
    kmem.bitmap = (char*)addr_base;
    
    memset(kmem.bitmap,0xff, meta_sz * PGSIZE); // 先全部标记为已经使用
    
    for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
        kfree(p);
    }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

     // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);

    r = (struct run*)pa;
    if(!list_bit_isset(PAGE_INDEX(pa)))
      panic("kfree: 重复释放内存");

    list_bit_clear(PAGE_INDEX(pa));

    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);

}


// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void){
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;

  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  list_bit_set(PAGE_INDEX(r));
  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
  }
  return (void*)r;
}