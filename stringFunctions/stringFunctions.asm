###########################
# Author: Juan Marquez
# Created: 2-7-2019
# This program will use dialog syscall(#58) to request input from the user
# The program will then count the number of characters and number of words in the given input
# It will then display the data to the user on the console
# This will repeat until user exits the program
###########################

.data
enterTextMsg:	.asciiz		"Please enter some text:"
goodbyeMsg:	.asciiz		"Goodbye"
wordsMsg:	.asciiz		" words "
charMsg:		.asciiz		" characters"
newline:		.asciiz		"\n\n"
input:		.space		250
wordCount:	.word		0
charCount:	.word		0

.text
	
loop:	
	
	# Request input using dialog syscall
	li	$v0, 54
	la	$a0, enterTextMsg
	la	$a1, input
	li	$a2, 250
	syscall

	# if cancel was chosen exit program
	beq	$a1, -2, exit
	# if an empty string is entered exit program
	beq	$a1, -3, exit
	
	# call function to evaluate the string
	jal	evaluateString
	
	# store the number of character in memory
	sw	$v0, charCount
	# store the number of words in memory
	sw	$v1, wordCount
	
	# output the string
	li	$v0, 4
	la	$a0, input
	syscall
	
	# output the number of words in the string
	li	$v0, 1
	lw	$a0, wordCount
	syscall
	li	$v0, 4
	la	$a0, wordsMsg
	syscall
	
	# output the number of characters in the string
	li	$v0, 1
	lw	$a0, charCount
	syscall
	li	$v0, 4
	la	$a0, charMsg
	syscall	
	
	#print newline
	li	$v0, 4
	la	$a0, newline
	syscall	
		
	# repeat loop
	beq	$zero, $zero, loop	


exit:	
	# output dialog message to say goodbye
	li	$v0, 59
	la	$a0, goodbyeMsg
	syscall
	
	# terminate program
	li	$v0, 10
	syscall
	
# This	function counts the number of character and words in a string
evaluateString:
	
	#save register in stack
	addi	$sp, $sp, -4
	sw	$s1, ($sp)

	li	$t0, 0 		# Character count 
	li	$t1, 1 		# word count
	la	$s1, input 	# Adress of the input string
	
charCountLoop:	
	lb	$t2, ($s1)	 
	beq	$t2, '\0', done	# Exit if end of string
	beq	$t2, '\n', done  # Exit if end of string
	addi	$s1, $s1, 1      # increment position in string
	addi	$t0, $t0, 1	# increment character count
	beq	$t2, ' ' , wordCountLoop	#increment word count if space char
	j	charCountLoop
	

wordCountLoop:
	beq	$t0, 1, specialCase  #if string starts with space char jump to specialCase
	addi	$t1, $t1, 1	#increment word count
	j 	charCountLoop
	
specialCase:
	li	$t1, 0		# set word count to 0 if first character is a space char 
	j	charCountLoop
	
done:
	# Return character and word count
	move	$v0, $t0
	move	$v1, $t1
	
	#restore register
	lw	$s1, ($sp)
	addi	$sp, $sp, 4
	
	#exit function
	jr	$ra
	
