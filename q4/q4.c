#include <stdio.h>
#include <dlfcn.h>
#include <string.h>

int main(){
    int num1, num2;
    char s[6];

    while(scanf("%s %d %d", s, &num1, &num2)==3){
        int result;
        char lib_name[25];
        // creating the library name with the operation for the dlopen to find and execute the operation
        strncpy(lib_name, "./lib", sizeof(lib_name));
        strncat (lib_name,s, sizeof(lib_name)- strlen(lib_name) - 1);
        strncat(lib_name, ".so",sizeof(lib_name)- strlen(lib_name) - 1);
        // we are loading the libs only during runtime , thus used dlfcn -> dlopen to load while prog is running
        void *handle=dlopen(lib_name, RTLD_LAZY);
        if(!handle){
            fprintf(stderr, "error: %s\n",dlerror());
            continue; // to continue to next input w/o crashing
        }
        int (*function)(int,int)=dlsym(handle, s);
        if(!function){
            fprintf(stderr,"error: function %s\n no found", s);
            dlclose(handle);
            continue;  // to continue to next input w/o crashing

        }
        //need to use the funct
        result=function(num1, num2);
        printf("%d\n", result);

        dlclose(handle); 

    }
    return 0;
    



}