
	.data
freelist: .word 0
Linkedlist: .word 0
nodes:	.space 400
A: .ascii "A"
R: .ascii "R"
space: .asciiz "	"
prompt: .asciiz "\nEnter A for add, R for remove all, followed by a number: " 
output: .asciiz "\nNodes in linked list are:\n"

	.text
main:
	# make the node a parameter
	# load all addresses
	la $a0,nodes
	li $a1,25
	jal init
	sw $v0,freelist 
	lbu $s0,A
	lbu $s1,R
	la $s2,freelist 
	la $s3,Linkedlist

loop:
	# prompt user
	la $a0,prompt 
	li $v0,4 
	syscall
	# get leter
	li $v0,12 
	syscall
	# check if the letter is A
	bne $v0,$s0,notA 
	# get number
	li $v0,5
	syscall
	# Store our values in parameter, and proceed to insertion
	move $a0,$v0 
	move $a1,$s3 
	move $a2,$s2 
	jal addA
	j loop

notA:
	# check if letter is either A or R
	bne $v0,$s1,notAorR 
	li $v0,5
	syscall
	move $a0,$v0 
	move $a1,$s3 
	move $a2,$s2
	# jump to delete, given not A
	jal remove
	j loop



# procedure arguments as follows:
#   $a0 - address of block of memory to be used for free list
#   $a1 - desired size of free list (number of nodes)
# procedure returns pointer to first node in free list
init:	  	
	move $v0,$a0
	blez $a1,init_r
	  	
	  	
init_l:   	
	sw $zero,0($a0)
	addi $a0,$a0,8
	sw $a0,-4($a0)
	addi $a1,$a1,-1
	bne $zero,$a1,init_l
	sw $zero,-4($a0)
	
init_r:   	
	jr $ra

# procedure alloc gets a node from the free list
# procedure argument as follows:
#   $a0 - address of word containing the address of the first node in free list
# procedure returns pointer to unlinked node

alloc:		
	lw $v0,0($a0)
	beq $v0,$zero,alloc_r  	#if free list is empty, return 0
	lw $t0,4($v0)
	sw $t0,0($a0)
	sw $zero,4($v0)
	
alloc_r:  	
	jr $ra

# procedure free returns a node to the free list
# procedure arguments as follows:
#   $a0 - address of word containing the address of the first node in free list
#   $a1 - address of node that should be added to free list
free:		
	lw $t0,0($a0)
	sw $a1,0($a0)
	sw $zero,0($a1)
	sw $t0,4($a1)
	jr $ra

# Not a and not r
notAorR:
	# display empty linked list
	la $a0,output
	li $v0,4
	syscall
	lw $s2,Linkedlist
	# go on to terminate code
	beqz $s2,terminate

display:
	# Display the linked list
	li $v0,1
	lw $a0,0($s2) 
	syscall
	li $v0,11
	lbu $a0,space 
	syscall
	lw $s2,4($s2) 
	bnez $s2,display # check for null pointer

terminate:
	# terminate code
	li $v0,10
	syscall

addA:
	# Add items to the last
	lw $t0,0($a1)
	beqz $t0,Add_here
	lw $t1,0($t0)
	beq $a0,$t1,Add_done 
	blt $a0,$t1,Add_here 
	addiu $a1,$t0,4
	j addA

Add_here:
	addi $sp,$sp,-20 
	sw $t0,16($sp) 
	sw $a0,12($sp) 
	sw $a1,8($sp) 
	sw $a2,4($sp) 
	sw $ra,0($sp) 
	move $a0,$a2 
	jal alloc
	lw $ra,0($sp)
	lw $a2,4($sp) 
	lw $a1,8($sp)
	lw $a0,12($sp)
	lw $t0,16($sp)
	addi $sp,$sp,20
	beq $zero,$v0,Add_done 
	sw $a0,0($v0)
	sw $t0,4($v0) 
	sw $v0,0($a1)


Add_done: 
	jr $ra

remove:
	lw $t0,0($a1)
	beqz $t0,Remove_done 
	lw $t1,0($t0)
	beq $a0,$t1,Remove_here 
	addiu $a1,$t0,4
	j remove

Remove_here:
	lw $t2,4($t0)
	sw $t2,0($a1)
	addi $sp,$sp,-4
	sw $ra,0($sp) 
	move $a0,$a2 
	move $a1,$t0
	jal free
	lw $ra,0($sp)
	addi $sp,$sp,4

Remove_done:
	jr $ra
