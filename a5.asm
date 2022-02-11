#Okagbue Onyeka Francis
#CMPT 215 


.data

user: .ascii"Please enter an integer on the console: "
Console: .asciiz "\n N Integers with value:- "
Message: .asciiz "Integer values greater than 496 but less than or equal to 8128 is:- " #stores string in message and adds null terminator

  


.text

main:
# prompt user to enter an integer in our console

li $v0, 4 #load text stored in v0
la $a0, user #print user
syscall #call prompt string


jal User_Input #returns the address into $ra register

li $t5, 0  # to get integers been prompted in

# Display message on my console

li $v0, 4 #load text stored in v0
la $a0, Console #print user
syscall #execute

#show the user input
li $v0, 1
move $a0, $t1
syscall

loop:
li $v0, 5 #load number stored in v0
syscall # system call
move $s1, $v0 # loads my specific numeric value into the register
addi $t0, $t0, 1 #if-body increment

beq $t0, $s0, print #if t0 equals 0 branch
bgt $s1, 496, increase #check if the second branch is greater than
j loop #identify which instruction should be executed

increase:
addi $t1, $t2, 1  #to get the integers that are less than or equal to 8128 and greater than 496
beq $t0, $s0, print
j loop #shows which instructions will be executed

integer:
ble $s1, 8128, increase #if branch less than or equal 
beq $t0, $s0, print #  check if the branch is equal
j loop #identify the instructions

User_Input:
# Going to get the user input on the console

li $v0, 5 # to get an integer from the keyboard
syscall 



#Going to store my value in $s1
move $s0, $v0

jr $ra #instruction returns control to the caller

print:
#display message
li $v0, 4 #call the system code for the message
la $a0, Message #address of string to output
syscall # call system

# print integers greater than 496 but less than or equal to 8128.
li $v0, 1 
move $a0, $t1
syscall

li $v0, 4 #load text stored in v0
la $a0, Console #print text from address a0

li $v0, 10 #terminate program, run and 
syscall #execute

# End of program










