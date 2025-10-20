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
int     write(int fd, const void *buf, int n);
int     read(int fd, void *buf, int n);
int     close(int fd);
int     getpid(void);
int     unlink(char *path);
int     uptime(void);


// ulib.c
void    start(int argc, char **argv);
uint    strcmp(const char *p, const char *q);
uint    strlen(const char *s);
void    itoa(int n, char *buf);
void    strcpy(char *dst, const char *src);
// printf.c
void printf(const char *fmt, ...);
void fprintf(int fd, const char *fmt, ...);
