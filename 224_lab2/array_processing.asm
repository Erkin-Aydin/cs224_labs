#########################################################
####################### Circular Shift
#########################################################

#$s0 = address of the beginning of the array
#$s1 = word size of the created array
#$t0 = addresses of elements of the created array
#$t1 = to keep track of min, max, sum values + 1 if it is palindrome so far, 
# 0 the moment is stops being palindrome
#$t2 = see+ index(?) of the last element==> this will be used in palindrome
#$t3 = to keep track of whether we reached to the end of the array or not
#$t4 = current element value on the iteration of the array
#$t5 = slt operation results

	.text		
.globl __start
 
__start:				# execution starts here
	jal createArray			#creating the array
	
	move $s0, $v0			#copying array address to $s0
	move $s1, $v1			#copying array word size to $s1
	
	move $a0, $s0
	move $a1, $s1			#passing array address and size as arguments to the function
	jal arrayOperations		#calling arrayOperations function
	
	li $v0,10  			# system call to exit
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
repeat:	la $a0, prompt6			#repeatedly asking for array walues and copying input values to the array
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
	
	move $v0, $t0
	#move $v1, $t1 #unnecessary, thus commented.
	
done:	jr $ra
	
arrayOperations:
	
	move $s0, $a0 			#from now on, $s0 is fixed to the beginning of the array
	
	la $a0, prompt2
	li $v0, 4
	syscall
	
	addi $sp, $sp, -4 		# since we consecutively call min, max, sum and palindrome, only
	sw $ra, 4($sp)	  		# after palindrome the stack will be deallocated. Thus, this code segment will not be seen before each operation
	
	move $a0, $s0
	jal min
	
	bne $a1, $0, minla		#if the size of the array is nonzero, we shall branch to minla and print the value returned as integer.
	move $a0, $v0			#if the size of the array is 0, then the $v0 shall include the address of prompt9, thus printing it as a string is sensible.
	li $v0, 4
	syscall
	
	j maxp				#"preperation for max" call
	
minla:	move $a0, $v0			#printing the integer value returned from function min
	li $v0, 1
	syscall
	
maxp:	la $a0, endl			#to the next line we go
	li $v0, 4
	syscall
	
	la $a0, prompt3			#printing "Maximum of the array: "
	li $v0, 4
	syscall
	
	move $a0, $s0
	jal max				#calling max function
	
	bne $a1, $0, maxla		#see comments on 91th and 92th lines, same situation applies here. 
	move $a0, $v0
	li $v0, 4
	syscall
	
	j sump				#"preperation for sum" call
	
maxla:	move $a0, $v0			#printing the inteer value returned from function max
	li $v0, 1
	syscall
	
	
sump:	la $a0, endl			#to the next line we go
	li $v0, 4
	syscall
	
	la $a0, prompt4			#printing "Sum of elements of the array:"
	li $v0, 4
	syscall
	
	move $a0, $s0
	jal sum				#calling function sum
	
	move $a0, $v0
	li $v0, 1
	syscall				#printing the integer value returned by the function sum
	
	la $a0, endl			#to the next line we go
	li $v0, 4
	syscall
	
	la $a0, prompt5			#printing "Is it palindrome(1 if it is, 0 if it is not): "
	li $v0, 4
	syscall
	
	move $a0, $s0
	jal palindrome
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	lw $ra, 4($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
min:
	move $t0, $a0
	move $t1, $a1 #size of the array
	
	bne $t1, $0, c1
	la $t2, prompt7
	j mine
	
c1:	addi $t3, $0, 0
	addi $t2, $0, 0x7fffffff 	#setting $t2 to the maximum possible value in 32 bits
	#start of the loop
minl:	lw $t4, ($t0)
	slt $t5, $t4, $t2
	beq $t5, $0, no1
	move $t2, $t4
no1:	addi $t0, $t0, 4
	addi $t3, $t3, 1
	bne $t3, $t1, minl
	
mine:	move $v0, $t2
	jr $ra
	
	
max:
	move $t0, $a0
	move $t1, $a1
	
	bne $t1, $0, c2
	la $t2, prompt7
	j maxe
	
c2:	addi $t3, $0, 0
	addi $t2, $0, 0x80000000 	#setting $t2 to the minimum possible value in 32 bits
	#start of the loop
maxl:	lw $t4, ($t0)
	slt $t5, $t2, $t4
	beq $t5, $0, no2
	move $t2, $t4
no2:	addi $t0, $t0, 4
	addi $t3, $t3, 1
	bne $t3, $t1, maxl
	
maxe:	move $v0, $t2
	jr $ra
	
	
sum:
	move $t0, $a0
	move $t1, $a1
	
	bne $a1, $0, sumn
	move $t3, $0
	j sumdone
	
sumn:	addi $t2, $0, 0 		#to iterate over the array
	addi $t3, $0, 0 		#sum
	#start of the loop
suml:	lw $t4, ($t0)
	add $t3, $t3, $t4
	addi $t0, $t0, 4
	addi $t2, $t2, 1
	bne $t2, $t1, suml

sumdone:
	move $v0, $t3
	jr $ra

palindrome:
	move $t0, $a0
	move $t1, $a1
	
	addi $t3, $0, 1 		#will indicate whether it is palindrome or not
					#if it is palindrome, $t3 = 1, 0 else.
	beq $t1, $0, palindone
	beq $t1, $t3, palindone 	#since $t3 = 1 for sure at this point, we can just use it
	sll $t2, $t1, 2   		#$t1 * 4 bit distance
	addi $t2, $t2, -4
	add $t2, $t0, $t2 		#$t2 will be used as the second pointer to iterate over the array
	#loop starts here
palinl:
	lw $t4, ($t0) 			#from the beginning
	lw $t5, ($t2) 			#from the end
	beq $t4, $t5, yes
	addi $t3, $0, 0
	j palindone
	
yes:	
	addi $t0, $t0, 4
	addi $t2, $t2, -4
	slt $t6, $t0, $t2 		#$t6 = 1 if iteration is not finished.
	bne $t6, $0, palinl 		#if $t6 = 0, then
	
palindone:
	move $v0, $t3
	jr $ra
	
	
#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
prompt1:	.asciiz "Enter the size of the array: "
prompt2:	.asciiz "Minimum of the array: "
prompt3:	.asciiz "Maximum of the array: "
prompt4:	.asciiz "Sum of elements of the array:"
prompt5:	.asciiz "Is it palindrome(1 if it is, 0 if it is not): "
prompt6:	.asciiz "Enter the value of the next element: "
prompt7:	.asciiz "-"
endl:		.asciiz "\n"

##
## end of circular_shifts.asm
