#include "include/types.h"
#include "include/stat.h"
#include "include/fcntl.h"
#include "include/riscv.h"
#include "include/vm.h"
#include "include/user.h"


void
start(int argc, char **argv)
{
  extern int main(int argc, char **argv);
    main(argc, argv);

  for(;;);
  
}
