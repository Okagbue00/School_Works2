#Okagbue Onyeka Francis
#CMPT 215 


#Start of Program
.data
data: .space 84 #allocates  bytes of space 
data_rev: .space 84 #reserves the next byte in the data segment


user: .ascii "Please enter a string into the console:- " #does not add null terminator
message: .ascii "The string in reverse order:- "

.main:

.text 



#prompt user to input a message
li $v0, 4 #load text stored in v0
la $a0, user #print user
syscall #call prompt string

li $t7 0 #to get the user input

#Display message
li $v0,  #It loads the register v0 with the value 8

la $a0, data #address of data to print on the console
li $a1, 30 #assumes at most 30 characters
li $a1, 20 #20 characters
syscall #execute

#conditional statement
character: 
lb $t7, data($t1) #loads a byte from the memory $t0 to the data
beqz  $t7, AND #if branch statement to check if AND if register $t0 == 0
addu $t1, $t1, 1 #addition without overflow $t1 = $t1 + 1
j character #go to character Direct jump
jr $ra

jal character #saves character to my register $ra

AND:
li $t2, 0 #t2 = 0
move $t5, $zero #t3 = 0
#sub $t1, $t2, -2
add $t1, $t1 -2 #intermediate operand $t1 = $t1 - 2

total:
blt $t1, $zero, display #branch less than ($t1 < 0)
lb $t5, data($t1) #will load the byte $t3 to data
move $t4, $zero
sb $t5, data_rev($t2) #will store $t3 into the memory byte address (8bit store)
subi $t1, $t1, 1 # $t1 = $t1 - 1; stores in the register $t1
addi $t2, $t2, 1 # $t2 = $ t2 - 1
j total #direct jump
jal total


display:
#display message 

sb $zero, data_rev($t2) #stores memory $t2+ data_rev = $zero [8 bit store]
li $v0, 4 #call the system code for the message
la $a0, message  #address of string to output


li $v1, 4 #call system code 
la $a0, data_rev #address of sting to output in reverse format
syscall #call the system
li $v0, 10 #it terminates the program
syscall #execute





#End of Program