#CS224
#Recitation 3
#Section 006
#Alara Zeybek
#22102544
#24.03.23

.data
	endl: .asciiz "\n"
	input1: .asciiz "Please enter a number:\n"
	
	listSize: .asciiz "Creating the ORIGINAL linked list.\nPlease enter the list size:"
	olist: .asciiz "ORIGINAL linked list.:"
	wToCreateEmpty: .asciiz "\nWarning, user wants to create empty list !!!\n"
	deleteTxt: .asciiz "\nDeleting the multiple values...\n"
	PrintingReverseOrder: .asciiz "\nPrinting in Reverse Order: \n"
	ReverseLinkListTxt: .asciiz "\n\nReversing Linked List...\n"
	
	
	line:	.asciiz "\n --------------------------------------"
	nodeNumberLabel: .asciiz "\n Node No.: "
	addressOfCurrentNodeLabel: .asciiz "\n Address of Current Node: "
	addressOfNextNodeLabel: .asciiz	 "\n Address of Next Node: "
	dataValueOfCurrentNode: .asciiz	 "\n Data Value of Current Node: "
	NumberofNodes: .asciiz "Number of Nodes in the copied linked list: "
	
	invalidListSizeException: .asciiz "\n!! Invalid linked list Size!! Please try again.\n"
	
	starts: .asciiz "First Starts."
	control: .asciiz "\ns0 value:	"
	control2: .asciiz "\ns1 value:	"
	control3: .asciiz "\ns2 value:	"
	
	
.text

main:
#-------------------------CREATING THE ORIGINAL LINKED LIST-----------------------
attheBegining:
	la	$a0,listSize
	li	$v0,4
	syscall
	li	$v0,5
	syscall
#Size exception checks:
	beqz	$v0,WantToCreateEmptyList	#USER ENTERS 0 FOR THE LIST SIZE
	bltz	$v0,invalidListSize		#USER ENTERS NEGATIF NUMS FOR THE LIST SIZE
#---------------------Starts creating-------------------------------------------	
	move	$s0,$v0				# s0 = linked list size
	move	$a0,$s0				# a0 = parameter holds the size
	jal	createLinkedList
	move	$s1, $v0			# Pass the linked list address in $s1
	la	$a0,olist
	li	$v0,4
	syscall
	move	$a0, $s1			# Pass the linked list address in $a0
	jal	printLinkedList
	la	$a0,endl
	li	$v0,4
	syscall
	
#-------------------------RECITATION-----------------------
# Deleting Multiples
	la	$a0,deleteTxt
	li	$v0,4
	syscall
	beq	$s0,1,DeletingNotNecessary
	move	$a0, $s1			# Pass the original linked list address in $a0
	jal	deleteRepeating
	move	$s0, $v1
DeletingNotNecessary:	
	move	$a0, $s1			# Pass the linked list address in $a0
	jal	printLinkedList
# Printing Reverse Order
	la	$a0,PrintingReverseOrder
	li	$v0,4
	syscall
	move	$a0, $s0			# Pass the original linked list address in $a0
	move	$a1, $s1			# Pass the original linked list address in $a0
	jal	PrintInReverseOrder	
	la	$a0,endl
	li	$v0,4
	syscall
# Reversing Linked List
	la	$a0,ReverseLinkListTxt
	li	$v0,4
	syscall
	beq	$s0,1,ReversingNotNecessary
	move	$a0, $s1			# Pass the original linked list address in $a0
	jal	ReverseLinkList
	move	$s1,$v1				# $v1 is the new address of the head
ReversingNotNecessary:
	move	$a0, $s1			# Pass the linked list address in $a0
	jal	printLinkedList
	j	endProgram
	
#---------------- Exception handling jump -------------------------------------
WantToCreateEmptyList:
	la	$a0,wToCreateEmpty
	li	$v0,4
	syscall
	j	endProgram
invalidListSize:
	la	$a0,invalidListSizeException
	li	$v0,4
	syscall
	j	attheBegining
#========================== END OF MAIN ==========================================	
#=================================================================================		
#=============================  RECITATION  FUNSTIONS ===========================
#---------------------------- DELETING REPEATING NODES	--------------------------
deleteRepeating:
	addi	$sp, $sp, -24
	sw	$s4, 20($sp)
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram


	move	$v1, $s0	# $v1: Node number
	addi	$s0,$zero,0
# $a0: points to the linked list.
	move 	$s0, $a0	# $s0: points to the current node.
	
CheckingFirstNode:
	bne	$s0,$zero,forLoopStart
	#if empty list go the end of sub
	j	endofSub
forLoopStart:
	lw	$a0,4($s0)	# $a0 = $s0's data
	move	$s3, $s0	
moveNext:
	lw	$s4,0($s3)	#s3 prev node
				#s4 current node
	beq	$s4, $zero, endofrepeating
	lw	$s2, 4($s4)	# $s2: Data of current node
	bne	$a0, $s2, continueFor
	lw 	$s2, 0($s4)	# next->next Node's address
	sw 	$s2, 0($s3)	# prev node points next->next
	addi	$v1,$v1,-1
	j	forLoopStart
continueFor:
# Now consider next node.
	lw	$s1, 0($s3)	# $s1: Address of  next node
	move	$s3, $s1	# Consider next node.
	j	moveNext
endofrepeating:
# Restore the register values
	lw	$s1, 0($s0)	# $s1: Address of  next node
	move	$s0, $s1	# Consider next node.
	j	CheckingFirstNode
endofSub:
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	lw	$s4, 20($sp)
	addi	$sp, $sp, 24
	jr	$ra
#===================================== Print In REverse Order ============================================
PrintInReverseOrder:
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 
	la $s7, ($a0) #the count
	move $s0, $a1
printtop:
#extend the stack for the list amount and store the list items to be printed in reverse.
#start from the head and iterate through the list 
#IN each iteration add the current node to 0(sp) and increment a variable
#when done, start popping from 0(sp) and addi 4 to sp until the variable we incremented is 0
	beqz $s7, printdone
	addi $sp, $sp, -4
	#move	$a0, $s2	# $s2: Data of current node
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	sw $s2, ($sp)
	move	$s0, $s1	# Consider next node.
	addi $s7, $s7, -1
	j printtop
printdone:
	la $s7, ($a0)
	rec:
		beqz $s7, dd
		la	$a0,dataValueOfCurrentNode
		li	$v0,4
		syscall
		lw	 $a0, ($sp)
		li 	$v0, 1
		syscall
		li $v0, 4
		la $a0, endl
		syscall
		addi $sp, $sp, 4
		addi $s7, $s7, -1
		j rec
	dd:
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
	jr	$ra
	
#===================================== RECURSIVE REVERSE LINKLED LIST ====================================
ReverseLinkList:	
	addi	$sp, $sp, -12
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	move	$s0,$a0
	jal	RecursivFunc
	sw	$zero,0($s0)
	
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	addi	$sp, $sp, 12
	jr	$ra
	
RecursivFunc:  	
	move	$v1,$s0
	lw	$s1,0($s0)
	beqz	$s1,baseCase	#kuyruktayim
	addi	$sp, $sp, -8
  	sw 	$ra, 0($sp)             # save return address on stack
	sw	$s0, 4($sp)
	
	move	$s0,$s1
	jal	RecursivFunc
baseCase:
	lw 	$ra, 0($sp)             # load return address
        lw 	$s1, 4($sp)             # load $s0  
        sw	$s1,0($s0)
        lw	$s1,0($s0)
        move	$s0,$s1
        addi 	$sp, $sp, 8	         # allocate space on stack for return address
	jr	$ra
	

#-----------------------------HELPER FUNCTIONS-----------------------------------
createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 continueIterationains 4 in the data field, node i continueIterationains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node continueIterationent from the node sequence no (1, 2, ...).
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
#------------------------------------------------END--------------------------------------

endProgram:
	li	$a0,0
	li	$v0,10
	syscall
