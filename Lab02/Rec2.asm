.data
        msg0: .asciiz "Enter your array numbers one by one:\n "
        msg1: .asciiz "Enter array lenght:\n "
        msg2: .asciiz "Enter your array index:\n "
        msg3: .asciiz "The occurences of that index in the array is: \n"
        endl: .asciiz "\n"
	.text
__main:
	jal __createArray
	la $s4, ($v1)
	la $a1, ($s4)
	jal __calculate
	j __End
__createArray:
	li $v0, 4
	la $a0, msg1
	syscall
	li $v0, 5
	syscall
	move $s6, $v0 #the array lenght is at $s6
	move $a0, $s6
	li $v0, 9
	syscall
	move $s0, $v0
	move $v1, $s0
	la $s7, ($s6)
	li $v0 ,4
	la $a0, msg0
	syscall
	__loop:
		beqz $s7, __endOfInit
		li $v0, 5
		syscall
		sw $v0, 0($v1)
		addi $v1, $v1, 4
		addi $s7, $s7, -1
		j __loop
	__endOfInit:
		li $v0, 4
		la $a0, msg2
		syscall
		la $v1, ($s0)
		li $v0, 5
		syscall
		move $s1, $v0
	jr $ra
__calculate:
	la $s7, ($s6)
	sll	$s1,$s1,2
	add $a1, $a1, $s1
	lw $s5, ($a1)#The number at the index
	li $s3, 0
	__loop2:
		beqz $s7, __done
		lw $s2, ($s4)
		beq $s5, $s2, __equal
		addi $s4, $s4, 4
		addi $s7, $s7, -1
		j __loop2
		__equal:
			addi $s3, $s3, 1
			addi $s4, $s4, 4
			addi $s7, $s7, -1
			j __loop2
	__done:
		li $v0, 1
		move $a0, $s3
		syscall
	jr $ra
__End: