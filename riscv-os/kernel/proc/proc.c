#include "include/types.h"
#include "include/riscv.h"
#include "include/proc.h"
#include "include/param.h"

struct cpu cpus[NCPU];

int cpuid() {
  int id = r_tp();
  return id;
}

struct cpu* 
mycpu(void){
    struct cpu *c = &cpus[cpuid()];
    return c;
}
