###########################
# Author: Juan Marquez
# Created: 2-26-2019
# This Program will request the users height and weight 
# Then it will calculate and display their bmi (as a double)
# It will also diplay a specific message depending on their bmi
###########################
.data
enterNameMsg:		.asciiz		"Please enter your name: "
enterHeightMsg:		.asciiz		"Please enter your height in inches: "
enterWeightMsg:		.asciiz		"Please enter your weight in pounds (round to a whole number): "
resultMsg:		.asciiz		", your bmi is: "
underWeightMsg:		.asciiz		"\nThis is considered underWeight. "
normalWeightMsg:		.asciiz		"\nThis is a normal weight "
overWeightMsg:		.asciiz		"\nThis is considered overweight. "
obeseMsg:		.asciiz		"\nThis is considered obese. "
userName:		.space		50
height:			.word		0
weight:			.word		0
underWeightConst:	.double		18.5
normalWeightConst:	.double		25.0
overWeightConst:		.double		30.0
bmi:			.double		0

.text
main:
	# Request name from user
	li	$v0, 4
	la	$a0, enterNameMsg
	syscall
	
	# Save the user name in memory
	li	$v0, 8
	la	$a0, userName
	li	$a1, 50
	syscall

	# Request height in inches
	li	$v0, 4
	la	$a0, enterHeightMsg
	syscall
	
	# Store height in memory
	li	$v0, 5
	syscall
	sw	$v0, height
	
	# Request weight in pounds
	li	$v0, 4
	la	$a0, enterWeightMsg
	syscall
	
	# Store weight in memory
	li	$v0, 5
	syscall
	sw	$v0, weight
	
	# Calculate the bmi
	lw	$t0, weight
	mul	$t0, $t0, 703  # weight *= 703
	sw	$t0, weight
	
	lw	$t1, height
	mul	$t1, $t1, $t1 # height *= height
	sw	$t1, height
	
	mtc1.d	$t0, $f0
	cvt.d.w 	$f0, $f0
	
	mtc1.d	$t1, $f2
	cvt.d.w 	$f2, $f2
	
	div.d	$f4, $f0, $f2    # weight/ height
	s.d	$f4, bmi		# bmi = weight/ height
	
	# Replace the newLine character in userName
	li	$t3, 0  # index set to 0
loop:
	lb	$t4, userName($t3)
	addi	$t3, $t3, 1
	bnez	$t4, loop   	# Loop until the end of the string is reached
	beq	$a1, $t3, break	# Do nothing if the string is of max length(50 characters)
	subiu	$t3, $t3, 2	# If string is not max length find \n in string
	sb	$zero, userName($t3)	#replace \n with null terminator

break:
	# Output the results
	li	$v0, 4
	la	$a0, userName
	syscall

	li	$v0, 4
	la	$a0, resultMsg
	syscall
	
	li	$v0, 3
	l.d	$f12, bmi
	syscall
	
	#output the correct message depending on the bmi
	
	# if Underweight
	l.d	$f6, underWeightConst
	c.lt.d	$f12, $f6	# Compare the bmi to the under Weight Const(18.5)
	bc1f	normalW		# Branch if not underWeight
	li	$v0, 4
	la	$a0, underWeightMsg
	syscall
	j 	exit
	
normalW:	
	# else if Normal weight
	l.d 	$f6, normalWeightConst
	c.lt.d	$f12, $f6	# Compare the bmi to the normal Weight Const(25)
	bc1f	overW		# Branch if not normal weight
	li	$v0, 4
	la	$a0, normalWeightMsg
	syscall
	j 	exit
	
overW:	
	# else if Over weight
	l.d 	$f6, overWeightConst
	c.lt.d	$f12, $f6	# Comapare the bmi to the over Weight Const(30)
	bc1f	obese		# branch if not overWeight
	li	$v0, 4
	la	$a0, overWeightMsg
	syscall
	j 	exit
	
obese:
	# else Obese
	li	$v0, 4
	la	$a0, obeseMsg
	syscall
	
exit:
	li	$v0, 10
	syscall
