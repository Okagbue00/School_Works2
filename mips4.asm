# OKAGBUE FRANCIS
# CMPT 215



.data


rootstatic:	.word rootnode

rootnode:	.word lchild
		.word 28
		.word rchild
		
lchild:		.word 0
		.word 6
		.word 0
		
rchild:		.word rchildlchild
		.word 8128
		.word rchildrchild
		
rchildlchild: 	.word 0
		.word 496
		.word 0
		
rchildrchild:	.word 0
		.word 33550336
		.word 0
		
rootdynamic: 	.word 0


free_list:       .word 0

address:         .space  300

prmpt:         .asciiz "Enter I for insert and D for delete in the list:- "

prmpttree:       .asciiz "Print the static tree (Y/N)?:- "

	.align 2

user:          .space 100

newIn:         .asciiz "\n"



.text


.globl main


main: la $s0, rootdynamic # is the address of the root of the tree

      la $a0, address
    
      li $a1, 25 # is the space to put user word
    
      jal init #initializes the free list
    
      la $s1, free_list #makes free list a parameter [to load address]
    
      sw $v0, 0($s1) #stores the word
    
loop:

    
    la $a0, prmpt #prints message
    
    li $v0, 4 #prompt for printing the string
    
    syscall #executes
    
    
    li $v0, 8 # read string
    
    la $a0, user #inputs from the user
    
    li $a1, 20 #allocate the byte space for string
    
    syscall #executes

   
    la $t0, user  # loads the address
    
    lb $t1, 0($t0) #loads the byte address 

    beq $t1, 'I', inserts #check if can be inserts
   
    beq $t1, 'D', deletes #check if you can remove D
    
    jal static_tree #return the static tree
     
inserts:
    
    add $a0, $t0, 1 # it gets the integer for I
    
    jal values #jumps and links the values

    
    move $a0, $v0 #moves the content
    
    move $a1, $s0
    
    move $a2, $s1
    
    jal increase #jumps and links to the program counter 
    
deletes:
    
    add $a0, $t0, 1 #gets the integer for D
    
    jal values #then sets to the program counter

    move $a0, $v0 #moves the contents
    
    move $a1, $s0
    
    move $a2, $s1
    
    jal decrease
    
    jal loop #iterates and ask the user to input a new value
    
    
static_tree:
    
    la $a0, prmpttree # is the address 
    
    li $v0, 4 #prompt for string
    
    syscall #executes
    
    li $v0, 8 #it reads the string
    
    la $a0, user #asks user to input to the console
    
    li $a1, 20 #allocate the byte space for string
    
    syscall #then executes

    la $t0, user #load the address 
    
    lb $t1, 0($t0) #and then loads the bytes

    beq $t1, 'Y', display #checks if the static is Y

    la $t0, rootdynamic #loads the address and displays the root dynamic 
    
    jal buffer #it then links to the register
    
display:   
 
    la $t0, rootstatic #it then displays the static tree
    
buffer:   
    
    lw $a0, 0($t0) #it loads the word of the first node
    
    jal printtree #then jumps and prints the tree
    

    
    la $a0, newIn #it then prints a new line
    
    li $v0, 4 #then prints the string
    
    syscall #executes

    
    li $v0, 10 #terminates the program
    
    syscall #executes

values:
    
    li $v0, 0 #loads the intermediate number to zero
    
bitwise:
    
    lb $t0, 0($a0) #loads the byte
    
    beqz $t0, register #check if is equal to zero
    
    
    slti $t1, $t0, '0' #branch to next if $t0 < 1
    
    bnez $t1, register #checks if the branch is not equal to zero
    
    li  $t2, '5' #it loads the immediate
    
    slt  $t1, $t2, $t0 #checks if t2 is less than t0
    
    bnez $t1, register #then checks if the branch is not equal to zero
    
    addi $t0, $t0, -48 #converts to american standard code for information interchang
   
    li  $t1, 10 #multiply by ten
    
    mult $v0, $t1
    
    mflo $v0 #it then moves from lowest 
    
    add  $v0, $v0, $t0 # it then adds v0 + t0

    addi $a0, $a0, 1 #then adds a0 + 1
    
    j bitwise #returns the bitwise
    
register:

    jr $ra #it then jumps unconditionally



printtree:
    
  addi $sp, $sp, -8 #adjusts the stack
  
    sw $ra, 0($sp) #saves ra to stack pointer
    
    sw $s0, 4($sp) #saves s0 to stack pointer

    move $s0, $a0 # moves to a0

    beqz $a0, show #checks if the node is zero
    
    lw  $a0, 0($s0)
    
    jal printtree #returns the printtree
    
    lw  $a0, 4($s0)
    
    li  $v0, 1 #prints the node
    
    syscall #executes

    
    lw  $a0, 8($s0)
    
    jal printtree  
    
  
show:
    # restore registers
    lw $ra, 0($sp) #load the word ra to the stack pointer
    
    lw $s0, 4($sp) # load the word s0 to the stack pointer
    
    addi $sp, $sp, 8 #then adjust the stack
    
    jr $ra #return the contents


increase:
    
    addi $sp, $sp, -8 #adjusts the stack
    
    sw $ra, 0($sp) #saves ra to stack pointer
    
    sw $s0, 4($sp) #saves s0 to stack pointer

    move $s0, $a0 # moves to a0

    lw   $t0, 0($a1) 
    
    bnez $t0, recursion #checks if is zero 

    
    addu $a0, $zero, $a2
    
    jal alloc #then allocates space for the nodes
    
    
    sw  $s0, 4($v0) #stores the word
    
    sw  $0, 0($v0) # then stores the left root and right of the tree
    
    sw  $0, 8($v0)
    
    sw  $v0, 0($a1)
    
    li  $v0, 0 #then load the immediate 
    
    j instruction
    
recursion:

    li $v0, 0
    
    lw  $t1, 4($t0) #then loads the value
   
    beq $t1, $a0, instruction

   
    blt $a0, $t1, insleft #check if is less than
    
    addi $a1, $t0, 8 #inserts to the right
    
    j exp #returns exp
    
insleft:
    addi $a1, $t0, 0 #sets a1 to t0
    
exp:

    jal increase #jumps to increase

instruction:
    
    lw $ra, 0($sp) #load word and then sets back the normal register 
    
    lw $s0, 4($sp)
    
    addi $sp, $sp, 8
    
    jr $ra #returns to set counter



decrease:
    
    
    addi $sp, $sp, -16 #adjusts the stack
    
    sw $ra, 0($sp) #saves registers in the stack pointer
    
    sw $s0, 4($sp)
    
    sw $s1, 8($sp)
    
    sw $s2, 12($sp)

    move $s0, $a0 #sets s0 to a0
    
    move $s1, $a1 #sets s1 to a1
 
    li $s2, 0 #loads the immediate word

   
search:
   
    lw  $t0, 0($s1)
    
    beqz $t0, pointer
    
    move $t2, $t0

    
    lw  $t1, 4($t0) #loads the word
    
    bgt $a0, $t1, search_right #checks if the branch is greater than
    
    blt $a0, $t1, search_left #and if is less than
    
    j found #jumps to found
    
search_right:
    addi $s1, $t0, 8 #searches the right 
    
    j switch
    
search_left:
    addi $s1, $t0, 0  #searches the left
    
switch:
    move $s2, $t2
    j  search
    
found:
    
    lw $t0, 0($s1) #it loads the word of the deleted nodes in the tree
    
    lw $t1, 0($t0) #loads the word of the deleted nodes in the tree
    
    lw  $t2, 8($t0) 
    
    bnez $t1, notIorD #beanch if not equal to zero
    
    bnez $t2, notIorD

    
    beqz $s2, root1 #then checks the root

    # if deleted node is left child
    lw $t3, 0($s2)
    

    # remove from parent's left
    sw $0, 0($s2)
    

    
root1:
    
    sw $0, ($a1) #stores the word
    
    j free_node #then deletes the root
    
notIorD:
    
    bnez $t1, r_here #checks if the branch is empty

    beqz $s2, del_root

    lw $t3, 0($s2) #then loads the word
    
    bne $t3, $t0, remove_right

    
    sw $t2, 0($s2)
    
    j  free_node
    
remove_right:
   
    sw $t2, 8($s2) #moves the right parent
    
    j free_node
    
del_root:
   
    sw $t2, ($a1)
    
    j free_node #delete root

r_here:
   
    beqz $s2, realtem #checks if the parent is zero

    lw $t3, 0($s2)
    
    bne $t3, $t0, getlp 

   
    sw $t1, 0($s2) #stores the word 
    
    j  free_node
getlp:
   
    sw $t1, 8($s2) #copies to the parent right
    
    j free_node
    
realtem:
    
    sw $t1, ($a1) #deletes the root
    
    j free_node

free_node:
    
    move $a0, $t0 #then frees the node
    
    move $a1, $a2
    
    jal free

    j pointer
    
ret:

    lw  $t4, 0($t3) #loads the word
    
    lw  $t5, 0($t4)
    
    beqz $t5, findend #checks if the branch is null
    
    move $t3, $t4
    
    j  ret #jumps to ret
    
findend:
   
    lw  $t4, 0($t3) #loads the minimum word
    
    lw  $t4, 4($t4)
    
    sw  $t4, 4($t0)
   
    move $a0, $t4 #then delete node
    
    move $a1, $t3
    
    jal  decrease #jumps and links
    
pointer:
    lw $ra, 0($sp) #it restores the registers in stack pointer
    
    lw $s0, 4($sp)
    
    lw $s1, 8($sp)
    
    lw $s2, 12($sp)
    
    addi $sp, $sp, 16
    
    
    jr $ra #returns to the main program




inner_iterate:

    addi  $t0, $a0, 12
    
    sw   $t1, 0($a0)  #stores t1
    
    sw   $t0, 4($a0) #stores t0
    
    addi $a0, $a0, 12 
    
    addi $a1, $a1, -1
    
    bnez $a1, inner_iterate #checks if is not equal to zero 
    
    addi $a0, $a0, -12
    
    sw   $zero, 4($a0)
    
    jr $ra


# procedure init initializes the free list
# procedure arguments as follows:
#   $a0 - address of block of memory to be used for free list
#   $a1 - desired size of free list (number of nodes)
# procedure returns pointer to first node in free list      

		
init:	  	move $v0,$a0

	  	blez $a1,init_r
	  	
init_l:   	sw $zero,0($a0)

	  	sw $zero,4($a0)
	  	
	  	addi $a0,$a0,12
	  	
	  	sw $a0,-4($a0)
	  	
	  	addi $a1,$a1,-1
	  	
	  	bne $zero,$a1,init_l
	  	
	  	sw $zero,-4($a0)
	  	
init_r:   	jr $ra


		# procedure alloc gets a node from the free list
        	# procedure argument as follows:
        	#   $a0 - address of word containing the address of the first node in free list
        	# procedure returns pointer to unlinked node
alloc:		lw $v0,0($a0)

	  	beq $v0,$zero,alloc_r  	#if free list is empty, return 0
	  	
	 	lw $t0,8($v0)
	 	
	  	sw $t0,0($a0)
	  	
	  	sw $zero,8($v0)
	  	
alloc_r:  	jr $ra

		# procedure free returns a node to the free list
        	# procedure arguments as follows:
        	#   $a0 - address of word containing the address of the first node in free list
		#   $a1 - address of node that should be added to free list
free:		lw $t0,0($a0)

	  	sw $a1,0($a0)
	  	
	  	sw $t0,8($a1)
	  	
	  	sw $zero,4($a1)
	  	
	  	sw $zero,0($a1)
	  	
	  	jr $ra
