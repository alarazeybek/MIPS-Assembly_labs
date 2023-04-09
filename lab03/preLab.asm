#DENEMEEEEEEEEEEEEEEEEEEEEEE

.data
	endl: .asciiz "\n"
	input1: .asciiz "Please enter a number:\n"
	remainder: .asciiz "\nRemainder: "
	quotient: .asciiz "\nQuotient: "
	ZeroExp: .asciiz "\nZero exception!!! Please try again.\n"
	
	listSize: .asciiz "Creating the ORIGINAL linked list.\n\nPlease enter the list size:"
	olist: .asciiz "ORIGINAL linked list.:"
	listSize2: .asciiz "\nCreating the COPY linked list.\nEnter the INDEX that you do NOT want in the list(starting from 1):"
	line:	.asciiz "\n --------------------------------------"

	nodeNumberLabel: .asciiz "\n Node No.: "
	addressOfCurrentNodeLabel: .asciiz "\n Address of Current Node: "
	addressOfNextNodeLabel: .asciiz	 "\n Address of Next Node: "
	dataValueOfCurrentNode: .asciiz	 "\n Data Value of Current Node: "
	NumberofNodes: .asciiz "Number of Nodes in the copied linked list: "
	Indexp: .asciiz "Invalid index!! Please enter a new index\n"
	
	reg1:	.asciiz		"\nEnter a number between 1 and 31 to continue running the program:"
	reg2:	.asciiz		"\nCount result is: "
.text

main:
#----------------------------REGISTER COUNTER PART---------------------------
	li $v0, 4
	la $a0, reg1
	syscall
	jal	RegisterCount
#---------------GETTING INPUTS RECURSIVE DIVISION-----------

#----------INOUTLAR NEGAT?F M? 0 MI D?YE CHECK ETTTTTTTTTT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
gettingInputForDiv:
	la	$a0,input1
	li	$v0,4
	syscall
	li	$v0,5
	syscall
	move	$s1,$v0
	la	$a0,input1
	li	$v0,4
	syscall
	li	$v0,5
	syscall
	beqz	$v0,ExceptZero
	move	$s2,$v0
	
#-------------------------RECURSIVE DIVISION-------------------------
	add	$a0,$zero,0	#quotient
	add	$a1,$zero,0	#remainder
	addi 	$sp, $sp, -8
	sw	$s1,($sp)	#divident
	sw	$s2, 4($sp)	#divisor
	jal	recursive
	lw	$s1,($sp)	#divident
	lw	$s2, 4($sp)	#divisor
	addi 	$sp, $sp, 8
	move	$s3,$a0		#quotient
	move	$s4,$a1		#remaining
#----------------------PRINTING RECURSIVE PART-------------------------------
	la	$a0,quotient
	li	$v0,4
	syscall
	move	$a0,$s3
	li	$v0,1
	syscall
	la	$a0,remainder
	li	$v0,4
	syscall
	move	$a0,$s4
	li	$v0,1
	syscall
	la	$a0,endl
	li	$v0,4
	syscall
#-------------------------CREATING THE ORIGINAL LINKED LIST-----------------------
	la	$a0,listSize
	li	$v0,4
	syscall
	li	$v0,5
	syscall
	move	$s0,$v0		# s0 = linked list size
	move	$a0,$s0		# a0 = parameter holds the size
	jal	createLinkedList
	move	$s1, $v0	# Pass the linked list address in $s1
	la	$a0,olist
	li	$v0,4
	syscall
	move	$a0, $s1	# Pass the linked list address in $a0
	jal	printLinkedList
	
	la	$a0,endl
	li	$v0,4
	syscall
#-------------------------COPY ALL EXCEPT-----------------------
enterIndex:
	la	$a0,listSize2
	li	$v0,4
	syscall
	li	$v0,5
	syscall
	move	$s2,$v0		# s2 = unwanted element index
	bgt	$s2,$s0,Indexexception
	blez 	$s2,Indexexception
	move	$a1,$s2		# a1 = unwanted element index
	move	$a0, $s1	# Pass the original linked list address in $a0
	jal	CopyAllExcept
	move	$s3, $v0	# Pass the linked list address in $s1
	
	la	$a0,NumberofNodes
	li	$v0,4
	syscall
	move	$a0,$v1
	li	$v0,1
	syscall
	la	$a0,endl
	li	$v0,4
	syscall
	move	$a0, $s3	# Pass the linked list address in $a0
	
	jal	printLinkedList
		
	j	endProgram
	
ExceptZero:
	la	$a0,ZeroExp
	li	$v0,4
	syscall
	j	gettingInputForDiv
#-----------------------------PRELEMINARY FUNCTIONS----------------------------		
recursive:	
	addi $sp, $sp, -12          # allocate space on stack for return address
  	sw $ra, 0($sp)             # save return address on stack
        sw $s0, 4($sp)             # save $s0 on stack
        sw $s1, 8($sp)             # save $s1 on stack
	
		
	slt	$a3,$s1,$s2		# divident < divisor ise 1 olacak YANI quotient <= divident ise 0
	beq	$a3, 1, baseCase	# 1 ise recursiondan c?k
	
        sub	$a1, $s1, $s2		#remainder
        move	$s1,$a1
	addi	$a0,$a0, 1		#quotient
       	 
       	 jal	recursive
       	 
	baseCase:
		lw 	$ra, 0($sp)             # load return address
        	lw 	$s0, 4($sp)             # load $s0  
        	lw 	$s1, 8($sp)             # load $s1 
        	addi 	$sp, $sp, 12          # allocate space on stack for return address
		jr	$ra

CopyAllExcept:
	addi	$sp, $sp, -32
	sw	$s6, 28($sp)
	sw	$s5, 24($sp)
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move	$s0, $a0	# $s0: points to the current node.
	move	$s4, $a1	# $s4 = index unwanted
	li	$s6, 1		# $s6 = first list's node index keeper
	li	$v1, 0		# $v1: Node counter
#Creating the Head	
	bne	$s4,1,notFirstElement
	#in this case index is 0 and head address will be affected
	lw	$s1, 0($s0)	# $s1: Address of  next node
	move	$s0, $s1	# Consider next node.
	addi	$s6,$s6,1	# original list's index += 1
notFirstElement:
	li	$a0, 8
	li	$v0, 9		# $v0 points to the first and last node of the linked list.
	syscall 	
# OK now we have the list head. And head in V0 , in S3, in S5 and head Node
	move	$s3,$v0
	move	$s5,$v0
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	move	$s0, $s1	# Consider next node.
	addi	$s6,$s6,1	# original list's index += 1
	sw	$s2, 4($s3)
CompareAndCopy:
	beqz	$s0, exit
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	
#Creating a new node if the orijinal index != $S4
	beq	$s6,$s4,skiped
	
	#sw	$s2, 4($s3)	# Store the data value. !!!!!!!!!!
	addi	$v1, $v1, 1	# Increment node counter.
	li	$a0, 8 		# Creating nextNode
	li	$v0, 9
	syscall	
	sw	$v0, 0($s3)
	move	$s3, $v0	# $s2 now points to the new node.
	sw	$s2, 4($s3)
	
	skiped:
# Now consider next node.
	move	$s0, $s1	# Consider next node.
	addi	$s6,$s6,1	# original list's index += 1
	j	CompareAndCopy
exit:
# Restore the register values
	sw	$zero, 0($s3)	
	
	move	$v0,$s5
	
	lw	$s6, 28($sp)
	lw	$s5, 24($sp)
	lw	$s0, 20($sp)
	lw	$s1, 16($sp)
	lw	$s2, 12($sp)
	lw	$s3, 8($sp)
	lw	$s4, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 32
	jr	$ra
	
	
	
#-----------------------------HELPER FUNCTIONS-----------------------------------

createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	#sll	$s4, $s1, 2	
	la	$a0,input1			#------------------------------> GETTING USER INPUTS
	li	$v0,4
	syscall
	li	$v0,5			
	syscall
	move	$s4,$v0
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	#sll	$s4, $s1, 2	
	la	$a0,input1			#------------------------------> GETTING USER INPUTS
	li	$v0,4
	syscall
	li	$v0,5			
	syscall
	move	$s4,$v0
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
#=========================================================
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

	addi	$s0,$zero,0
# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#=========================================================		
Indexexception:
	la	$a0,Indexp
	li	$v0,4
	syscall
	j	enterIndex

#=========================================================	
RegisterCount:
	__getData:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	beq $s6, $s5, end
	lw $a1, ($s5)
	andi $s1, $a1, 0xFC000000   # Bit mask the first 6 bits
    	srl $s1, $s1, 26           # Shift right by 26 bits to get the opcode
    	beq $s1, 0x00000000, RType
    	beq $s1, 0x08000000, JType
	IType:
		andi $s1, $a1, 0x1F0000  	# Mask the bits [20:16]
		srl $s1, $s1, 16                 # Shift the value to the right by 16 bits
		beq $a0, $s1, inc
		j else
		inc:
			addi $a3, $a3, 1
		else:
		andi $s1, $a1, 0x03E00000 	# Mask the bits [25:21]
		srl $s1, $s1, 21                 # Shift the value to the right by 21 bits
		beq $a0, $s1, inc2
		j done
		inc2:
			addi $a3, $a3, 1
		done:
		j cont
	JType:
		andi $s1, $a1, 0x3FFFFFF  	 # Mask the bits [25:0]
		sll $s1, $s1, 2                 # Shift the value to the left by 2 bits
		beq $s1, $a0, incj
		j donej
		incj:
			addi $a3, $a3, 1
		donej:
		j cont
	RType:	
		andi $s1, $a1, 0xFFE3	  	  # Mask the bits [11:15]
		srl $s1, $s1, 11                 # Shift the value to the right by 11 bits
		beq $a0, $s1, doner1
		j inkr1
		doner1:
			addi $a3, $a3, 1
		inkr1:
		andi $s1, $a1, 0x1F0000  	# Mask the bits [20:16]
		srl $s1, $s1, 16                 # Shift the value to the right by 16 bits
		beq $a0, $s1, doner2
		j inkr2
		doner2:
			addi $a3, $a3, 1
		inkr2:
		andi $s1, $a1, 0x03E00000 	# Mask the bits [25:21]
		srl $s1, $s1, 21                 # Shift the value to the right by 21 bits
		beq $a0, $s1, doner3
		j inkr3
		doner3:
			addi $a3, $a3, 1
		inkr3:
		j cont
	cont:
	addi $s5, $s5, 4
	beqz $s5, end
	jal __getData
	end:
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra
endProgram:
	li	$v0,10
	sw	$t0, -36($t1)
	syscall
