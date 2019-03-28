###########################
# hw6.asm
# Author: Juan Marquez
# Created: 3-20-2019
# This Program will
#    - read the input file “input.txt” into a buffer in memory
#    - extract the string “numbers”, convert them to integers and store in an array
#    - print the integers to console
#    - sort the integers in place using selection sort
#    - print the sorted integers to console
#    - calculate the mean, median, and standard deviation, printing results to the console
###########################
.data
			.align		2
buffer:			.space		80	
			.align		2
array:			.space		80
median:			.word		0
medianSP:		.float		0.0
mean:			.float		0.0
standardDeviation:	.float		0.0
fileName:		.asciiz		"input.txt"
couldNotReadMessage:	.asciiz		"Could Not Read From File"
couldNotOpenMessage:	.asciiz		"Could Not Open File"
arrayBeforeMessage:	.asciiz		"The array Before Sorting: "
arrayAfterMessage:	.asciiz		"\nThe array After Sorting: "
meanMessage:		.asciiz		"\nThe mean is: "
medianMessage:		.asciiz		"\nThe median is: "
standardDeviationMsg:	.asciiz		"\nThe standard deviation is: "
space:			.asciiz		" "
arrayLength:		.word		0

.text
main:
	# Call Function to read the file
	la	$a0, fileName 	
	la	$a1, buffer
	jal	readFile

	# Outout error message and terminate if $v0 <= 0
	# else continue extracting integers from the input buffer
	bgt	$v0, 0, extractInt 	
	li	$v0, 4
	la	$a0, couldNotReadMessage
	syscall
	j 	exit
	
extractInt:
	# Call Function to extract integers from the input buffer
	la	$a0, array
	li	$a1, 20
	la	$a2, buffer
	jal	extractIntegers
	sw	$v1, arrayLength
	
	# Print the array before sorting
	li	$v0, 4
	la	$a0, arrayBeforeMessage
	syscall
	
	# Call Function to print the array
	lw	$a1, arrayLength
	la	$a2, array
	jal	printArray
	
	# Call Function to sort the array
	la	$a0, array
	lw	$a1, arrayLength
	jal	sortArray
	
	# Print the array after sorting
	li	$v0, 4
	la	$a0, arrayAfterMessage
	syscall
	
	#call Function to print the array
	lw	$a1, arrayLength
	la	$a2, array
	jal	printArray
	
	# Call Function to calculate the mean
	la	$a0, array
	lw	$a1, arrayLength
	jal	computeMean
	# store the mean in memory as a float
	s.s	$f3, mean
	
	# Print the mean to the user
	li	$v0, 4
	la	$a0, meanMessage
	syscall
		
	li	$v0, 2
	l.s	$f12, mean
	syscall
	
	# call Function to calculate the median
	la	$a0, array
	lw	$a1, arrayLength
	jal	computeMedian
	sw	$v0, median
	
	# Print the message for median
	li	$v0, 4
	la	$a0, medianMessage
	syscall
	
	# Print median as int if $v1 == 1 ( odd array length )
	beq	$v1, 12, printMedianAsFloat # Branch if flag == 12
	li	$v0, 1
	lw	$a0, median
	syscall
	j	continue
	
printMedianAsFloat:
	# Print median as a float
	s.s	$f3, medianSP
	li	$v0, 2
	l.s	$f12, medianSP
	syscall
	
continue:

	# Call function to calculate the standard deviation
	la	$a0, array
	lw	$a1, arrayLength
	l.s	$f0, mean
	jal	computeStandardDeviation
	s.s	$f5, standardDeviation
	
	# Print Message for the Standard deviation
	li	$v0, 4
	la	$a0, standardDeviationMsg
	syscall
	
	# Print the standard deviation
	li	$v0, 2
	l.s	$f12, standardDeviation
	syscall
	
exit:
	li	$v0, 10
	syscall
	
# Function to read text from the input file
# $a0 equal to address of the filename
# $a1 holds adress of the buffer
readFile:
  	addi 	$sp, $sp, -4      # make space on stack
   	sw 	$ra, 0($sp)       # save return address on stack
	move	$t0, $a1
	
	# Open the file
	li	$v0, 13
	add	$a0, $a0, 0
	li	$a1, 0
	li	$a2, 0
	syscall
	move	$t1, $v0
	
	# Error message if file did not open
	# else continue reading from the file
	bge	$v0, 0, continueReading
	li	$v0, 4
	la	$a0, couldNotOpenMessage
	syscall
	j 	exit
	
continueReading:
	# read from the file
	li	$v0, 14
	move	$a0, $t1
	move	$a1, $t0
	li	$a2, 80
	syscall
	move	$t3, $v0
	
	#close the file
	li	$v0, 16
	move	$a0, $a0
	syscall
	
	#return number of bytes read
   	lw 	$ra, 0($sp)       #  Get the return adress from the stack
   	addi 	$sp, $sp, 4     # Clear the stack
	move	$v0, $t3
	jr	$ra

# This function will extract integers from the input buffer
# and store them in an array of 20 words
# $a0 holds the adress of the array
# $a1 holds array size of 20
# $a2 holds the address of the buffer
extractIntegers:
   	addi	$sp, $sp, -4   # Make space on the stack
   	sw	$ra, 0($sp)    # Save the return adress on the stack
	li	$t4, 0	 # counter ( n )
loop:	
	# Go back to main if array is full !(n < arrayLength)
	# Else continue loading byte
	beq	$t4, $a1, return
	
	# Load the byte from the buffer
	lb	$t0, ($a2)
	li	$t3, 0 		#accumulator
	
	# Go back to main if end of data is reached
	# Else continue validating that the byte is a number
	beq	$t0, 0, return 
	
	# Ignore byte if is not a digit
	blt	$t0, 48, nextByte
	bgt	$t0, 57, nextByte
	
	# Convert from ASCII to int
	addi	$t0, $t0, -48
	add	$t3, $t3, $t0 # add to the Accumulator
	addi	$a2, $a2, 1   # Increment position on buffer
	lb	$t0, ($a2)    # Load new byte

# Continue reading from buffer until newLine is found
newLine:
	beq	$t0, 10, addToArray  # If newline is found save integer to the array
	beq	$t0, 0,	addToArray   # If end of data is reached add integer to the array
	blt	$t0, 48, ignoreByte
	bgt	$t0, 57, ignoreByte
	addi	$t0, $t0, -48
	addi	$a2, $a2, 1	# Increment position on buffer
	mul	$t3, $t3, 10	# multiply accumulator by 10
	add	$t3, $t3, $t0	# add new digit to accumulator
	lb	$t0, ($a2)	# Load new byte from buffer
	j 	newLine		# Check for newLine

#ignoreByte used in newLine loop
ignoreByte:
	addi	$a2, $a2, 1	# Increment position in the buffer
	lb	$t0, ($a2)	# load byte
	j 	newLine
	
# Save the integer in array
addToArray:
	addi	$t4, $t4, 1	# Increment counter
	sw	$t3, ($a0)	# Save integer in the array
	beq	$t0, 0, return	# If end of file go back to main method
	addi	$a0, $a0, 4	# Increment array position
	addi	$a2, $a2, 1	# Increment buffer position
	j 	loop
		
nextByte:
	# move position in the buffer
	addi	$a2, $a2, 1
	j	loop
	
return:
	move	$v1, $t4		# Return the number of element in the array
	lw 	$ra, 0($sp)       #  Get the return adress from the stack
   	addi	$sp, $sp, 4     # Clear the stack
   	jr	$ra
	
# This function will print the array elements
# $a1 holds size of array
# $a2 hold address of the array
printArray:
   	addi 	$sp, $sp, -4     # Make space on the stack
  	sw 	$ra, 0($sp)       #  Save the return adress on the stack
	li	$t0, 0	    # counter ( n )
printElement:
	# Return to main if we are done printing the array
	# Else continue printing the element
	beq	$t0, $a1 , return2 # If n == arrayLength return to main 
	
	# Print the element and add a space after
	li 	$v0,1
	lw 	$a0,0($a2)
	syscall
	li	$v0, 4
	la	$a0, space
	syscall
	
	addi	$a2, $a2, 4	# Increment array Position
	addi	$t0, $t0, 1	# Increment Counter( n )
	j	printElement
return2:
	lw 	$ra, 0($sp)       #  Get the return adress from the stack
   	addi 	$sp, $sp, 4     # Clear the stack
   	jr	$ra
	

# This function will sort the array by a selection sort
# $a0 holds the adress of the array
# $a1 holds arrayLength ( n )
sortArray:
	addi	$sp, $sp, -4      # make space on stack
	sw 	$ra, 0($sp)         # save return address on stack

	move	$t0, $zero        #  $t0 = j = 0
	addi 	$t1, $a1, -1       # $t1 = n - 1

outerForLoop:
	beq 	$t0, $t1, return3     # if(j == n - 1) we are finished return to main

	move 	$t2, $t0        # $t2 = iMin = j
	addi 	$t3, $t0, 1    # $t3 = i = j + 1

innerForLoop: 
	beq 	$t3, $a1, swap      # if (i == n) branch out of innerForLoop 

# if (a[i] < a[iMin] )
compareToMin: 
	# get value at a[i]
	sll 	$t4, $t3, 2         # offset = i * 4
	add	$t4, $t4, $a0       # add offset to base address
	lw 	$t5, 0($t4)          # store value at i in $t5

	# get value at a[iMin]
	sll 	$t6, $t2, 2         # offset = iMin * 4
	add 	$t6, $t6, $a0       # add offset to base address
	lw 	$t7, 0($t6)          # store value at iMin in $t7

	# if (a[i] < a[iMin] continue else loop innerForLoop again
	bge 	$t5, $t7, iterateInnerLoop
	move 	$t2, $t3     # iMin = i

iterateInnerLoop:
	addi 	$t3, $t3, 1   # Increment i
	j 	innerForLoop

#if (iMin != j)
swap: 
	# if(iMin == j) iterate outerForLoop
	# Else if iMin changed then swap the values
	beq 	$t2, $t0,iterateOuterLoop 
   
	# swap(a[i], a[iMin]) using temp variable
	# Get value at a[iMin]
	sll 	$t6, $t2, 2         # offset = iMin * 4
	add 	$t6, $t6, $a0       # add offset to base address
	lw	$t8, 0($t6)          # $t8 = tmp = a[iMin]

	# Get value at a[j]
	sll	$t4, $t0, 2         # offset = j * 4
	add	$t4, $t4, $a0       # add offset to base address
	lw 	$t9, 0($t4)          # $t9 = a[j]
    
	# a[iMin] = a[j]
	sw	$t9, 0($t6)     

	# a[j] = tmp
	sw 	$t8, 0($t4)            
iterateOuterLoop:
	addi 	$t0, $t0, 1        # increment j
	j 	outerForLoop 

return3:
	lw	$ra, 0($sp)  # make space in the stack
	addi 	$sp, $sp, 4  # Save return adress on the stack
	jr 	$ra   
    
# This function will calculate the mean
# $a0 holds the start of the array
# $a1 holds the array length
computeMean:
	addi	$sp, $sp, -4     
	sw	$ra, 0($sp)
	li	$t0, 0	# counter (n)
	li	$t1, 0	# total sum
	    
# Add all elements in the array while n < arrayLength
whileLoop:
	beq	$t0, $a1, divide	# if(n == arrayLength) branch out of loop
	lw	$t2, 0($a0)
	add	$t1, $t1, $t2
	addi	$a0, $a0, 4	# move to next array element
	addi	$t0, $t0, 1 	# Increment counter
	j	whileLoop
	
# Divide total sum by total elements in array
# mean = totalSum / $a1 == arrayLength
divide:
	mtc1	$a1, $f0   # Array Length
	cvt.s.w	$f0, $f0
	mtc1	$t1, $f2   # totalSum
	cvt.s.w	$f2, $f2
	
	# mean = totalSum / arrayLength
	div.s	$f3, $f2, $f0
	
	lw	$ra, 0($sp)  # get the return adress from the stack
	addi	$sp, $sp, 4     # clear the stack
	jr	$ra
	
# This function will calculate the Median
# $a0 holds the start of the array
# $a1 holds the array length
computeMedian:
	addi	$sp, $sp, -4   
	sw	$ra, 0($sp)
	
	li	$t5, 2
	# Figure out if length of the array is odd or even
	div	$a1, $t5
	mfhi	$t1	# put remainder in $t1
	mflo	$t2
	
	# If $t1 == 1 it is odd and will return an int value
	beq	$t1, 1, odd  # Branch if it has a remainder

	# Find middle values
	sll	$t2, $t2, 2
	addi	$t3, $t2, -4

	# Get upper Value
	add	$t4, $t2, $a0
	lw	$t5, 0($t4)
	
	# Get lower value
	add	$t3, $t3, $a0
	lw	$t6, 0($t3)
	
	# find and return the median of the two values
	li	$t7, 2
	add	$t6, $t6, $t5
	mtc1	$t6, $f0    # $f0 = sum
	cvt.s.w	$f0, $f0
	mtc1	$t7, $f1    # $f1 = 2
	cvt.s.w	$f1, $f1
	div.s	$f3, $f0, $f1 # sum/2
	
	li	$v1, 12   # set flag to indicate result will be a float
	j	exit4
	
odd:
	li	$v1, 1   # set flag to indicate result will be an int
	
	# Find middle value
	sll	$t3, $t2, 2
	add	$t3, $t3, $a0
	lw	$v0, 0($t3)
	
exit4:
	lw	$ra, 0($sp)  # get the return adress from the stack
	addi	$sp, $sp, 4     # clear the stack
	jr	$ra

# This function will compute the standard deviation
# $a0 holds the start of the array
# $a1 holds the array length
# $f0 holds the mean (average)
computeStandardDeviation:
	addi	$sp, $sp, -4     # make space in the stack
	sw	$ra, 0($sp)  # save the return adress on the stack
	li	$t0, 0	   # Counter
	li	$t3, 0
	mtc1	$t3, $f1    # Sum
	cvt.s.w	$f1, $f1
	
# Loop for all elements in the array
loop2:
	# Get the actual value	
	sll	$t1, $t0, 2
	add	$t1, $t1, $a0
	lw	$t2, 0($t1)
	mtc1	$t2, $f2
	cvt.s.w	$f2, $f2
	
	# difference from actual - average
	sub.s	$f3, $f2, $f0
	abs.s	$f3, $f3
	
	# Square the difference
	mul.s	$f3, $f3, $f3
	
	# Add it to the sum
	add.s	$f1, $f1, $f3
	addi	$t0, $t0, 1
	blt	$t0, $a1, loop2

	# Set arrayLength - 1
	li	$t1, 1
	mtc1	$t1, $f5
	cvt.s.w	$f5, $f5
	mtc1	$a1, $f4
	cvt.s.w	$f4, $f4
	sub.s	$f4, $f4, $f5 
	
	# Now divie by arrayLength - 1
	div.s	$f5, $f1, $f4
	
	# Now get the square root
	sqrt.s 	$f5, $f5
	
	lw	$ra, 0($sp)  # get the return adress from the stack
	addi	$sp, $sp, 4     # clear the stack
	jr	$ra
