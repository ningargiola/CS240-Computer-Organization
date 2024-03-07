jal main
#                                           CS 240, Lab #3
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                     	DO NOT change anything outside the marked blocks.
# 
#               Remember to fill in your name, student ID in the designated sections.
# 
#
j main
###############################################################
#                           Data Section
.data
# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Nicholas Ingargiola"
student_id: .asciiz "827476189"

new_line: .asciiz "\n"
space: .asciiz " "
testing_label: .asciiz ""
unsigned_addition_label: .asciiz "Unsigned Addition (Hexadecimal Values)\nExpected Output:\n0154B8FB06E97360 BAC4BABA1BBBFDB9 00AA8FAD921FE305 \nObtained Output:\n"
fibonacci_label: .asciiz "Fibonacci\nExpected Output:\n0 1 5 55 6765 3524578 \nObtained Output:\n"
file_label: .asciiz "File I/O\nObtained Output:\n"

addition_test_data_A:	.word 0xeee94560, 0x0154a8d0, 0x09876543, 0x000ABABA, 0xFEABBAEF, 0x00a9b8c7
addition_test_data_B:	.word 0x18002e00, 0x0000102a, 0x12349876, 0xBABA0000, 0x93742816, 0x0000d6e5

fibonacci_test_data:	.word  0, 1, 2, 3, 5, 6, 

bcd_2_bin_lbl: .asciiz "\nAiken to Binary (Hexadecimal Values)\nExpected output:\n004CC853 00BC614E 00008AE0\nObtained output:\n"
bin_2_bcd_lbl: .asciiz "\nBinary to Aiken (Hexadecimal Values) \nExpected output:\n0B03201F 0CC3C321 000CBB3B\nObtained output:\n"


bcd_2_bin_test_data: .word 0x0B03201F, 0x1234BCDE, 0x3BBB2

bin_2_bcd_test_data: .word 0x4CC853, 0x654321, 0xFFFF


hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

file_name:
	.asciiz	"lab3_data.dat"	# File name
	.word	0
read_buffer:
	.space	300			# Place to store character
###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
jr $ra
###############################################################
###############################################################
###############################################################
#                           PART 1 (Unsigned Addition)
# You are given two 64-bit numbers A,B located in 4 registers
# $t0 and $t1 for lower and upper 32-bits of A and $t2 and $t3
# for lower and upper 32-bits of B, You need to store the result
# of the unsigned addition in $t4 and $t5 for lower and upper 32-bits.
#
.globl Unsigned_Add_64bit
Unsigned_Add_64bit:
move $t0, $a0
move $t1, $a1
move $t2, $a2
move $t3, $a3
############################## Part 1: your code begins here ###

addu $t4, $t0, $t2	# adding both given numbers lower
sltu $t6, $t4, $t0	# storing carry bit
addu $t6, $t6, $t1	# adding high bits and anything leftover
addu $t5, $t6, $t3 

############################## Part 1: your code ends here   ###
move $v0, $t4
move $v1, $t5
jr $ra
###############################################################
###############################################################
###############################################################
#                            PART 2 (Aiken Code to Binary)
# 
# You are given a 32-bits integer stored in $t0. This 32-bits
# present a Aiken number. You need to convert it to a binary number.
# For example: 0xDCB43210 should return 0x48FF4EA.
# The result must be stored inside $t0 as well.
.globl aiken2bin
aiken2bin:
move $t0, $a0
############################ Part 2: your code begins here ###
# Initalize data 
li $t1 0          #Initialize to zero
li $t2 8          #Initialize to 8
li $t3 4          #Initialize to 4
li $t4, 0         #Initialize to zero
ror $t4, $t0, 28  #Rotate by 28 bits and store in $t4
li $t7, 0         #Initialize to zero
li $t8, 10        #Initialzie to 10
li $t9, 0         #Initialize to zero

#Main loop
loop:                
andi $t9 $t4, 0x000F  #Extract lowest 4 bit
ble $t9, $t3, skipSub #Branch if $t9 <= $t3
subi $t9, $t9, 6     #Sub 6

#Skip Subtraction
skipSub:
mul $t7, $t7, $t8        #Mult $t7 by $t8
add $t7, $t7, $t9        #add $t9 to $t7
addi $t1, $t1, 1         #Increment by 1 
bge $t1, $t2, loopEnd    #Brand if $t1 >= $t2
rol $t4, $t4,4           #Rotate $t4 by 4 bits
j loop                   #Jump back to begining of loop

#End of conversion
loopEnd:
move $t0, $t7  #Store final anser in $t0

############################ Part 2: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                            PART 3 (Binary to Aiken Code)
# 
# You are given a 32-bits integer stored in $t0. This 32-bits
# present an integer number. You need to convert it to a Aiken.
# The result must be stored inside $t0 as well.
.globl bin2aiken
bin2aiken:
move $t0, $a0
############################ Part 3: your code begins here ###
#Inititalize
li $t9, 10000000 #Intialize with decimal number
li $t0, 0        #Initialize to 0
li $t7, 8        #Initialize to 8

#loop
digits:
div $a0, $t9 #Divide by 16
mfhi $t2     #Remainder
mflo $t1     #Quotient

#Check if quotient is less than 5
blt $t1, 5, update 
sub $t1, $t1, 5
addi $t1,$t1, 0xB #If not calculate digit

#Update $t0
update:
sll $t0, $t0, 4   #Shift left $t0 by 4 
or $t0, $t0, $t1  #Combine with $t0

move $a0, $t2     #Update $a0 with remainder
div $t9, $t9, 10  #Divide $t9 by 10

sub $t7, $t7, 1   #Decrement loop counter
bnez $t7, digits  #Continue loop if counter isn't zero

############################ Part 3: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
###############################################################
###############################################################


###############################################################
###############################################################
###############################################################
#                           PART 4 (ReadFile)
#
# You will read characters (bytes) from a file (lab3_data.dat) 
# and print them. 
#Valid characters are defined to be
# alphanumeric characters (a-z, A-Z, 0-9),
# " " (space),
# "." (period),
# (new line).
#
# 
# Hint: Remember the ascii table. 
#
.globl file_read
file_read:
############################### Part 4: your code begins here ##
#open file
addi $v0, $zero, 13     #Opening file
la $a0, file_name       #Load address of file into $a0
move $a1, $zero         #File open
move $a2, $zero
syscall                 #System call

#file opened
move $t1, $v0           #Store file in $t1

#read file using syscall 14
move $a0, $t1           #Store file in $a0
la $a1, read_buffer     #Load address of read_buffer into $a1
addi $a2, $zero, 300    #Maximum number of bytes to read
addi $v0, $zero, 14     #System call for reading file
syscall                 #System call

#finally close file
addi, $v0, $zero, 16    #System call for closing file
move $a0, $t1           #File in $a0
syscall                 #System call
la $a1, read_buffer     #Clearing address of read_buffer into $a1

move $t0, $zero		#i = 0 $t0

fr_loop:
bge $t0, 300, fr_ret		#if i >= 300, return
lb $t1, ($a1)			#byte at address (t1)
#Check if byte is Valid char
beq $t1, ' ', isValid		# if byte is ' ' the is valid
beq $t1, '.', isValid		# if byte is '.' the is valid
beq $t1, '\n', isValid		#if byte is '\n' the is valid
blt  $t1, '0', fr_continue	#Check if byte is less than zero
ble $t1, '9', isValid		#'0' <= byte <= '9'
blt $t1, 'A', fr_continue	#Check if byte is less than A
ble $t1, 'Z', isValid		#'A' <= byte <= 'Z'
blt $t1, 'a', fr_continue	#Check if byte is less than a
blt $t1, 'z', isValid		#'a' <= byte <= 'z'
j fr_continue			#Jump to loop continuation

isValid:
#valid char: print it
move $a0, $t1			#Char printed in $a0
addi $v0, $zero, 11		#syscall to print char
syscall 			#System call

fr_continue:
addi $t0, $t0, 1		#i++
addi $a1, $a1, 1		#buffer++
j fr_loop			#jump to loop

fr_ret:


############################### Part 4: your code ends here   ##
jr $ra
###############################################################
###############################################################
###############################################################

#                          Main Function
main:

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall
la $a0, new_line
syscall
##############################################
##############################################
test_64bit_Add_Unsigned:
li $s0, 3
li $s1, 0
la $s2, addition_test_data_A
la $s3, addition_test_data_B
li $v0, 4
la $a0, testing_label
syscall
la $a0, unsigned_addition_label
syscall
##############################################
test_add:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 4($s4)
lw $a2, 0($s5)
lw $a3, 4($s5)
jal Unsigned_Add_64bit

move $s6, $v0
move $a0, $v1
jal print_hex
move $a0, $s6
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 8
addi $s0, $s0, -1
bgtz $s0, test_add

li $v0, 4
la $a0, new_line
syscall
##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
la $a0, bcd_2_bin_lbl
syscall
# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, bcd_2_bin_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal aiken2bin

move $a0, $v0        # hex to print
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
la $a0, bin_2_bcd_lbl
syscall

# Testing part 3
li $s0, 3 # num of test cases
li $s1, 0
la $s2, bin_2_bcd_test_data

test_p3:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal bin2aiken

move $a0, $v0        # hex to print
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p3
##############################################
##############################################
li $v0, 4
la $a0, new_line
syscall
test_file_read:
li $v0, 4
la $a0, new_line
syscall
li $s0, 0
li $v0, 4
la $a0, testing_label
syscall
la $a0, file_label
syscall 
jal file_read
end:
# end program
li $v0, 10
syscall
