#Juan Marquez
# This program will request input and save it in memory
# It will perform calculations with the input given
# and display the results to the user

.data 
a:	.word	0
b:	.word	0
c:	.word	0
ans1:	.word	0	
ans2:	.word	0
ans3:	.word	0
name:	.space	20
msg1:	.asciiz	"Please enter your name: "
msg2:	.asciiz	"Please enter an integer between 1-100: "
msg3:	.asciiz	"Your answers are: "

.text
main:
	#prompt user for name
	li 	$v0, 4
	la	$a0, msg1
	syscall
	
	#save the user name in memory
	li	$v0, 8
	la	$a0, name
	li	$a1, 20
	syscall

	#promp user for int value
	li 	$v0, 4
	la	$a0, msg2
	syscall
	
	#read and store value in a
	li	$v0, 5
	syscall
	sw 	$v0, a
	
	#promp user for int value
	li	$v0, 4
	la	$a0, msg2
	syscall
	
	#read and store value in b
	li 	$v0, 5
	syscall
	sw	$v0, b
	
	#promp user for int value
	li	$v0, 4
	la	$a0, msg2
	syscall
	
	#read and store value in c
	li	$v0, 5
	syscall
	sw	$v0, c

	#calculate ans1
	lw	$t1, a
	lw	$t2, b
	add 	$t1, $t1, $t1 # a+a for 2a
	sub	$t1, $t1, $t2 # 2a-b
	addi 	$t1, $t1, 9 # 2a-b+9
	sw	$t1, ans1
	
	#calculate ans2
	lw	$t1, a
	lw	$t2, b
	lw	$t3, c
	sub	$t3, $t3, $t2 # c-b
	subi	$t1, $t1, 5 #(a-5)
	add	$t3, $t3, $t1 # c-b+(a-5)
	sw	$t3, ans2
	
	#calculate ans3
	lw	$t1, a
	lw	$t2, b
	lw	$t3, c
	subi	$t1, $t1, 3 # (a-3)
	addi	$t2, $t2, 4 # (b+4)
	addi	$t3, $t3, 7 # (c+7)	
	add	$t1, $t1, $t2 # (a-3)+(b+4)
	sub	$t1, $t1, $t3 # (a-3)+(b+4)-(c+7)
	sw	$t1, ans3
	
	#print user name
	li	$v0, 4
	la	$a0, name
	syscall
	
	#print message for results
	li	$v0, 4
	la	$a0, msg3
	syscall
	
	#print the 3 results with a space character in between them
	li 	$v0, 1
	lw	$a0, ans1
	syscall
	li 	$v0, 11
	li 	$a0, 32
	syscall
	
	li 	$v0, 1
	lw	 $a0, ans2
	syscall
	li 	$v0, 11
	li 	$a0, 32
	syscall
	
	li 	$v0, 1
	lw 	$a0, ans3
	syscall

	
exit:	li	$v0, 10	
	syscall


# Test Values #1
# a = 80
# b = 50
# c = 20
# Expected ans1 = 119
# Expected ans2 = 45
# Expected ans3 = 104

# Sample run #1

# Please enter your name: Juan Marquez
# Please enter an integer between 1-100: 80
# Please enter an integer between 1-100: 50
# Please enter an integer between 1-100: 20
# Juan Marquez
# Your answers are: 119 45 104
# -- program is finished running --


# Test Values #2
# a = 33
# b = 66
# c = 99
# Expected ans1 = 9
# Expected ans2 = 61
# Expected ans3 = -6

# Sample run #2

# Please enter your name: Cristiano Ronaldo
# Please enter an integer between 1-100: 33
# Please enter an integer between 1-100: 66
# Please enter an integer between 1-100: 99
# Cristiano Ronaldo
# Your answers are: 9 61 -6
# -- program is finished running --
