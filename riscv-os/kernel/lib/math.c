#include "include/types.h"
#include "include/param.h"
#include "include/memlayout.h"
#include "include/riscv.h"
#include "include/defs.h"


int log2(uint64 x){
    int k = 0;
    while(x > 1){
        k++;
        x >>=1;
    }
    return k;
}

// 返回a的n次方 使用快速幂
int power(int a, int n){
    int base = a;
    int sum = 1;
    while(n){
        if(n & 1) sum *= base;
        base *= base;
        n >>= 1;
    }
    return sum;
}