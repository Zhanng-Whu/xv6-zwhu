#include "include/types.h"
#include "include/user.h"
int func(int a){
    return a;
}
int main(int argc, char *argv[]){
    hello();
    
    for(int i = 0; i < argc; i++){
        hello();

    }
    return 0;
}