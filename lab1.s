#                                           CS 240, Lab #1
#
#                                          IMPORTATNT NOTES:
#
#                       Write your assembly code only in the marked blocks.
#
#                       DO NOT change anything outside the marked blocks.
#
#
j main
###############################################################################
#                           Data Section
.data
#
# Fill in your name, student ID in the designated sections.
#
student_name: .asciiz "Nick Ingargiola"
student_id: .asciiz "827476189"

new_line: .asciiz "\n"
space: .asciiz " "


t1_str: .asciiz "Testing Arithmetic Expression: \n"
t2_str: .asciiz "Testing Total Surface Area of rectangular box: \n"
t3_str: .asciiz "Testing Random Sum: \n"

po_str: .asciiz "Obtained output: "
eo_str: .asciiz "Expected output: "

Arith_test_data_A:    .word 2, 1, -2, 2, 0
Arith_test_data_B:    .word 4, 2, -4, 4, 0
Arith_test_data_C:    .word 6, 3, -6, 6, -1
Arith_test_data_D:    .word 5,10, 5, 7, 0

Arith_output:           .word 7, -4, -17, 5, -1


Rect_test_data_A:    .word 5, 10, 2, 18, 2
Rect_test_data_B:    .word 4, 10, 4, 14, 74
Rect_test_data_C:    .word 3, 10, 6, 1, 7

Rect_output:           .word 94, 600, 88, 568, 1360

RANDOM_test_data_A:    .word 1, 144, -42, 260, -12
RANDOM_test_data_B:    .word 5, 108, 54, 210, -15
RANDOM_test_data_C:    .word 7, 109, 36, 360, -20

RANDOM_output:        .word 8, 252, 12, 570, -32

output_1:              .space 5
###############################################################################
#                           Text Section
.text
# Utility function to print an array
print_array:
li $t1, 0
move $t2, $a0
print:

lw $a0, ($t2)
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra
###############################################################################
###############################################################################
#                           PART 1 (Arithmetic expression )
#$t0 is A
#$t1 is B
#$t2 is C
#$t3 is D
#$t4 is Z
# Solve for Z= A+B+C-D
# Make sure your final answer is in register $t4.
.globl Arith
Arith:
move $t0, $a0
move $t1, $a1
move $t2, $a2
move $t3, $a3
############################### Part 1: your code begins here ################
add $t0, $t0, $t1    # Add A + B
add $t0, $t0, $t2    # Add (A + B) + C
sub $t4, $t0, $t3    # Sub (A + B + C) - D, Stored in $t4

############################### Part 1: your code ends here  ##################
add $v0, $t4, $zero
jr $ra
###############################################################################
###############################################################################
#                           PART 2 (Total Surface Area of Rectangle Box)

# Load the values of height, width and length from memory
# Find the Total Surface Area of the rectangular box and store back in memory

## Implementation details:
# The memory address are preloaded for you in registers $s2, $s3, $s4 and $s5.
# $s2 = address of length
# $s3 = address of width
# $s4 = address of height
# store the final answer in memory address $s5.

# IMPORTANT: DO NOT CHANGE VALUES IN $s registers!!!! You will break the code.
.globl rectangle
rectangle:
############################### Part 2: your code begins here ################
lw $t2, 0($s2)
lw $t3, 0($s3)    #Load information from memory
lw $t4, 0($s4)

mult $t2, $t3
mflo $t0

mult $t2, $t4     # ((L*W), (L*H), (W*H))
mflo $t1

mult $t3, $t4
mflo $t5

add $t2, $t0, $t1 # ((L*W) + (L*H))
add $t2, $t2, $t5 # ((L*W) + (L*H)) + (W*H)

addi $t3, $zero, 2
mult $t2, $t3     # Multiplying by 2
mflo $t6

sw $t6, 0($s5)    # Storing in desired memory address


############################### Part 2: your code ends here  ##################
jr $ra
###############################################################################
#                           PART 3 (Random SUM)

# You are given three integers. You need to find the smallest
# one and the largest one.
#
#
# Return the sum of Smallest and largest
#
# Implementation details:
# The three integers are stored in registers $t0, $t1, and $t2.
# Store the answer into register $t9.
# You are allowed to use only the $t registers.

.globl random_sum
random_sum:
move $t0, $a0
move $t1, $a1
move $t2, $a2
############################### Part 3: your code begins here ################
li $t9, 0       #loads value of 0 into $t9

bgt $t0, $t1, zeroLarge       # if $t0 > $t1 jump to zeroLarge else oneLarge
j oneLarge

zeroLarge:
bgt $t0, $t2, zeroLargest     # if $t0 > $t2 jump to zeroLargest else twoLargest
j twoLargest

oneLarge:
bgt $t1, $t2, oneLargest      # if $t1 > $t2 jump to oneLargest else twoLargest
j twoLargest

zeroLargest:
add $t9, $t9, $t0             # $t9 + $t0
j smallestCheck

oneLargest:
add $t9, $t9, $t1             # $t9 + $t1
j smallestCheck

twoLargest:
add $t9, $t9, $t2             # $t9 + $t2
j smallestCheck

smallestCheck:
blt $t0, $t1, zeroSmall       # if $t0 < $t1 jump to zeroSmall else oneSmall
j oneSmall

zeroSmall:
blt $t0, $t2, zeroSmallest    # if $t0 < $t2 jump to zeroSmallest else twoSmallest
j twoSmallest

oneSmall:
blt $t1, $t2, oneSmallest     # if $t1 < $t2 jump to oneSmallest else twoSmallest
j twoSmallest

zeroSmallest:
add $t9, $t9, $t0             # $t9 + $t0
j done

oneSmallest:
add $t9, $t9, $t1             # $t9 + $t1
j done

twoSmallest:
add $t9, $t9, $t2             # $t9 + $t2

done:





############################### Part 3: your code ends here  ##################
add $v0, $t9, $zero
jr $ra
###############################################################################

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
###############################################################################
#                          TESTING PART 1 - Arithmetic
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t1_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, Arith_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0

#j skip_line
##############################################
test_arith:
la $s2, Arith_test_data_A
la $s3, Arith_test_data_B
la $s4, Arith_test_data_C
la $s5, Arith_test_data_D
add $s2, $s2, $s1
add $s3, $s3, $s1
add $s4, $s4, $s1
add $s5, $s5, $s1
# Pass input parameter
lw $a0, 0($s2)
lw $a1, 0($s3)
lw $a2, 0($s4)
lw $a3, 0($s5)
jal Arith

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_arith

###############################################################################
#                          TESTING PART 2 - Area of Rectangular box
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t2_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, Rect_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0

#j skip_line
##############################################
test_lcm:
la $s2, Rect_test_data_A
la $s3, Rect_test_data_B
la $s4, Rect_test_data_C
la $s5, output_1
add $s2, $s2, $s1
add $s3, $s3, $s1
add $s4, $s4, $s1
add $s5, $s5, $s1
# Pass input parameter
#lw $a0, 0($s4)
#lw $a1, 0($s5)
jal rectangle

lw $a0, 0($s5)
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_lcm

###############################################################################
#                          TESTING PART 3 - RANDOM SUM
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, t3_str
syscall

li $v0, 4
la $a0, eo_str
syscall

li $v0, 4
la $a0, new_line
syscall

li $s0, 5 # num tests
la $s2, RANDOM_output
move $a0, $s2
move $a1, $s0
jal print_array

li $v0, 4
la $a0, new_line
syscall


li $v0, 4
la $a0, po_str
syscall

li $v0, 4
la $a0, new_line
syscall


#test_GCD:
li $s0, 5 # num tests
li $s1, 0

#j skip_line
##############################################
test_random:
la $s2, RANDOM_test_data_A
la $s3, RANDOM_test_data_B
la $s4, RANDOM_test_data_C
add $s2, $s2, $s1
add $s3, $s3, $s1
add $s4, $s4, $s1
# Pass input parameter
lw $a0, 0($s2)
lw $a1, 0($s3)
lw $a2, 0($s4)
jal random_sum

move $a0, $v0
li $v0,1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_random
###############################################################################
_end:
# new line
li $v0, 4
la $a0, new_line
syscall
# end program
li $v0, 10
syscall
###############################################################################
