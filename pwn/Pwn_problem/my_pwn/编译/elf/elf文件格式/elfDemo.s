	.file	"elfDemo.c"
	.text
	.globl	hex_table
	.section	.rodata
	.align 16
	.type	hex_table, @object
	.size	hex_table, 16
hex_table:
	.ascii	"0123456789ABCDEF"
.LC1:
	.string	"11b"
.LC2:
	.string	"NO"
.LC3:
	.string	"YES"
	.text
	.globl	main
	.type	main, @function
main:
.LFB26:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1088, %rsp
	movl	%edi, -1076(%rbp)
	movq	%rsi, -1088(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	.LC1(%rip), %rax
	movq	%rax, -1064(%rbp)
	leaq	-1040(%rbp), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	gets@PLT
	leaq	-1040(%rbp), %rcx
	leaq	-1056(%rbp), %rax
	movl	$10, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	leaq	-1056(%rbp), %rax
	movq	%rax, %rdi
	call	rabin_wit
	xorl	$1, %eax
	testb	%al, %al
	je	.L2
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	jmp	.L3
.L2:
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
.L3:
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	xorq	%fs:40, %rdx
	je	.L5
	call	__stack_chk_fail@PLT
.L5:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE26:
	.size	main, .-main
	.globl	gcd
	.type	gcd, @function
gcd:
.LFB27:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	-4(%rbp), %eax
	cltd
	idivl	-8(%rbp)
	movl	%edx, %eax
	testl	%eax, %eax
	jne	.L7
	movl	-8(%rbp), %eax
	jmp	.L8
.L7:
	movl	-4(%rbp), %eax
	cltd
	idivl	-8(%rbp)
	movl	-8(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	gcd
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	gcd, .-gcd
	.globl	xor
	.type	xor, @function
xor:
.LFB28:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %edx
	movl	%esi, %eax
	movb	%dl, -4(%rbp)
	movb	%al, -8(%rbp)
	movzbl	-4(%rbp), %eax
	subl	$48, %eax
	movl	%eax, %edx
	movzbl	-8(%rbp), %eax
	subl	$48, %eax
	xorl	%edx, %eax
	addl	$48, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	xor, .-xor
	.globl	standard
	.type	standard, @function
standard:
.LFB29:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-56(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	$0, -40(%rbp)
	leaq	-32(%rbp), %rdx
	movq	-40(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L13
	call	__stack_chk_fail@PLT
.L13:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	standard, .-standard
	.globl	GF_2_xor
	.type	GF_2_xor, @function
GF_2_xor:
.LFB30:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -56(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -64(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -32(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -28(%rbp)
	movl	-32(%rbp), %eax
	cmpl	%eax, -28(%rbp)
	cmovge	-28(%rbp), %eax
	movl	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	addl	$1, %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -24(%rbp)
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	subl	$1, -36(%rbp)
	movl	-32(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -44(%rbp)
	movl	-28(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -40(%rbp)
	jmp	.L15
.L17:
	movl	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %ecx
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %edx
	movl	-36(%rbp), %eax
	leal	-1(%rax), %esi
	movl	%esi, -36(%rbp)
	movslq	%eax, %rsi
	movq	-24(%rbp), %rax
	leaq	(%rsi,%rax), %rbx
	movl	%ecx, %esi
	movl	%edx, %edi
	call	xor
	movb	%al, (%rbx)
	subl	$1, -44(%rbp)
	subl	$1, -40(%rbp)
.L15:
	cmpl	$0, -44(%rbp)
	js	.L16
	cmpl	$0, -40(%rbp)
	jns	.L17
.L16:
	cmpl	$-1, -44(%rbp)
	jne	.L22
	jmp	.L19
.L20:
	movl	-40(%rbp), %eax
	leal	-1(%rax), %edx
	movl	%edx, -40(%rbp)
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-36(%rbp), %eax
	leal	-1(%rax), %edx
	movl	%edx, -36(%rbp)
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movzbl	(%rcx), %eax
	movb	%al, (%rdx)
.L19:
	cmpl	$0, -40(%rbp)
	jns	.L20
	jmp	.L21
.L23:
	movl	-44(%rbp), %eax
	leal	-1(%rax), %edx
	movl	%edx, -44(%rbp)
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-36(%rbp), %eax
	leal	-1(%rax), %edx
	movl	%edx, -36(%rbp)
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movzbl	(%rcx), %eax
	movb	%al, (%rdx)
.L22:
	cmpl	$0, -44(%rbp)
	jns	.L23
.L21:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	GF_2_xor, .-GF_2_xor
	.globl	GF_2_poly_division
	.type	GF_2_poly_division, @function
GF_2_poly_division:
.LFB31:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$88, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -88(%rbp)
	movq	%rsi, -96(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -96(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	subl	$1, %eax
	movl	%eax, -64(%rbp)
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	subl	$1, %eax
	movl	%eax, -60(%rbp)
	movl	$2048, %edi
	call	malloc@PLT
	movq	%rax, -56(%rbp)
	movq	-88(%rbp), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT
	movl	-64(%rbp), %eax
	cmpl	-60(%rbp), %eax
	jge	.L26
	movl	$2048, %edi
	call	malloc@PLT
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movb	$48, (%rax)
	movq	-40(%rbp), %rax
	addq	$1, %rax
	movb	$0, (%rax)
	movq	-40(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	jmp	.L33
.L26:
	movl	-64(%rbp), %eax
	subl	-60(%rbp), %eax
	addl	$2, %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -48(%rbp)
	movl	-64(%rbp), %eax
	subl	-60(%rbp), %eax
	addl	$2, %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movl	-64(%rbp), %eax
	subl	-60(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	$0, -76(%rbp)
	movl	$0, -72(%rbp)
	movl	$0, -68(%rbp)
	jmp	.L28
.L32:
	movl	-72(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	leal	-48(%rax), %edx
	movq	-96(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	leal	-48(%rax), %ecx
	movl	%edx, %eax
	cltd
	idivl	%ecx
	leal	48(%rax), %ecx
	movl	-76(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movl	-76(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$49, %al
	jne	.L29
	movl	$0, -68(%rbp)
	jmp	.L30
.L31:
	movl	-68(%rbp), %eax
	movslq	%eax, %rdx
	movq	-96(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %edx
	movl	-68(%rbp), %ecx
	movl	-72(%rbp), %eax
	addl	%ecx, %eax
	movslq	%eax, %rcx
	movq	-56(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	-68(%rbp), %esi
	movl	-72(%rbp), %ecx
	addl	%esi, %ecx
	movslq	%ecx, %rsi
	movq	-56(%rbp), %rcx
	leaq	(%rsi,%rcx), %rbx
	movl	%edx, %esi
	movl	%eax, %edi
	call	xor
	movb	%al, (%rbx)
	addl	$1, -68(%rbp)
.L30:
	movl	-60(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jge	.L31
.L29:
	addl	$1, -76(%rbp)
	addl	$1, -72(%rbp)
.L28:
	movl	-64(%rbp), %eax
	subl	-60(%rbp), %eax
	cmpl	%eax, -72(%rbp)
	jle	.L32
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -48(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
.L33:
	addq	$88, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	GF_2_poly_division, .-GF_2_poly_division
	.globl	GF_2_poly_multiplication
	.type	GF_2_poly_multiplication, @function
GF_2_poly_multiplication:
.LFB32:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -56(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -64(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -32(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -28(%rbp)
	movl	$1, -36(%rbp)
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -24(%rbp)
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	movl	$48, %esi
	movq	%rax, %rdi
	call	memset@PLT
	movl	-32(%rbp), %edx
	movl	-28(%rbp), %eax
	addl	%edx, %eax
	cltq
	leaq	-1(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	-28(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -44(%rbp)
	jmp	.L35
.L39:
	movl	-44(%rbp), %eax
	movslq	%eax, %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$49, %al
	jne	.L36
	movl	-32(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -40(%rbp)
	jmp	.L37
.L38:
	movl	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %edx
	movl	-40(%rbp), %ecx
	movl	-28(%rbp), %eax
	addl	%ecx, %eax
	subl	-36(%rbp), %eax
	movslq	%eax, %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	-40(%rbp), %esi
	movl	-28(%rbp), %ecx
	addl	%esi, %ecx
	subl	-36(%rbp), %ecx
	movslq	%ecx, %rsi
	movq	-24(%rbp), %rcx
	leaq	(%rsi,%rcx), %rbx
	movl	%edx, %esi
	movl	%eax, %edi
	call	xor
	movb	%al, (%rbx)
	subl	$1, -40(%rbp)
.L37:
	cmpl	$0, -40(%rbp)
	jns	.L38
.L36:
	subl	$1, -44(%rbp)
	addl	$1, -36(%rbp)
.L35:
	cmpl	$0, -44(%rbp)
	jns	.L39
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	GF_2_poly_multiplication, .-GF_2_poly_multiplication
	.globl	GF_2_add_sub
	.type	GF_2_add_sub, @function
GF_2_add_sub:
.LFB33:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	$0, -24(%rbp)
	movq	-48(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GF_2_xor
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GF_2_poly_division
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-8(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE33:
	.size	GF_2_add_sub, .-GF_2_add_sub
	.globl	GF_2_mul
	.type	GF_2_mul, @function
GF_2_mul:
.LFB34:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-48(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GF_2_poly_multiplication
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GF_2_poly_division
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-8(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE34:
	.size	GF_2_mul, .-GF_2_mul
	.globl	GF_2_hex_cal
	.type	GF_2_hex_cal, @function
GF_2_hex_cal:
.LFB35:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$160, %rsp
	movl	%edi, %eax
	movq	%rsi, -144(%rbp)
	movq	%rdx, -152(%rbp)
	movq	%rcx, -160(%rbp)
	movb	%al, -132(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-144(%rbp), %rcx
	leaq	-80(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-152(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-160(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	$0, -120(%rbp)
	movq	$0, -112(%rbp)
	movq	$0, -104(%rbp)
	movq	$0, -96(%rbp)
	movq	$0, -88(%rbp)
	leaq	-80(%rbp), %rdx
	movq	-120(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -120(%rbp)
	leaq	-64(%rbp), %rdx
	movq	-112(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -112(%rbp)
	leaq	-48(%rbp), %rdx
	movq	-104(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -104(%rbp)
	cmpb	$43, -132(%rbp)
	je	.L46
	cmpb	$45, -132(%rbp)
	jne	.L47
.L46:
	movq	-104(%rbp), %rdx
	movq	-112(%rbp), %rcx
	movq	-120(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	GF_2_add_sub
	movq	%rax, -96(%rbp)
	jmp	.L48
.L47:
	cmpb	$42, -132(%rbp)
	jne	.L49
	movq	-104(%rbp), %rdx
	movq	-112(%rbp), %rcx
	movq	-120(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	GF_2_mul
	movq	%rax, -96(%rbp)
	jmp	.L48
.L49:
	cmpb	$47, -132(%rbp)
	jne	.L48
	movq	-112(%rbp), %rdx
	movq	-120(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GF_2_poly_division
	movq	%rax, -96(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-88(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-88(%rbp), %rax
	leaq	-48(%rbp), %rdx
	movl	$16, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -88(%rbp)
.L48:
	movq	-96(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-96(%rbp), %rax
	leaq	-32(%rbp), %rdx
	movl	$16, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	-88(%rbp), %rdx
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L51
	call	__stack_chk_fail@PLT
.L51:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE35:
	.size	GF_2_hex_cal, .-GF_2_hex_cal
	.globl	GF_2_Fp
	.type	GF_2_Fp, @function
GF_2_Fp:
.LFB36:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -40(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -48(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -56(%rbp)
	movl	$2048, %edi
	call	malloc@PLT
	movq	%rax, -16(%rbp)
	movl	$2048, %edi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -20(%rbp)
	movq	-40(%rbp), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT
	movl	-20(%rbp), %eax
	cltq
	leaq	-1(%rax), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$49, %al
	jne	.L53
	movq	-40(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT
	jmp	.L54
.L53:
	movq	-16(%rbp), %rax
	movw	$49, (%rax)
.L54:
	movl	-20(%rbp), %eax
	subl	$2, %eax
	movl	%eax, -24(%rbp)
	jmp	.L55
.L57:
	movq	-56(%rbp), %rdx
	movq	-8(%rbp), %rcx
	movq	-8(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	GF_2_mul
	movq	%rax, -8(%rbp)
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$49, %al
	jne	.L56
	movq	-56(%rbp), %rdx
	movq	-8(%rbp), %rcx
	movq	-16(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	GF_2_mul
	movq	%rax, -16(%rbp)
.L56:
	subl	$1, -24(%rbp)
.L55:
	cmpl	$0, -24(%rbp)
	jns	.L57
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE36:
	.size	GF_2_Fp, .-GF_2_Fp
	.globl	GF_2_hex_Fp
	.type	GF_2_hex_Fp, @function
GF_2_hex_Fp:
.LFB37:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$144, %rsp
	movq	%rdi, -120(%rbp)
	movq	%rsi, -128(%rbp)
	movq	%rdx, -136(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-120(%rbp), %rcx
	leaq	-80(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-128(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movl	$10, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-136(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	$0, -112(%rbp)
	movq	$0, -104(%rbp)
	movq	$0, -96(%rbp)
	leaq	-80(%rbp), %rdx
	movq	-112(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -112(%rbp)
	leaq	-64(%rbp), %rdx
	movq	-104(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -104(%rbp)
	leaq	-48(%rbp), %rdx
	movq	-96(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -96(%rbp)
	movq	-96(%rbp), %rdx
	movq	-104(%rbp), %rcx
	movq	-112(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	GF_2_Fp
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	leaq	-32(%rbp), %rdx
	movq	-88(%rbp), %rax
	movl	$16, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L61
	call	__stack_chk_fail@PLT
.L61:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE37:
	.size	GF_2_hex_Fp, .-GF_2_hex_Fp
	.globl	GF_2_exEuclid
	.type	GF_2_exEuclid, @function
GF_2_exEuclid:
.LFB38:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%rdx, -88(%rbp)
	movq	%rcx, -96(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -80(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -88(%rbp)
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	standard
	movq	%rax, -96(%rbp)
	movq	-88(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$48, %al
	jne	.L63
	movq	-80(%rbp), %rax
	movq	%rax, -64(%rbp)
	movl	$2048, %edi
	call	malloc@PLT
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movw	$49, (%rax)
	movq	-88(%rbp), %rax
	movq	%rax, -48(%rbp)
	movq	-72(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	%rax, 16(%rcx)
	jmp	.L62
.L63:
	movq	-88(%rbp), %rdx
	movq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GF_2_poly_division
	movq	%rdx, %rdi
	leaq	-32(%rbp), %rax
	movq	-96(%rbp), %rdx
	movq	-88(%rbp), %rsi
	movq	%rdx, %rcx
	movq	%rdi, %rdx
	movq	%rax, %rdi
	call	GF_2_exEuclid
	movq	-32(%rbp), %rax
	movq	%rax, -64(%rbp)
	movq	-16(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-88(%rbp), %rdx
	movq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GF_2_poly_division
	movq	%rax, %rcx
	movq	-16(%rbp), %rax
	movq	-96(%rbp), %rdx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	GF_2_mul
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	GF_2_xor
	movq	%rax, -48(%rbp)
	movq	-72(%rbp), %rcx
	movq	-64(%rbp), %rax
	movq	-56(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-48(%rbp), %rax
	movq	%rax, 16(%rcx)
.L62:
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L66
	call	__stack_chk_fail@PLT
.L66:
	movq	-72(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE38:
	.size	GF_2_exEuclid, .-GF_2_exEuclid
	.globl	GF_2_hex_exEuclid
	.type	GF_2_hex_exEuclid, @function
GF_2_hex_exEuclid:
.LFB39:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$208, %rsp
	movq	%rdi, -184(%rbp)
	movq	%rsi, -192(%rbp)
	movq	%rdx, -200(%rbp)
	movq	%rcx, -208(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-192(%rbp), %rcx
	leaq	-112(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-200(%rbp), %rcx
	leaq	-96(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-208(%rbp), %rcx
	leaq	-80(%rbp), %rax
	movl	$16, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	$0, -168(%rbp)
	movq	$0, -160(%rbp)
	movq	$0, -152(%rbp)
	leaq	-112(%rbp), %rdx
	movq	-168(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -168(%rbp)
	leaq	-96(%rbp), %rdx
	movq	-160(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -160(%rbp)
	leaq	-80(%rbp), %rdx
	movq	-152(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -152(%rbp)
	leaq	-144(%rbp), %rax
	movq	-152(%rbp), %rcx
	movq	-160(%rbp), %rdx
	movq	-168(%rbp), %rsi
	movq	%rax, %rdi
	call	GF_2_exEuclid
	movq	-144(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-144(%rbp), %rax
	leaq	-32(%rbp), %rdx
	movl	$16, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -144(%rbp)
	movq	-136(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-136(%rbp), %rax
	leaq	-64(%rbp), %rdx
	movl	$16, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -136(%rbp)
	movq	-128(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movl	$2, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-128(%rbp), %rax
	leaq	-48(%rbp), %rdx
	movl	$16, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -128(%rbp)
	movq	-184(%rbp), %rcx
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-128(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L69
	call	__stack_chk_fail@PLT
.L69:
	movq	-184(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE39:
	.size	GF_2_hex_exEuclid, .-GF_2_hex_exEuclid
	.globl	gcdext
	.type	gcdext, @function
gcdext:
.LFB40:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$256, %rsp
	movq	%rdi, -232(%rbp)
	movq	%rsi, -240(%rbp)
	movq	%rdx, -248(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-240(%rbp), %rcx
	leaq	-160(%rbp), %rax
	movl	$10, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	movq	-248(%rbp), %rcx
	leaq	-144(%rbp), %rax
	movl	$10, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_str@PLT
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-80(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_si@PLT
	leaq	-144(%rbp), %rdi
	leaq	-160(%rbp), %rcx
	leaq	-112(%rbp), %rdx
	leaq	-128(%rbp), %rsi
	leaq	-96(%rbp), %rax
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	__gmpz_gcdext@PLT
	leaq	-96(%rbp), %rdx
	leaq	-160(%rbp), %rcx
	leaq	-160(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_fdiv_q@PLT
	leaq	-96(%rbp), %rdx
	leaq	-144(%rbp), %rcx
	leaq	-144(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_fdiv_q@PLT
	leaq	-144(%rbp), %rdx
	leaq	-128(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-64(%rbp), %rdx
	leaq	-128(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_sub@PLT
	leaq	-144(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_fdiv_q@PLT
	leaq	-160(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-32(%rbp), %rdx
	leaq	-112(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
	movq	$0, -216(%rbp)
	movq	$0, -208(%rbp)
	movq	$0, -200(%rbp)
	leaq	-64(%rbp), %rdx
	movq	-216(%rbp), %rax
	movl	$10, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -216(%rbp)
	leaq	-48(%rbp), %rdx
	movq	-208(%rbp), %rax
	movl	$10, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -208(%rbp)
	leaq	-96(%rbp), %rdx
	movq	-200(%rbp), %rax
	movl	$10, %esi
	movq	%rax, %rdi
	call	__gmpz_get_str@PLT
	movq	%rax, -200(%rbp)
	movq	-216(%rbp), %rax
	movq	%rax, -184(%rbp)
	movq	-208(%rbp), %rax
	movq	%rax, -176(%rbp)
	movq	-200(%rbp), %rax
	movq	%rax, -192(%rbp)
	movq	-232(%rbp), %rcx
	movq	-192(%rbp), %rax
	movq	-184(%rbp), %rdx
	movq	%rax, (%rcx)
	movq	%rdx, 8(%rcx)
	movq	-176(%rbp), %rax
	movq	%rax, 16(%rcx)
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L72
	call	__stack_chk_fail@PLT
.L72:
	movq	-232(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE40:
	.size	gcdext, .-gcdext
	.section	.rodata
.LC4:
	.string	"%d,"
	.text
	.globl	Eeatosthese
	.type	Eeatosthese, @function
Eeatosthese:
.LFB41:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$88, %rsp
	.cfi_offset 3, -24
	movl	%edi, -84(%rbp)
	cvtsi2sdl	-84(%rbp), %xmm0
	call	sqrt@PLT
	cvttsd2sil	%xmm0, %eax
	movl	%eax, -36(%rbp)
	movl	-36(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movl	$2, (%rax)
	movl	$1, -72(%rbp)
	movl	$1, -72(%rbp)
	jmp	.L74
.L75:
	movl	-72(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	$0, (%rax)
	addl	$1, -72(%rbp)
.L74:
	movl	-72(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L75
	movl	$1, -68(%rbp)
	movl	$3, -64(%rbp)
	jmp	.L76
.L81:
	movl	$0, -60(%rbp)
	jmp	.L77
.L80:
	movl	-60(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %ecx
	movl	-64(%rbp), %eax
	cltd
	idivl	%ecx
	movl	%edx, %eax
	testl	%eax, %eax
	addl	$1, -60(%rbp)
.L77:
	movl	-60(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jge	.L79
	movl	-60(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %ebx
	cvtsi2sdl	-64(%rbp), %xmm0
	call	sqrt@PLT
	cvttsd2sil	%xmm0, %eax
	cmpl	%eax, %ebx
	jle	.L80
.L79:
	movl	-68(%rbp), %eax
	leal	1(%rax), %edx
	movl	%edx, -68(%rbp)
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movl	-64(%rbp), %eax
	movl	%eax, (%rdx)
	addl	$1, -64(%rbp)
.L76:
	movl	-64(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jle	.L81
	movl	-84(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movb	$0, (%rax)
	movl	$1, -56(%rbp)
	jmp	.L82
.L83:
	movl	-56(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$1, (%rax)
	addl	$1, -56(%rbp)
.L82:
	movl	-56(%rbp), %eax
	cmpl	-84(%rbp), %eax
	jl	.L83
	movl	$0, -52(%rbp)
	jmp	.L84
.L87:
	movl	$2, -48(%rbp)
	jmp	.L85
.L86:
	movl	-52(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	imull	-48(%rbp), %eax
	cltq
	leaq	-1(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	addl	$1, -48(%rbp)
.L85:
	movl	-52(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	imull	-48(%rbp), %eax
	cmpl	%eax, -84(%rbp)
	jge	.L86
	addl	$1, -52(%rbp)
.L84:
	movl	-52(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jne	.L87
	movl	$0, -44(%rbp)
	movl	$0, -40(%rbp)
	jmp	.L88
.L90:
	movl	-40(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L89
	movl	-40(%rbp), %eax
	addl	$1, %eax
	movl	%eax, %esi
	leaq	.LC4(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -44(%rbp)
	movl	-44(%rbp), %eax
	andl	$15, %eax
	testl	%eax, %eax
	jne	.L89
	movl	$10, %edi
	call	putchar@PLT
.L89:
	addl	$1, -40(%rbp)
.L88:
	movl	-40(%rbp), %eax
	cmpl	-84(%rbp), %eax
	jl	.L90
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	addq	$88, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE41:
	.size	Eeatosthese, .-Eeatosthese
	.globl	Fp
	.type	Fp, @function
Fp:
.LFB42:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$192, %rsp
	movq	%rdi, -168(%rbp)
	movq	%rsi, -176(%rbp)
	movq	%rdx, -184(%rbp)
	movq	%rcx, -192(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	movq	-168(%rbp), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	movq	-176(%rbp), %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	movq	-184(%rbp), %rdx
	leaq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	leaq	-96(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_si@PLT
	leaq	-80(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-48(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-96(%rbp), %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	jns	.L92
	leaq	-128(%rbp), %rdx
	leaq	-160(%rbp), %rcx
	leaq	-160(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_invert@PLT
	leaq	-144(%rbp), %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_neg@PLT
.L92:
	leaq	-128(%rbp), %rdx
	leaq	-160(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-80(%rbp), %rdx
	leaq	-144(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-80(%rbp), %rdx
	leaq	-144(%rbp), %rcx
	leaq	-144(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_fdiv_q@PLT
	leaq	-48(%rbp), %rdx
	leaq	-64(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	jne	.L93
	leaq	-32(%rbp), %rdx
	leaq	-112(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	jmp	.L95
.L93:
	leaq	-112(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	__gmpz_set_ui@PLT
	jmp	.L95
.L96:
	leaq	-80(%rbp), %rdx
	leaq	-144(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-80(%rbp), %rdx
	leaq	-144(%rbp), %rcx
	leaq	-144(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_fdiv_q@PLT
	leaq	-32(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-128(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-48(%rbp), %rdx
	leaq	-64(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	jne	.L95
	leaq	-32(%rbp), %rdx
	leaq	-112(%rbp), %rcx
	leaq	-112(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-128(%rbp), %rdx
	leaq	-112(%rbp), %rcx
	leaq	-112(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
.L95:
	leaq	-96(%rbp), %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	jne	.L96
	leaq	-112(%rbp), %rdx
	movq	-192(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L97
	call	__stack_chk_fail@PLT
.L97:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE42:
	.size	Fp, .-Fp
	.globl	CRT_RSA
	.type	CRT_RSA, @function
CRT_RSA:
.LFB43:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$304, %rsp
	movq	%rdi, -264(%rbp)
	movq	%rsi, -272(%rbp)
	movq	%rdx, -280(%rbp)
	movq	%rcx, -288(%rbp)
	movq	%r8, -296(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-256(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-240(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-224(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	movq	-264(%rbp), %rdx
	leaq	-256(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	movq	-272(%rbp), %rdx
	leaq	-240(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	movq	-280(%rbp), %rdx
	leaq	-224(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	movq	-288(%rbp), %rdx
	leaq	-208(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	leaq	-192(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-64(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-224(%rbp), %rdx
	leaq	-240(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-240(%rbp), %rdx
	leaq	-256(%rbp), %rcx
	leaq	-192(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-224(%rbp), %rdx
	leaq	-256(%rbp), %rcx
	leaq	-176(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-64(%rbp), %rdx
	leaq	-240(%rbp), %rcx
	leaq	-160(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_sub@PLT
	leaq	-64(%rbp), %rdx
	leaq	-224(%rbp), %rcx
	leaq	-144(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_sub@PLT
	leaq	-160(%rbp), %rdx
	leaq	-208(%rbp), %rcx
	leaq	-160(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-144(%rbp), %rdx
	leaq	-208(%rbp), %rcx
	leaq	-144(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-128(%rbp), %rcx
	leaq	-240(%rbp), %rdx
	leaq	-160(%rbp), %rsi
	leaq	-192(%rbp), %rax
	movq	%rax, %rdi
	call	Fp
	leaq	-112(%rbp), %rcx
	leaq	-224(%rbp), %rdx
	leaq	-144(%rbp), %rsi
	leaq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	Fp
	leaq	-224(%rbp), %rdx
	leaq	-240(%rbp), %rcx
	leaq	-96(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_invert@PLT
	leaq	-240(%rbp), %rdx
	leaq	-224(%rbp), %rcx
	leaq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_invert@PLT
	leaq	-240(%rbp), %rdx
	leaq	-112(%rbp), %rcx
	leaq	-112(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-96(%rbp), %rdx
	leaq	-112(%rbp), %rcx
	leaq	-112(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-224(%rbp), %rdx
	leaq	-128(%rbp), %rcx
	leaq	-128(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-80(%rbp), %rdx
	leaq	-128(%rbp), %rcx
	leaq	-128(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-112(%rbp), %rdx
	leaq	-128(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
	leaq	-48(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-32(%rbp), %rdx
	movq	-296(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L99
	call	__stack_chk_fail@PLT
.L99:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE43:
	.size	CRT_RSA, .-CRT_RSA
	.globl	get_prime
	.type	get_prime, @function
get_prime:
.LFB44:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$144, %rsp
	movq	%rdi, -136(%rbp)
	movl	%esi, -140(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	movl	-140(%rbp), %eax
	movslq	%eax, %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-64(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-64(%rbp), %rdx
	leaq	-80(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_sub@PLT
	leaq	-48(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-112(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	mpz_pow
	leaq	-96(%rbp), %rdx
	leaq	-80(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	mpz_pow
.L101:
	leaq	-96(%rbp), %rdx
	leaq	-112(%rbp), %rcx
	leaq	-128(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	randrange
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	rabin_wit
	xorl	$1, %eax
	testb	%al, %al
	jne	.L101
	leaq	-128(%rbp), %rdx
	movq	-136(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L102
	call	__stack_chk_fail@PLT
.L102:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE44:
	.size	get_prime, .-get_prime
	.globl	get_strong_prime
	.type	get_strong_prime, @function
get_strong_prime:
.LFB45:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$208, %rsp
	movq	%rdi, -200(%rbp)
	movl	%esi, -204(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-192(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-176(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-128(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-112(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-96(%rbp), %rax
	movl	$256, %esi
	movq	%rax, %rdi
	call	get_prime
	leaq	-112(%rbp), %rcx
	leaq	-192(%rbp), %rax
	movl	$256, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_pow_ui@PLT
	leaq	-112(%rbp), %rcx
	leaq	-176(%rbp), %rax
	movl	$257, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_pow_ui@PLT
	movl	-204(%rbp), %eax
	subl	$512, %eax
	movslq	%eax, %rdx
	leaq	-112(%rbp), %rcx
	leaq	-144(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_pow_ui@PLT
	movl	-204(%rbp), %eax
	subl	$511, %eax
	movslq	%eax, %rdx
	leaq	-112(%rbp), %rcx
	leaq	-160(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_pow_ui@PLT
.L104:
	leaq	-176(%rbp), %rdx
	leaq	-192(%rbp), %rcx
	leaq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	randrange
	leaq	-80(%rbp), %rdx
	leaq	-96(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-128(%rbp), %rdx
	leaq	-64(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	rabin_wit
	xorl	$1, %eax
	testb	%al, %al
	jne	.L104
.L105:
	leaq	-160(%rbp), %rdx
	leaq	-144(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	randrange
	leaq	-64(%rbp), %rdx
	leaq	-48(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-128(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	rabin_wit
	xorl	$1, %eax
	testb	%al, %al
	jne	.L105
	leaq	-32(%rbp), %rdx
	movq	-200(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	nop
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L106
	call	__stack_chk_fail@PLT
.L106:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE45:
	.size	get_strong_prime, .-get_strong_prime
	.globl	rabin_wit
	.type	rabin_wit, @function
rabin_wit:
.LFB46:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$336, %rsp
	movq	%rdi, -328(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-256(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-272(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-240(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	movq	-328(%rbp), %rdx
	leaq	-320(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set@PLT
	leaq	-304(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-272(%rbp), %rdx
	leaq	-320(%rbp), %rcx
	leaq	-304(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_sub@PLT
	leaq	-288(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-240(%rbp), %rdx
	leaq	-320(%rbp), %rcx
	leaq	-288(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-224(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-272(%rbp), %rdx
	leaq	-320(%rbp), %rcx
	leaq	-224(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_sub@PLT
	leaq	-256(%rbp), %rdx
	leaq	-208(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set@PLT
	leaq	-256(%rbp), %rdx
	leaq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set@PLT
	leaq	-256(%rbp), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set@PLT
	leaq	-144(%rbp), %rax
	movl	$20, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_ui@PLT
	leaq	-192(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-240(%rbp), %rdx
	leaq	-320(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	jne	.L108
	movl	$1, %eax
	jmp	.L123
.L108:
	leaq	-256(%rbp), %rdx
	leaq	-288(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	jne	.L110
	movl	$0, %eax
	jmp	.L123
.L110:
	leaq	-240(%rbp), %rdx
	leaq	-224(%rbp), %rcx
	leaq	-192(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-256(%rbp), %rdx
	leaq	-192(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	jne	.L125
	leaq	-240(%rbp), %rdx
	leaq	-224(%rbp), %rcx
	leaq	-224(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_fdiv_q@PLT
	leaq	-272(%rbp), %rdx
	leaq	-208(%rbp), %rcx
	leaq	-208(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
	jmp	.L110
.L125:
	nop
	jmp	.L114
.L122:
	leaq	-128(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	__gmpz_set_si@PLT
	jmp	.L115
.L116:
	leaq	-304(%rbp), %rdx
	leaq	-240(%rbp), %rcx
	leaq	-112(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	randrange
	leaq	-320(%rbp), %rdx
	leaq	-112(%rbp), %rcx
	leaq	-128(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_gcd@PLT
.L115:
	leaq	-272(%rbp), %rdx
	leaq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	jne	.L116
	leaq	-96(%rbp), %rcx
	leaq	-320(%rbp), %rdx
	leaq	-224(%rbp), %rsi
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	Fp
	leaq	-256(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	leaq	-320(%rbp), %rdx
	leaq	-96(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
	leaq	-320(%rbp), %rdx
	leaq	-64(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-272(%rbp), %rdx
	leaq	-64(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	je	.L118
	leaq	-272(%rbp), %rdx
	leaq	-80(%rbp), %rcx
	leaq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
	jmp	.L118
.L121:
	leaq	-32(%rbp), %rdx
	leaq	-160(%rbp), %rcx
	leaq	-240(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	mpz_pow
	leaq	-224(%rbp), %rdx
	leaq	-32(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-96(%rbp), %rcx
	leaq	-320(%rbp), %rdx
	leaq	-32(%rbp), %rsi
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	Fp
	leaq	-320(%rbp), %rdx
	leaq	-96(%rbp), %rcx
	leaq	-96(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-304(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	je	.L119
	leaq	-272(%rbp), %rdx
	leaq	-80(%rbp), %rcx
	leaq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
.L119:
	leaq	-272(%rbp), %rdx
	leaq	-208(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
	leaq	-48(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	jne	.L120
	movl	$0, %eax
	jmp	.L123
.L120:
	leaq	-272(%rbp), %rdx
	leaq	-160(%rbp), %rcx
	leaq	-160(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
.L118:
	leaq	-208(%rbp), %rdx
	leaq	-160(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	js	.L121
	leaq	-272(%rbp), %rdx
	leaq	-176(%rbp), %rcx
	leaq	-176(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
.L114:
	leaq	-144(%rbp), %rdx
	leaq	-176(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	js	.L122
	movl	$1, %eax
.L123:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L124
	call	__stack_chk_fail@PLT
.L124:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE46:
	.size	rabin_wit, .-rabin_wit
	.globl	randrange
	.type	randrange, @function
randrange:
.LFB47:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%rdx, -120(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-120(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set@PLT
.L128:
	call	clock@PLT
	movq	%rax, -88(%rbp)
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	__gmp_randinit_default@PLT
	movq	-88(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmp_randseed_ui@PLT
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-80(%rbp), %rdx
	leaq	-48(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_urandomm@PLT
	movq	-112(%rbp), %rdx
	leaq	-64(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	js	.L128
	leaq	-64(%rbp), %rdx
	movq	-104(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L129
	call	__stack_chk_fail@PLT
.L129:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE47:
	.size	randrange, .-randrange
	.globl	mpz_pow
	.type	mpz_pow, @function
mpz_pow:
.LFB48:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%rdx, -120(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-104(%rbp), %rdx
	leaq	-96(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set@PLT
	movq	-112(%rbp), %rdx
	leaq	-80(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set@PLT
	leaq	-48(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_si@PLT
	leaq	-32(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_si@PLT
	leaq	-32(%rbp), %rdx
	leaq	-64(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_init_set@PLT
	jmp	.L132
.L133:
	leaq	-96(%rbp), %rdx
	leaq	-64(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-32(%rbp), %rdx
	leaq	-48(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
.L132:
	leaq	-80(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	js	.L133
	leaq	-64(%rbp), %rdx
	movq	-120(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	leaq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_clear@PLT
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_clear@PLT
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_clear@PLT
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_clear@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_clear@PLT
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L134
	call	__stack_chk_fail@PLT
.L134:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE48:
	.size	mpz_pow, .-mpz_pow
	.globl	inversion
	.type	inversion, @function
inversion:
.LFB49:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$144, %rsp
	movq	%rdi, -120(%rbp)
	movq	%rsi, -128(%rbp)
	movq	%rdx, -136(%rbp)
	movq	%rcx, -144(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-112(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_si@PLT
	leaq	-96(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_si@PLT
	leaq	-80(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	__gmpz_init_set_si@PLT
	leaq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
	leaq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	__gmpz_init@PLT
.L138:
	leaq	-96(%rbp), %rdx
	movq	-120(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-64(%rbp), %rdx
	leaq	-112(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_sub@PLT
	movq	-128(%rbp), %rdx
	leaq	-48(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mod@PLT
	leaq	-80(%rbp), %rdx
	leaq	-32(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_cmp@PLT
	testl	%eax, %eax
	je	.L141
	leaq	-112(%rbp), %rdx
	leaq	-96(%rbp), %rcx
	leaq	-96(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_add@PLT
	jmp	.L138
.L141:
	nop
	leaq	-96(%rbp), %rdx
	movq	-136(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	movq	-136(%rbp), %rdx
	movq	-120(%rbp), %rcx
	leaq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_mul@PLT
	leaq	-64(%rbp), %rdx
	leaq	-112(%rbp), %rcx
	leaq	-48(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_sub@PLT
	movq	-128(%rbp), %rdx
	leaq	-48(%rbp), %rcx
	leaq	-32(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	__gmpz_fdiv_q@PLT
	leaq	-32(%rbp), %rdx
	movq	-144(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	__gmpz_set@PLT
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L139
	call	__stack_chk_fail@PLT
.L139:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE49:
	.size	inversion, .-inversion
	.section	.rodata
	.align 8
.LC5:
	.string	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	.text
	.globl	base64_encode
	.type	base64_encode, @function
base64_encode:
.LFB50:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	leaq	.LC5(%rip), %rax
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	cltq
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rcx
	movabsq	$6148914691236517206, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	movq	%rcx, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	movq	%rcx, %rax
	subq	%rdx, %rax
	testq	%rax, %rax
	jne	.L143
	movq	-16(%rbp), %rcx
	movabsq	$6148914691236517206, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	movq	%rcx, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, -32(%rbp)
	jmp	.L144
.L143:
	movq	-16(%rbp), %rcx
	movabsq	$6148914691236517206, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	movq	%rcx, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	addq	$1, %rax
	salq	$2, %rax
	movq	%rax, -32(%rbp)
.L144:
	movq	-32(%rbp), %rax
	addq	$1, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -8(%rbp)
	movq	-32(%rbp), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	$0, -40(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L145
.L146:
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	shrb	$2, %al
	movzbl	%al, %edx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rcx
	movq	-8(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movl	-36(%rbp), %eax
	movslq	%eax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	sall	$4, %eax
	andl	$48, %eax
	movl	%eax, %edx
	movl	-36(%rbp), %eax
	cltq
	leaq	1(%rax), %rcx
	movq	-56(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	shrb	$4, %al
	movzbl	%al, %eax
	orl	%edx, %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	leaq	1(%rdx), %rcx
	movq	-8(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movl	-36(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	sall	$2, %eax
	andl	$60, %eax
	movl	%eax, %edx
	movl	-36(%rbp), %eax
	cltq
	leaq	2(%rax), %rcx
	movq	-56(%rbp), %rax
	addq	%rcx, %rax
	movzbl	(%rax), %eax
	shrb	$6, %al
	movzbl	%al, %eax
	orl	%edx, %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	leaq	2(%rdx), %rcx
	movq	-8(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	movl	-36(%rbp), %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	andl	$63, %eax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	-40(%rbp), %edx
	movslq	%edx, %rdx
	leaq	3(%rdx), %rcx
	movq	-8(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	addl	$3, -36(%rbp)
	addl	$4, -40(%rbp)
.L145:
	movl	-40(%rbp), %eax
	cltq
	movq	-32(%rbp), %rdx
	subq	$2, %rdx
	cmpq	%rdx, %rax
	jl	.L146
	movq	-16(%rbp), %rcx
	movabsq	$6148914691236517206, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	movq	%rcx, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	movq	%rax, %rdx
	addq	%rdx, %rdx
	addq	%rax, %rdx
	movq	%rcx, %rax
	subq	%rdx, %rax
	cmpq	$1, %rax
	je	.L147
	cmpq	$2, %rax
	je	.L148
	jmp	.L149
.L147:
	movl	-40(%rbp), %eax
	cltq
	leaq	-2(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movb	$61, (%rax)
	movl	-40(%rbp), %eax
	cltq
	leaq	-1(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movb	$61, (%rax)
	jmp	.L149
.L148:
	movl	-40(%rbp), %eax
	cltq
	leaq	-1(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	%rdx, %rax
	movb	$61, (%rax)
	nop
.L149:
	movq	-8(%rbp), %rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE50:
	.size	base64_encode, .-base64_encode
	.section	.rodata
.LC6:
	.string	"=="
	.align 32
.LC0:
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	62
	.long	0
	.long	0
	.long	0
	.long	63
	.long	52
	.long	53
	.long	54
	.long	55
	.long	56
	.long	57
	.long	58
	.long	59
	.long	60
	.long	61
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	1
	.long	2
	.long	3
	.long	4
	.long	5
	.long	6
	.long	7
	.long	8
	.long	9
	.long	10
	.long	11
	.long	12
	.long	13
	.long	14
	.long	15
	.long	16
	.long	17
	.long	18
	.long	19
	.long	20
	.long	21
	.long	22
	.long	23
	.long	24
	.long	25
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	26
	.long	27
	.long	28
	.long	29
	.long	30
	.long	31
	.long	32
	.long	33
	.long	34
	.long	35
	.long	36
	.long	37
	.long	38
	.long	39
	.long	40
	.long	41
	.long	42
	.long	43
	.long	44
	.long	45
	.long	46
	.long	47
	.long	48
	.long	49
	.long	50
	.long	51
	.text
	.globl	base64_decode
	.type	base64_decode, @function
base64_decode:
.LFB51:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$560, %rsp
	movq	%rdi, -552(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-512(%rbp), %rax
	leaq	.LC0(%rip), %rdx
	movl	$61, %ecx
	movq	%rax, %rdi
	movq	%rdx, %rsi
	rep movsq
	movq	%rsi, %rdx
	movq	%rdi, %rax
	movl	(%rdx), %ecx
	movl	%ecx, (%rax)
	leaq	4(%rax), %rax
	leaq	4(%rdx), %rdx
	movq	-552(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	cltq
	movq	%rax, -528(%rbp)
	movq	-552(%rbp), %rax
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	call	strstr@PLT
	testq	%rax, %rax
	je	.L152
	movq	-528(%rbp), %rax
	leaq	3(%rax), %rdx
	testq	%rax, %rax
	cmovs	%rdx, %rax
	sarq	$2, %rax
	movq	%rax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	subq	$2, %rax
	movq	%rax, -536(%rbp)
	jmp	.L153
.L152:
	movq	-552(%rbp), %rax
	movl	$61, %esi
	movq	%rax, %rdi
	call	strchr@PLT
	testq	%rax, %rax
	je	.L154
	movq	-528(%rbp), %rax
	leaq	3(%rax), %rdx
	testq	%rax, %rax
	cmovs	%rdx, %rax
	sarq	$2, %rax
	movq	%rax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	subq	$1, %rax
	movq	%rax, -536(%rbp)
	jmp	.L153
.L154:
	movq	-528(%rbp), %rax
	leaq	3(%rax), %rdx
	testq	%rax, %rax
	cmovs	%rdx, %rax
	sarq	$2, %rax
	movq	%rax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	movq	%rax, -536(%rbp)
.L153:
	movq	-536(%rbp), %rax
	addq	$1, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -520(%rbp)
	movq	-536(%rbp), %rdx
	movq	-520(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	movl	$0, -544(%rbp)
	movl	$0, -540(%rbp)
	jmp	.L155
.L156:
	movl	-544(%rbp), %eax
	movslq	%eax, %rdx
	movq	-552(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	movl	-512(%rbp,%rax,4), %eax
	movzbl	%al, %eax
	sall	$2, %eax
	movl	%eax, %ecx
	movl	-544(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-552(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	movl	-512(%rbp,%rax,4), %eax
	shrb	$4, %al
	orl	%eax, %ecx
	movl	-540(%rbp), %eax
	movslq	%eax, %rdx
	movq	-520(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movl	-544(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-552(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	movl	-512(%rbp,%rax,4), %eax
	movzbl	%al, %eax
	sall	$4, %eax
	movl	%eax, %ecx
	movl	-544(%rbp), %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-552(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	movl	-512(%rbp,%rax,4), %eax
	shrb	$2, %al
	orl	%eax, %ecx
	movl	-540(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	movq	-520(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	movl	-544(%rbp), %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-552(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	movl	-512(%rbp,%rax,4), %eax
	movzbl	%al, %eax
	sall	$6, %eax
	movl	%eax, %ecx
	movl	-544(%rbp), %eax
	cltq
	leaq	3(%rax), %rdx
	movq	-552(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	movl	-512(%rbp,%rax,4), %eax
	orl	%eax, %ecx
	movl	-540(%rbp), %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-520(%rbp), %rax
	addq	%rdx, %rax
	movl	%ecx, %edx
	movb	%dl, (%rax)
	addl	$3, -540(%rbp)
	addl	$4, -544(%rbp)
.L155:
	movl	-544(%rbp), %eax
	cltq
	movq	-528(%rbp), %rdx
	subq	$2, %rdx
	cmpq	%rdx, %rax
	jl	.L156
	movq	-520(%rbp), %rax
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L158
	call	__stack_chk_fail@PLT
.L158:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE51:
	.size	base64_decode, .-base64_decode
	.globl	to_utf8
	.type	to_utf8, @function
to_utf8:
.LFB52:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -8(%rbp)
	jmp	.L160
.L161:
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	-8(%rbp), %edx
	movslq	%edx, %rdx
	leaq	2(%rdx), %rcx
	movq	-24(%rbp), %rdx
	addq	%rcx, %rdx
	movzbl	(%rax), %eax
	movb	%al, (%rdx)
	subl	$1, -8(%rbp)
.L160:
	cmpl	$0, -8(%rbp)
	jns	.L161
	movq	-24(%rbp), %rax
	movb	$98, (%rax)
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movb	$39, (%rax)
	movl	-4(%rbp), %eax
	cltq
	leaq	2(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$39, (%rax)
	movl	-4(%rbp), %eax
	cltq
	leaq	3(%rax), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE52:
	.size	to_utf8, .-to_utf8
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
