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


void
itoa(int n, char *buf)
{
  char temp[16];
  int i = 0;
  int j = 0;

  if (n == 0) {
    buf[0] = '0';
    buf[1] = '\0';
    return;
  }
  
  // Generate digits in reverse order
  while (n > 0) {
    temp[i++] = (n % 10) + '0';
    n /= 10;
  }
  temp[i] = '\0';

  // Reverse the string to get the correct order
  for (j = 0; j < i; j++) {
    buf[j] = temp[i - 1 - j];
  }
  buf[j] = '\0';
}

void strcpy(char *dst, const char *src) {
    while ((*dst++ = *src++) != '\0');
} 

uint
strlen(const char *s){
  int n;
  for(n = 0; s[n]; n++);
  return n;
}

uint
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
