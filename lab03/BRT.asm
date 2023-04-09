#CS224
#3. Recitation
#004
#Bora Haliloglu
#22101852
#24/03/2023
	.data
	msg1:	.asciiz"Enter numbers between 1 and 31 to continue running the program\n"
	msg2:	.asciiz"Enter your number: "
	endl:	.asciiz"\n"
	msg3:	.asciiz"ANAN\n"
	msg4:	.asciiz"BABAN\n"
	.text
#the main part of the program
__main:
	add	$t0,$t4,$t4
	li $v0, 4
	la $a0, msg1
	syscall
	li $v0, 5
	syscall
	move $a0, $v0 
	la $s5, __main #the first instruction to start from
	la $s6, __end
	li $a3, 0
	jal __getData
	j __end
#the part where the user will be presented with a UI
#the program will quit if the user input is outside [1,31]
#get the first label in the progaram->increment the instructions one by one and return it
__getData:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	beq $s6, $s5, end
	lw $a1, ($s5)
	andi 	$s1, $a1, 0xFC000000   # Bit mask the first 6 bits
    	srl 	$s1, $s1, 26           # Shift right by 26 bits to get the opcode
    	beq 	$s1, 0x00000000, RType
    	beq 	$s1, 0x08000000, JType
	IType:
		andi $s1, $a1, 0x1F0000  	# Mask the bits [20:16]
		srl $s1, $s1, 16                 # Shift the value to the right by 16 bits
		beq $a0, $s1, inc
		j else
		inc:
			addi $a3, $a3, 1
			#j done
		else:
		andi $s1, $a1, 0x03E00000 	# Mask the bits [25:21]
		srl $s1, $s1, 21                 # Shift the value to the right by 21 bits
		beq $a0, $s1, inc2
		j done
		inc2:
			addi $a3, $a3, 1
			#j done
		#j done
		#inc2:
		#	addi $a3, $a3, 1
		#	j done
		done:
		j cont
	JType:
		andi $s1, $a1, 0x3FFFFFF  # Mask the bits [25:0]
		sll $s1, $s1, 2                 # Shift the value to the left by 2 bits
		beq $s1, $a0, incj
		j donej
		incj:
			addi $a3, $a3, 1
		donej:
		j cont
	RType:	
		# Extracting rs register number
		andi $s1, $a1, 0x03E00000  # Mask the bits [25:21]
		srl $s1, $s1, 21                 # Shift the value to the right by 21 bits
		beq $s1, $a0, incr1
		j doner1
		incr1:
			addi $a3, $a3, 1
		doner1:
		# Extracting rt register number
		andi $s1, $a1, 0x1F0000  # Mask the bits [20:16]
		srl $s1, $s1, 16                 # Shift the value to the right by 16 bits
		beq $s1, $a0, incr2
		j doner2
		incr2:
			addi $a3, $a3, 1
		doner2:
		# Extracting rd register number
		andi $s1, $a1, 0x1F      # Mask the bits [15:11]
		srl $s1, $s1, 11                 # Shift the value to the right by 11 bits
		beq $s1, $a0, incr3
		j doner3
		incr3:
			addi $a3, $a3, 1
		doner3:
	cont:
	addi $s5, $s5, 4
	beqz $a1, end
	jal __getData
	end:
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra
__end:
	li $v0, 4
	la $a0, endl
	syscall
	li $v0, 1
	la $a0, ($a3)
	syscall
