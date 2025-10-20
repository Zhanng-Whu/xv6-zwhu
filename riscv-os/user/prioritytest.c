#include "include/types.h"
#include "include/param.h"
#include "include/fcntl.h"
#include "include/user.h"


int main(int argc, char const *argv[])
{
    
    int forknumber=atoi(argv[1]);
    int status;

    for(int i=0;i<forknumber;i++)
    {
        status=fork();
        if(status)
		{
	    	set_priority(status, i%4+1);   //在父进程中，将每个子进程的优先级设置为i%4+1.
        }
        if(status==0){
	    	for(int count=0;count<40; count++){
		    	for(int k=0;k<1000;k++){
					int result=0;
					for( int j=0; j<500; j++){
			    		result+=j*j;
                        result-=j*j;
                        result= result/j;
                        result=result*j;
                        result = result+result/j;
					}
		   		}
            }
            printf("进程 %d 完成任务，准备退出。\n", getpid());
            exit(1);
        }
    }
    return 0;
}