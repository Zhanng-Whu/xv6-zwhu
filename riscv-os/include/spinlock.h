#ifndef SPINLOCK
#define SPINLOCK
struct spinlock{
    uint locked;
    char* name;
    struct cpu* cpu;
};

#endif