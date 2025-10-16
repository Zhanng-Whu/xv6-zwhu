
#ifndef SLEEPLOCK
#define SLEEPLOCK

#include <include/spinlock.h>

struct sleeplock{
    uint locked;
    struct spinlock lk;
    char* name;
    int pid;
};

#endif
