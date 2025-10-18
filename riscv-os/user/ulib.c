#include "include/types.h"
#include "include/stat.h"
#include "include/fcntl.h"
#include "include/riscv.h"
#include "include/vm.h"
#include "include/user.h"


void
start(int argc, char **argv)
{
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);


  exit(r);
}
