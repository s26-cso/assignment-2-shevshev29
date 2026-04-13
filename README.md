[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)


## how to run a .s file q2
### you have to cd to q2
riscv64-linux-gnu-gcc -nostdlib -static q2.s -o q2

qemu-riscv64-static ./q2 85 96 70 80 102

## how to run q4 .c file
### you have to cd to q4
gcc -shared -fPIC addd.c -o libaddd.so
gcc q4.c -ldl -o calc
./calc

