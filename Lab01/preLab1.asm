
.text
initializer:
	li	$v0, 4
	la	$a0, initial1
	 syscall
	li	$v0, 5
	 syscall
	move	$t0, $v0	
	li	$v0,4
	la	$a0, check
	 syscall
	li	$v0, 1
	move	$a0, $t0
	 syscall
	li	$v0, 4
	la	$a0, initial2
	 syscall
ArrayInitializer:	
	addi	$t1,$zero,0	#t1 is 0
	addi	$s1,$zero,0	#t1 is 0
	la	$s1,array
	while:
		bge 	$t1,$t0,exit
		
		li	$v0, 5
		 syscall
		sb	$v0,0($s1)
		addi	$t1,$t1,1
		addi	$s1,$s1,4
		 
		j	while
	exit:
		li	$v0,4
		la	$a0,endl
		 syscall
			
Selecting_N:	#t1 is now available to use,	t1 = N
#--------------------------N is ... ---------------------------
	li	$v0,4
	la	$a0,initial3
	 syscall
	li	$v0,5
	 syscall
	move	$t1,$v0		
	li	$v0,4
	la	$a0,check2
	 syscall
	li	$v0, 1
	move	$a0, $t1
	 syscall
	li	$v0,4
	la	$a0,endl
	 syscall
menu:
	addi	$t2,$zero,0	# t2 = 0, array's element
	addi	$t3,$zero,0	# t3 = 0, t3 = i for while loop
	addi	$t4,$zero,0	# t4 = 0, counterA
	addi	$t5,$zero,0	# t5 = 0, counterB
	addi	$t6,$zero,0	# t6 = 0, counterC
	addi	$t7,$zero,0	# t7 = 0, counterD
	addi	$t8,$zero,0	# t8 = 0, 
	addi	$s1,$zero,0
	la	$s1,array	#array's index
#------------------------LOOP------------------------
	while2:
		ble 	$t0,$t3,print	# t0 <= t3 ise jump
		lb	$t2,0($s1)			#boundary error aldi -> lw den lb cevirdim
	
		beq  	$t2,$t1,eq			#Part a
	  f1:
		blt	$t2,$t1,lt			#Part b	
	  f2:
		bgt	$t2,$t1,gt			#Part c
	  f3:
	  	beq	$t1,0,exception			# dividing by 0 exception handling
		div	$t2,$t1				# t2 / t1
		mfhi	$t8				#t2 is now the remainder
		beqz 	$t8,dv				#Part d
	  f4:
			addi	$t3,$t3,1
			addi	$s1,$s1,4	
		j	while2
		
	eq:
		addi	$t4,$t4,1
		j	f1
	lt:
		addi	$t5,$t5,1
		j	f2
	gt:
		addi	$t6,$t6,1
		j	f3
	dv:
		addi	$t7,$t7,1
		j	f4
	exception:
		li	$v0,4
		la	$a0,divideByZero
	 	 syscall
	 	j	f4
#---------------FIRST-------------------		
	print:
		li	$v0,4
		la	$a0,first
	 	 syscall
		li	$v0, 1
		move	$a0, $t4
		 syscall
#---------------SECOND--------------------
		li	$v0,4
		la	$a0,endl
	 	 syscall
		la	$a0,second
	 	 syscall
		li	$v0, 1
		move	$a0, $t5
		 syscall
#---------------THIRD--------------------
		li	$v0,4
		la	$a0,endl
	 	 syscall
		la	$a0,third
	 	 syscall
		li	$v0, 1
		move	$a0, $t6
		 syscall
#---------------FOURTH--------------------
		li	$v0,4
		la	$a0,endl
	 	 syscall
		la	$a0,fourth
	 	 syscall
		li	$v0, 1
		move	$a0, $t7
		 syscall		
#-----------------END--------------------
end:
	li	$v0, 10
	li	$a0,0 
	syscall
	
.data
endl:		.asciiz "\n"
initial1:	.asciiz "enter the number of elements\n"
initial2:	.asciiz "\nenter the elements one by one\n"
check:		.asciiz "Size is "

initial3:	.asciiz "Enter N to continue\n"
check2:		.asciiz "N is "
first:		.asciiz "a.The number of array members equal to N: "
second:		.asciiz "b.The number of array members less than N: "
third:		.asciiz "c.The number of array members greater than N: "
fourth:		.asciiz "d.The number of elements evenly divisible by N: "
divideByZero:	.asciiz "Since N is 0. Division could not realized\n"
array:		.space 	80 # Allocate 80 bytes = space enough to hold 20 words
