#Okagbue Onyeka Francis
#CMPT 215 


.data #data section

arr: .space 80 #it stores 20 integers in the array

user: .ascii "Please enter an integer\n"
message: "The array inputted in the console is:- "

arr_position: .asciiz "Please enter the array index into the console:- "

#Start of Program

.text #code section

.main:


li $t1, 2 # print message


AND:
beq $t0, 80, next #checks if branch

#user enter string in the console
li $v0, 4
move $s1, $v0
la $a0, user
syscall


li $v0, 5 #system call code for int read
syscall #execute

swl $v0, arr($t2) #stores the array to the left
add $t2, $t2, 4 # adds 

j AND #identify the instructions

jal AND #return address to register


next:

li $t1, 0 #loads the intermediate
move $s1, $v0

li $v0, 4 #to print string

la $a0, message #argument to print string
syscall #execute








# End of Program









