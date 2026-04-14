#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>
int main(){
    char op[6];
    int num1,num2;
    while(1){
        if(scanf("%5s %d %d",op,&num1,&num2)!=3){
            break;
        }
        char lib[16];
        snprintf(lib,sizeof(lib),"./lib%s.so",op);
        void *lib_ptr=dlopen(lib,RTLD_LAZY);
        int(*f)(int,int);
        *(void**)(&f)=dlsym(lib_ptr,op);
        int ans=f(num1,num2);
        printf("%d\n",ans);
        dlclose(lib_ptr);
    }
    return 0;
}