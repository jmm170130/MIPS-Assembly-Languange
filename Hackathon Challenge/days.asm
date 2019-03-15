
###########################
# Hackaton Challenge
# Author: Juan Marquez
# Created: 3-13-2019
# This Program will display the number of days in a given month.
# It will give the user 2 options for displaying data
#	Option1: Print the month number and the number of days
#	Option2: Print the 3-character month abbreviation and number of days
###########################
.data
month:			.word		0
numberOfDays:		.word		0
selectedPrintingOption:  .word		0
requestMonthMessage:	.asciiz		"Please enter the month (1 - 12) , enter 0 to exit: "
errorMessage:		.asciiz		"Month must be between 1 and 12\n"
printMonthMessage:	.asciiz		"Number of days in month "
printDaysMessage: 	.asciiz		" is: "
newLine:			.asciiz		"\n"
welcomeMessage:		.asciiz		"Welcome to the month and days program.\n"
printingOptionsMessage:  .asciiz		"Press 1 for month number, 2 for month abbreviation: "
janMessage:		.asciiz		"Number of days in month Jan is: "
febMessage:		.asciiz		"Number of days in month Feb is: "
marMessage:		.asciiz		"Number of days in month Mar is: "
aprMessage:		.asciiz		"Number of days in month Apr is: "
mayMessage:		.asciiz		"Number of days in month May is: "
junMessage:		.asciiz		"Number of days in month Jun is: "
julMessage:		.asciiz		"Number of days in month Jul is: "
augMessage:		.asciiz		"Number of days in month Aug is: "
sepMessage:		.asciiz		"Number of days in month Sep is: "
octMessage:		.asciiz		"Number of days in month Oct is: "
novMessage:		.asciiz		"Number of days in month Nov is: "
decMessage:		.asciiz		"Number of days in month Dec is: "
.text
main:
	# Print welcome message
	li	$v0, 4
	la	$a0, welcomeMessage
	syscall
loop1:	
	# Give the user the options for printing
	li	$v0, 4
	la	$a0, printingOptionsMessage
	syscall
	
	# Save the users choice in memory
	li	$v0, 5
	syscall
	sw	$v0, selectedPrintingOption
	
	# validate printing option selected
	# keep user in a loop until they enter 1 or 2
	blt	$v0, 1, loop1
	bgt 	$v0, 2, loop1
loop2:	
	# Request user input for the month
	li 	$v0, 4
	la	$a0, requestMonthMessage
	syscall
	
	# save user input in memory
	li	$v0, 5
	syscall
	sw	$v0, month
	
	# exit if user input is 0
	beqz	$v0, exit
	
	# validate that input is between 1 and 12
	blt	$v0, 1, displayErrorMessage # if month < 1 branch
	bgt	$v0, 12, displayErrorMessage # if month > 12 branch

	# branch to function that determines the number of days
	lw	$a0, month  # copy the user input to argument
	jal	numberOfDaysInMonth
	sw	$v0, numberOfDays  #save the number of days in memory
	
	# branch to functon that Prints the month and number of days
	lw	$a0, selectedPrintingOption #copy the printing option selected to argument
	lw	$a1, month #copy month into argument
	j	printResults

exit:
	li	$v0, 10
	syscall

#function used to display error message for invalid input
displayErrorMessage:
	#display error message
	li	$v0, 4
	la	$a0, errorMessage
	syscall
	
	#jump back to main function to try again
	j	loop2
	
#function that determines the number of days in the given month
numberOfDaysInMonth:
	#following cases will have 30 days
	beq	$a0, 4, case1
	beq	$a0, 6, case1
	beq	$a0, 9, case1
	beq	$a0, 11, case1
	#following cases will have 31 days
	beq	$a0, 1, case2
	beq	$a0, 3, case2
	beq	$a0, 5, case2
	beq	$a0, 7, case2
	beq	$a0, 8, case2
	beq	$a0, 10, case2
	beq	$a0, 12, case2
	#following cases will have 28 days
	beq	$a0, 2, case3
# Case1 will return 30
case1:
	li	$v0, 30
	jr	$ra
	
# Case2 will return 31 
case2:
	li	$v0, 31
	jr	$ra

#case3 will return 28
case3:
	li	$v0, 28
	jr	$ra
	
# function that prints the results to the user depending on printing option selected
printResults:
	bne	$a0, 1, option2 # Brnach if option 2 was selected
	
	# Print the month number and days
	li	$v0, 4
	la	$a0, printMonthMessage
	syscall
	
	li	$v0, 1
	lw	$a0, month
	syscall
	
	li	$v0, 4
	la	$a0, printDaysMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	j	loop2	# repeat process until 0 is entered

# Print results using option 2
option2:
	# Print the 3-charcacter month abbreviation and days
	# Depending on the month selected
	bne	$a1, 1, february	#branch if not january
	li	$v0, 4
	la	$a0, janMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	j	loop2	# repeat process until 0 is entered
	
february:
	bne	$a1, 2, march #branch if not february
	li	$v0, 4
	la	$a0, febMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall

	j	loop2
	
march:	
	bne	$a1, 3, april	#branch if not march
	li	$v0, 4
	la	$a0, marMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	j	loop2

april:
	bne	$a1, 4, may	#branch if not april
	li	$v0, 4
	la	$a0, aprMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall

	j	loop2
may:
	bne	$a1, 5, june	#branch if not may
	li	$v0, 4
	la	$a0, mayMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	j	loop2
	
june:
	bne	$a1, 6, july	#branch if not june
	li	$v0, 4
	la	$a0, junMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall

	j	loop2	
july:
	bne	$a1, 7, august	#branch if not july
	li	$v0, 4
	la	$a0, julMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall

	j	loop2	
august:
	bne	$a1, 8, september	#branch if not august
	li	$v0, 4
	la	$a0, augMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall

	j	loop2	
september:
	bne	$a1, 9, october  	#branch if not september
	li	$v0, 4
	la	$a0, sepMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall

	j	loop2	
october:
	bne	$a1, 10, november	#branch if not october
	li	$v0, 4
	la	$a0, octMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall

	j	loop2	
november:
	bne	$a1, 11, december 	#branch if not november
	li	$v0, 4
	la	$a0, novMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	j	loop2
december:
	li	$v0, 4
	la	$a0, decMessage
	syscall
	
	li	$v0, 1
	lw	$a0, numberOfDays
	syscall
	
	li	$v0, 4
	la	$a0, newLine
	syscall
	
	j	loop2
	
	
