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
	
	move	$s0,$v0		# s0 keeps the size of array
	addi 	$sp, $sp, -4	# 1 int stack memory
	
	la	$a0, crArray
	li	$v0,4
	syscall
	move	$a0,$s0
	jal	CreateArray	#the starting address of the array is at s0
	move 	$s1,$v1
	
	la	$a0, crArray
	li	$v0,4
	syscall
	move	$a0,$s0
	jal	CreateArray	#the starting address of the array is at s0
	move 	$s2,$v1
	#--------------Print--------------
	move	$a1,$s1
	move	$a0,$s0
	jal	PrintArray
	
	move	$a1,$s2
	move	$a0,$s0
	jal	PrintArray
	#------------------Calculate----------
	move	$a2,$s2		#second array start index
	move	$a1,$s1		#first array start index
	move	$a0,$s0		#size
	jal	CalculateDistance
	j	end
negativeSize:
	la	$a0, negativeSizeExp
	li	$v0,4
	syscall
end:
	addi 	$sp, $sp, 4	# eskisi gibi birak
	move $a0, $s0     # pass the address of the memory block to deallocate
	li	$v0,10	   #terminate the programme
	syscall

	
CreateArray:
	blt 	$a0,$zero,negativeSize		#negative size exception check
	
#--------------Allocation-----------------------------
	move	$a1, $a0		#a0 holds the size
	sll 	$a0, $a0, 2		#finding the required bit place   a1 = 4 * s0
	li 	$v0, 9			#address of the allocated memory block = v1
  	syscall
	move	$v1, $v0
	#-----------prework for initialize array call----------------------
	move	$a3,$v1			#copy the adress
	move	$a0, $a1		#a0 holds the size
  	sw	$ra, 0($sp)
  	jal	InitializeArray
 	lw	$ra, 0($sp)
	jr 	$ra
	
InitializeArray:
	move	$a2,$a0		#copy the size because a0 will call for syscalls
	while:
	beqz	$a2,exit	#loop condition
	
	la	$a0, txt2
	li	$v0,4
	syscall
	li	$v0,5
	syscall
	move	$s5, $v0	#input in s5
	sw	$s5,($a3)
	addi	$a3,$a3,4

        addi	$a2,$a2,-1
        j	while
	exit:
		jr	$ra
PrintArray:
	# a0 holds the size of the array
	# a1 holds the start index of the memory block that keeps the array
	# s5 and a2 are an empty register
	
	move	$a2,$a0		#copy the size because a0 will call for syscalls
	whilePrint:
	beqz	$a2,exitPrint	
	
	lw	$s5,($a1)
	move	$a0, $s5
	
	li	$v0,1
	syscall
	
	la	$a0, space
	li	$v0,4
	syscall
	
        addi	$a2,$a2,-1
	addi	$a1,$a1,4

        j	whilePrint
	exitPrint:
		la	$a0, endl
		li	$v0,4
		syscall
		jr	$ra
CalculateDistance:
	# a0 holds the size of the array
	# a1 holds the start index of the memory block that keeps the array 1
	# a2 holds the start index of the memory block that keeps the array 3
	# s5, s6 and a3 are an empty register
	addi	$v1,$zero,0
	whileCalculate:
	beqz	$a0,exitCalculate	#loop condition
	
	lw	$s5,($a1)
	lw	$s6, ($a2)
	
	beq	$s5,$s6, esc
		addi	$v1,$v1,1
	esc:
	
        addi	$a0,$a0,-1
	addi	$a2,$a2,4
	addi	$a1,$a1,4

        j	whileCalculate
	exitCalculate:
		li 	$v0, 4
		la 	$a0, result
		syscall
		move	$a0, $v1
		li	$v0,1
		syscall
		jr	$ra
	

.data
	space: .asciiz " "
	endl: .asciiz "\n"
	crArray: .asciiz "Creating a new array\n"
	txt1: .asciiz "Please enter number of elements you want in the array:\n"
	txt2: .asciiz "Please enter a number:\n"
	
	negativeSizeExp: .asciiz "Array Size is negative!!"
	result: .asciiz "Result: "
	
	
