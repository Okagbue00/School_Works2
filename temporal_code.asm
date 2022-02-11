#OKAGBUE FRANCIS
#CMPT 215

#syscall numbers
#caesar cipher

#define
#it substitutes the first operand for the second operand
.eqv prompt	4294901760
.eqv prompt2	4294901764
.eqv prompt3	4294901772

.align2

.data
buffer:	.word 1000
newIn: .asciiz "\n"

.text
#use $s0 for starting address of the string 

.globl main


main:		jal findend
		sw $v0, prompt3		# display digit
		sub $s0, $v0, '0'		# $s0 = '0','1','2'
		mul $s0, $s0, 10		# $s0 = 0,10,20
		jal findend		# read second digit '0'-'9'
		sw $v0, prompt3		# display digit
		sub $v0, $v0, '0'		# $v0 = 0-9
		add $s0, $s0, $v0		# $s0 = 0-23

		li $v0, 10
		sw $v0, prompt3		# write new line
		
loop:	jal findend
	beq $v0, 10, finished		# stop on return	
	blt $v0, 'a', inlp	# < 'a' output the character
	add $v0, $v0, $s0		# add the shift
	ble $v0, 'z', inlp	# <= 'z' modified with shift still valid
	sub $v0, $v0, 26		# wrap around
		
inlp:	sw $v0, prompt3		# output the character		
	j loop

finished: li $v0, 10 #system call 10; exit and terminates the program

	syscall
		
findend: lw $t4, prompt
	 beq $t4, 0, findend
	 lw $v0, prompt2
	 jr $ra
