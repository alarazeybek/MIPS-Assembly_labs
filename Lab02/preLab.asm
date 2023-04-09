#CS224
#Recitation No.2
#Section No.6
#Alara Zeybek
#22102544
#3.07.23
#
.text
Main:
#--------------Determining The Size-----------------------------
	la	$a0, txt1
	li	$v0,4
	syscall
	li	$v0,5
	syscall
	move	$s1,$v0		# s1 keeps the size of array
	#passing the argument of the create array func
	la $a1, $s0
	addi $sp, $sp, -4	
	#we should pass a regist3er to create Array so that that register will be the starting address of the array
	jal	CreateArray#the starting address of the array is at s0
	la $s0, $s4
	la $a1, $s3
	jal	CreateArray#the starting address of the array is at s3
	la $s3, $s4
	j	PrintArray
	
CreateArray:
	blt 	$s1,$zero,negativeSize		#negative size exception check
	
#--------------Allocation-----------------------------
	move	$s4,$a1		# a0 = s1
	sll $a0, $a0, 2		#finding the required bit place   a0 = 4 * s1
	li $v0, 9		#allocation
  	syscall
  	move $s4, $v0		#address of the allocated memory block = s0
  	la $sp, ($ra)
  	jal	InitializeArray
  	la $ra, ($sp)
	jr $ra
	
InitializeArray:
	move	$s2,$s1		#s2 = s1
	while:
	beqz	$s2,exit	#loop condition
	
	la	$a0, txt2
	li	$v0,4
	syscall
	


	sw	$s1,($s0)
	li	$v0,1
	lw	$s2,($s0)
	move	$a0,$s2	
	syscall
	
		
	exit:
		jr	$ra
PrintArray:
CalculateDistance:


	j	end
negativeSize:
	la	$a0, negativeSizeExp
	li	$v0,4
	syscall
end:
	move $a0, $s0     # pass the address of the memory block to deallocate
	li	$v0,10
	syscall

.data
	txt1: .asciiz "Please enter number of elements you want in the array:\n"
	txt2: .asciiz "Please enter a number:\n"
	
	negativeSizeExp: .asciiz "Array Size is negative!!"
	
