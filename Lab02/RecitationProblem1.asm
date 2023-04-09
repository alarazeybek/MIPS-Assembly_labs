.text
__main:
#-----------------Getting 2 numbers from user------------------------
	li 	$v0, 4
	la 	$a0, msg0
	syscall
	li 	$v0, 5
	syscall
	move 	$s0, $v0
	
	li 	$v0, 4
	la 	$a0, msg0
	syscall
	li 	$v0, 5
	syscall
	move 	$s1, $v0
	
	move	$a1,$s0
	move	$a2,$s1
	jal	TrueCalculating
#-----------------Calculating the Distance------------------------

	
	li 	$v0, 4
	la 	$a0, endl
	syscall
	move	$a1,$s0
	move	$a2,$s1
	jal	__print
	j __end
		
__print:
	# a0 holds the size of the array
	# a1 holds the start index of the memory block that keeps the array
	# s5 and a2 are an empty register
	li $v0, 4
	la $a0, msg4
	syscall
	
	li $v0, 34
	la $a0, ($a1)
	syscall
	li $v0, 4
	la $a0, endl
	syscall
	li $v0, 34
	la $a0, ($a2)
	syscall
	li $v0, 4
	la $a0, endl
	syscall
	jr $ra
DistanceCal:
	#a1=s0 first number
	#a2=s1 second number
	#v1 counter
	li	$s7,10
	addi	$v1,$zero,0
	
	beqz	$a1,returnImm
	beqz	$a2,returnImm		
	
	#s5 and s6 will be he counter
	addi	$s5,$zero,0
	addi	$s6,$zero,0
	while1:
		beqz	$a1,returnEnd
		beqz	$a2,returnEnd#just in case
		
		div	$a1,$s7
		mflo	$a1
		mfhi	$a0
		div	$a2,$s7
		mflo	$a2
		mfhi	$a3
		
		beq	$a0,$a3,again
		addi	$v1,$v1,1
		again:
			j	while1
	returnImm:
		addi	$v1,$zero,1	
		jr	$ra
	returnEnd:
		bnez	$a1,sizeExp
		bnez	$a2,sizeExp
		
		li 	$v0, 4
		la 	$a0, result
		syscall
		move	$a0,$v1
		li	$v0,1
		syscall
		jr	$ra
	sizeExp:
		la	$a0, sizeExptxt
		li	$v0,4
		syscall
		jr	$ra	
TrueCalculating:
	xor	$s5,$a1,$a2
	addi	$v1,$zero,0
	
	loop1:
	andi	$s6,$s5,1	#LSB
	add	$v1,$v1,$s6
	srl	$s5,$s5,1
	bnez	$s5,loop1
	
	li 	$v0, 4
	la 	$a0, result
	syscall
	move	$a0,$v1
	li	$v0,1
	syscall
	jr	$ra
	
__end:
	li $v0, 4
	la $a0, continue
	syscall
	li $v0, 5
	syscall
	beqz $v0, ex
	beq $v0, 1, __main
	ex:
		j Last
		
Last:
	li $v0, 10
	la $a0, 0
	syscall
.data
        msg0: .asciiz "Enter a number: "
        msg2: .asciiz "The Hamming Distance is: "
        msg3: .asciiz "The array is done initializing\n"
	msg4: .asciiz "You entered the following numbers: \n"
	continue: .asciiz "Continue? (1 for yes 0 for no)\n"
	sizeExptxt: .asciiz "Invalid size entries\n"
	result: .asciiz "Result: "
        endl: .asciiz "\n"