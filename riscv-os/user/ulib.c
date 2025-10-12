#include "include/types.h"
#include "include/stat.h"
#include "include/fcntl.h"
#include "include/riscv.h"
#include "include/vm.h"
#include "user/user.h"

//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
}
