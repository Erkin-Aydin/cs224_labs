#########################################################
####################### Circular Shift
#########################################################

#$s0 = address of the beginning of the array
#$s1 = word size of the created array

	.text		
.globl __start
 
__start:				# execution starts here
	jal createArray			#creating the array
	
	move $s0, $v0			#copying array address to $s0
	move $s1, $v1			#copying array word size to $s1
	
	beq $s1, $0, out
	
	addi $sp, $sp, -8 		
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	
	
	move $a0, $s0
	move $a1, $s1
	jal bubbleSort
	
out:	li $v0,10  			# system call to exit
	syscall				#bye bye
	
createArray:

	la $a0, prompt1			#asking for the size of the array
	li $v0, 4
	syscall
	
	li $v0, 5			#waiting for the input
	syscall
	
	move $v1, $v0			#since the size of the array will be returned, and since we won't use $v1 for the rest of the function, we can simply copy now.
	sll $t0, $v0, 2			#multiplying it with 4 for sufficient bit allocation
	
	move $a0, $t0			#making the allocation
	li $v0, 9
	syscall
	
	move $t0, $v0			#adresses of words of the array
	beq $v1, $0, done
	move $t1, $v1 			#word size of the array
					#Elements shall be entered by the user.
	
	addi $t3, $0, 0
repeat:	la $a0, prompt2			#repeatedly asking for array walues and copying input values to the array
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t2, $v0
	sw $t2, ($t0)
	addi $t0, $t0, 4
	addi $t3, $t3, 1
	bne $t3, $t1, repeat
	
	sll $t1, $t1, 2
	sub $t0, $t0, $t1
	
	move $v0, $t0			#$t0 = address of the array
	#move $v1, $t1 #unnecessary, thus commented.
	
done:	jr $ra
	
bubbleSort:
	move $t0, $a0			#address
	move $s2, $a1			#size
	addi $s2, $s2, -1
bRepeat:
	move $t1, $0
	beq $s2, $0, doneBubble
	
again:	bne $t4, $0, doneBubble
	addi $t4, $0, 1
	lw $s0, ($t0)	
	lw $s1, 4($t0)
	
	slt $t2, $s0, $s1
	bne $t2, $0, afterSwap
	
	#here, swap happens
	move $t2, $s0			#$t2 = first value
	move $t3, $s1			#$t3 = second value
	move $t4, $0
	
	sw $t2, 4($t0)
	sw $t3, ($t0)
	
afterSwap:
	addi $t0, $t0, 4
	addi $t1, $t1, 1
	slt $t2, $t1, $s2
	bne $t2, $0, again
	
	move $t0, $v0
	addi $s2, $s2, -1
	bne  $t1, $0, bRepeat
	
doneBubble:
	addi $sp, $sp, -4 		
	sw $ra, 4($sp)

	jal processSortedArray
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
processSortedArray:
	
	move $t0, $v0			#address, do touch this!
	move $s0, $v1			#size, don't touch this!
	move $t1, $0
	
	addi $sp, $sp, -4 		
	sw $ra, 4($sp) 				#since we will call sumDigits repeatedly, we have to store previous $ra in the stack
	
processAgain:
	lw $t2, ($t0)
	
	#print shit out here
	move $a0, $t1
	li $v0, 1
	syscall
	
	la $a0, prompt3
	li $v0, 4
	syscall
	
	move $a0, $t2
	li $v0, 1
	syscall
	
	#move $a0, $t2 #not necessary, as it was done in previous lines
	jal sumDigits
	
	move $s1, $v0
	
	la $a0, prompt3
	li $v0, 4
	syscall
	
	move $a0, $s1
	li $v0, 1
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	addi $t0, $t0, 4
	addi $t1, $t1, 1
	bne $t1, $s0, processAgain
	
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	jr $ra
	
sumDigits:
	addi $t2, $0, 10
	move $s3, $a0 	#the number
	move $s4, $0	#sum stored
	
sumDigitsAgain:

	div $s3, $t2
	mfhi $t3
	mflo $s3
	add $s4, $s4, $t3
	bne $s3, $0, sumDigitsAgain
	
	slt $s5, $s4, $0
	beq $s5, $0, sumDone
	
	mul $s4, $s4, -1
	
sumDone:
	move $v0, $s4
	jr $ra
	
#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
prompt1:	.asciiz "Enter the size of the array: "
prompt2:	.asciiz "Enter the value of the next element: "
prompt3:	.asciiz "         "
endl:		.asciiz "\n"

##
## end of lab2.asm
