1. First turn off address space randomization
sudo sysctl -w kernel.randomize_va_space=0

2. Compile the sample program with debugging symbol
gcc -fno-stack-protector -g -o sample sample.c

3. Start ddd or gdb
ddd ./sample

4. Set breakpoint at main()
(gdb) break main

5. Check register status
(gdb) info registers

6. Disassemble main function, pay attention to the instruction address after
   call sample_function
(gdb) disassemble main

7. Step into sample_function. Repeat until you are there.
(gdb) step

8. Check register status again. Notice the change in esp, and ebp
(gdb) info registers

9. Return address is located at $ebp+4. Display them as individual bytes and 
   word. 
(gdb) x/4b $ebp+4
(gdb) x/w $ebp+4

More about Linux memory layout and stack:
http://dirac.org/linux/gdb/02a-Memory_Layout_And_The_Stack.php
