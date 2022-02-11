	.data

#store integer
array: .space 100
#take three parameters
low_integer: .word 0
high_integer: .word 0
starting_address: .word 0

#Strings prompt
prompt: .asciiz "Enter number of integers n:-\n "
prompt2: .asciiz "Input the n integers Assuming:-\n "
prompt3: .asciiz "Integer Low:-\n "
prompt4: .asciiz "Integer High:-\n "
output: .asciiz "The integer return value is:- " 
newLine: .asciiz "\n"



	.text

main:   li $v0, 4 #prompt for entering integers
	la $a0, prompt 	
	syscall

inlp: 	li $v0, 5 #read integer and store in array
	syscall
	la $a0, starting_address
	sw $v0, 0($a0) #store in my starting address. [$a0 + 0] = $v0;
	li  $v0, 4 #prompt for integer
	la $a0, prompt2 # prompt for another integer and prints out
	syscall #terminate and call
	
search:	li $t0, 0 #load intermediate into register
	lw $t1, starting_address #load the starting adddress
	la $a1, array #load address into the array
	
loop:	beq $t0, $t1, found #check branch if equal
	li $v0, 5 #read integer 
	syscall #terminate and exit
	sw $v0, 0($a1) #store into $v0
	addi $a1, $a1, 4 #$a1 = $a1 +4
	addi $t0, $t0, 1 #load size of array into $t0
	j loop #goto loop
	
found:	li $v0, 4 #prompt for integer
	la $a0, prompt3 #prompt for integer and prints it out
	syscall #terminate
	li $v0, 5 #read integer
	syscall #call the system
	sw $v0, low_integer #store value into low_integer
	
iterate:li $v0, 4 #prompt for integer
	la $a0, prompt4 #prompt for integer and prints out
	syscall #call the function
	li $v0, 5 #read integer
	syscall #terminate
	sw $v0, high_integer #store value into high_integer
	
check: 	la $a0, array #load argument into array
	lw $a1, low_integer #load word into low_integer
	lw $a2, high_integer #load word into high_integer
	jal sum #jump and link
	
	
count:	move $a1, $v0 #return the value
	li $v0, 4
	la $a0, output
	syscall
	li $v0, 1
	move $a0, $a1
	syscall
	li $v0, 10
	syscall
	
sum:	move $a0, $a0
	move $s1, $s1
	move $s2, $s2
	li $t0, 1
	li $t1, 0
	sw $t2, 0($s0)
	
loop2:	beqz $t2, exit	
	blt $t0, $s1, bit
	bgt $t0, $s2, bit
	add $t1, $t1, $t2
	
	
bit:	addi $s0, $s0, 4
	lw $t2, 0($s0)
	addi $t0, $t0, 1
	j loop2
	
exit:	move $v0, $t1
	jr $ra
	
	
	 
		
	
	
