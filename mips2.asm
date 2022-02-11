.data

prompt: .asciiz "Enter a string: " #prompt for string

promptNumber: .asciiz "Enter a number: " #prompt for string

message: .asciiz "Caesar cipher text is : " #prompt for string

input: .space 100 #string butter of 100 digit

.text

main:

li $v0, 4

la $a0, prompt #prompt for string

syscall

li $v0, 8

la $a0, input #ask for input

li $a1, 100

syscall

move $s0, $a0 #move data to s0

li $v0, 4

la $a0, promptNumber #prompt for string

syscall

li $v0, 5

syscall

move $s7,$v0

li $v0, 4

la $a0, message #prompt for string

syscall

loop: #loop while end of string

lb $a0, 0($s0) #load first character to a0

addi $s0, $s0, 1 #add index by one

beq $a0, $zero, done #else print character

sge $s2,$a0,0x61 #check for lower case range

sle $s3,$a0,0x7a

and $s2,$s2,$s3

bne $s2,1,isNotLower #if not lower case leave it

add $a0,$a0,$s7

ble $a0,122,exit

subi $s4,$a0,122

addi $a0,$s4,96

exit:

isNotLower :

li $v0, 11

syscall

j loop

done:

output: