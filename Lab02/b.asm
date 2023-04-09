.data
        msg0: .asciiz "Enter the space for the array: "
        msg1: .asciiz "In?tializing array...\n"
        msg2: .asciiz "Please enter the numbers one by one\n"
        msg3: .asciiz "The array is done initializing\n"
        msg4: .asciiz "Printing the array: "
        msg5: .asciiz "Done printing the array\n"
        msg6: .asciiz "Caclculating the distance: "
        msg7: .asciiz "Enter the number of arrays you will use: "
        msg8: .asciiz "The array init ended"
        endl: .asciiz "\n"
	.text
Main:
	#first get the number of wanted arrays
	li $v0, 4
	la $a0, msg7	
	syscall
	
	#getting the array lenght for the array
	li $v0, 4
	la $a0, msg0
	syscall
	
	li $v0, 5
	syscall
	move $s7, $v0
	#Calculating the space of the array
	mul $s7, $s7, 4
	move $a0, $s7
	#we need to trace the code so that the call stack is in line 
	#we need 1 back lost function calls so we need to do sp-4
	addi $sp, $sp, -4
	#this is the 2nd argument for the createArray which is the location for the array
	#la $a1, ($s1)
	jal CreateArray
	la $s1, ($v1)
	addi $sp, $sp, 4
	#we do not need any stack po?nter because there ?s no lost back tracking $ra
	jal PrintArray
	
	#getting the array lenght for the array
	li $v0, 4
	la $a0, msg0
	syscall
	
	li $v0, 5
	syscall
	move $s7, $v0
	#Calculating the space of the array
	mul $s7, $s7, 4
	move $a0, $s7
	addi $sp, $sp, -4,
	#la $a1, ($s2)
	jal CreateArray
	la $s2, ($v1)
	
	jal PrintArray
	#end of the array creation and initialization
	__init:
		li $v0, 4
		la $a0, msg8
		syscall
	#put the addreses of the arrays in the $a0 and $a1 registers so that the function calculate can do its biz
	jal Calculate
	j end
		
#the array shoul dbe createad with a argument 
#so that there can be multiple arrays
CreateArray:
	#Dynamically allocated the array
	li $v0, 9
	syscall
	move $s0, $v0
	la $v1, ($s0)
	sw $ra, 0($sp)
	jal InitializeArray
	lw $ra, 0($sp)
	jr $ra
InitializeArray:
	li $v0, 4
	la $a0, msg1
	syscall
	
	la $s6, 0($s7) #the space of the array
	la $s4, 0($s0) #the starting address of the array
	loop1:
		beqz $s6, end
		li $v0, 5
		syscall
		move $s5, $v0
		sw $s5, 0($s0)
		addi $s6, $s6, -4
		addi $s0, $s0, 4
		j loop1
	end:
		la $s0, ($s4)
		li $v0, 4
		la $a0, msg3
		syscall
		jr $ra
#PRINT ARRAY DOES NOT WORK
PrintArray:
	li $v0, 4
	la $a0, msg4
	syscall
	
	la $s6, 0($s0)
	la $s5, 0($s7)
	loop2:
		beqz $s5, done
		li $v0, 1
		move $a1, $s6
		syscall
		
		li $v0, 4
		la $a0, endl
		syscall
		
		addi $s5, $s5, -4
		addi $s6, $s6, 4
		j loop2
	done:
		li $v0, 4
		la $a0, msg5
		syscall
		jr $ra
		
Calculate:
	
End:
	move $a0, $s0     # pass the address of the memory block to deallocate
	li	$v0,10
	syscall
