#define SBRK_ERROR ((char *)-1)

struct stat;

// system calls
int     hello(void);
void    exit(int status) __attribute__((noreturn));
int     wait(int *xstatus);
int     fork(void); 
int     exec(char *path, char **argv);
int     open(char *path, int mode); 
int     dup(int fd);
int     mknod(char *path, short major, short minor);


// ulib.c
void start(int argc, char **argv);


