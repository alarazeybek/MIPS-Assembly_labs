.text		
	.globl __start	

__start:
	li	$v0,4
	la	$a0,txt1
	syscall
	li $v0,5	#t0 = a
	syscall
	move	$t0,$v0
	
	li	$v0,4
	la	$a0,txt2
	syscall
	li $v0,5	#t1 = b
	syscall
	move	$t1,$v0
	
	li	$v0,4
	la	$a0,txt3
	syscall
	li $v0,5	#t2 = c
	syscall
	move	$t2,$v0
	

	
	#exception(entry checking)
	beq $t2, 1, exception
	beq $t2, 0, exception
	beq $t0, 0, exception
	div	$t0,$t2
	mfhi	$s0
	beq $s0, 0, exception		# c = k.a
	
	
	mul	$t4,$t0,$t1
	add	$t5,$t0,$t1
	sub	$s1,$t4,$t5
	
	div	$s1,$s0
	mfhi	$s3
	mflo	$s4
	
	
	li	$v0,4
		la	$a0,result
		syscall	
	li	$v0,1
		move	$a0,$s4
		syscall
	li	$v0,4
		la	$a0,remain
		syscall
	li	$v0,1
		move	$a0,$s3
		syscall		
	j	end
	
	exception:
		li	$v0,4
		la	$a0,exTxt
		syscall
	end:
		li	$v0,10
		la	$a0,0
		syscall
.data
	txt1 : .asciiz "Enter a: "
	txt2 : .asciiz "Enter b: "
	txt3 : .asciiz "Enter c: "
	exTxt: .asciiz "\nPlease change the invalid entrie(s). The expression cannot be calculated. \n"
	result: .asciiz "\nResult: "
	remain: .asciiz "\nRemain: "