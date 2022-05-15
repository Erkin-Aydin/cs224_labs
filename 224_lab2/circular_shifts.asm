#########################################################
####################### Circular Shift
#########################################################

#$s0 = decimal value to be reversed.
#$s1 = shamt
#$s2 = direction
#$s3 = 1
#$s4 = masking purposes
#$s5 = shifted version

	.text		
.globl __start
 
__start:				# execution starts here

	addi $s3, $0, 1

	la $a0, prompt1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $s0, $v0
	
	la $a0, prompt2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $s1, $v0
	
askop:	la $a0, prompt3
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $s2, $v0
	
	slt $t0, $s2, $0
	slt $t1, $s3, $s2
	xor  $t0, $t0, $t1		#making sure the user enters a valid direction
	
	beq $t0, $0, cont
	
	la $a0, prompt4			#printing "Invalid value entered."
	li $v0, 4
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall				#ending the line.
	
	j askop
	
cont:	la $a0, prompt5
	li $v0, 4
	syscall				#printing "Number to be Shifted: "
	
	move $a0, $s0			#number, in hexadecimal form, printed
	li $v0, 34
	syscall
	
	la $a0, endl			#to the next line we go
	li $v0, 4
	syscall
	
	la $a0, prompt6
	li $v0, 4
	syscall				#printing "The Shift Amount: "
	
	move $a0, $s1
	li $v0, 1
	syscall
	
	la $a0, endl			#to the next line we go
	li $v0, 4
	syscall
	
	la $a0, prompt7
	li $v0, 4
	syscall				#printing "Shifting Direction: "
	
	beq $s2, $0, left
	
	la $a0, prompt8
	li $v0, 4
	syscall	
	
	move $a0, $s0
	move $a1, $s1
	
	jal src
	j end
	
left:
	la $a0, prompt9
	li $v0, 4
	syscall	
	
	move $a0, $s0
	move $a1, $s1
	
	jal slc
	j end

	
src:
	move $t0, $a1
	slti $t1, $t0, 32
	bne $t1, $0, pow1p
again1:	addi $t0, $t0, -32
	slti $t0, $a1, 32
	bne $t0, $0, again1
	
pow1p:	addi $t1, $0, 1
pow1:	sll $t1, $t1, 1
	addi $t0, $t0, -1
	bne $t0, $0, pow1
	
	div $a0, $t1
	mflo $v0
	mfhi $t2
	addi $t3, $0, 32
	sub $t3, $t3, $a1
	sllv $t2, $t2, $t3
	add $v0, $v0, $t2
	
	jr $ra
	
	
slc:
	move $t0, $a1
	slti $t1, $t0, 32
	bne $t1, $0, pow2p
again2:	addi $t0, $t0, -32
	slti $t0, $a1, 32
	bne $t0, $0, again2
	
pow2p:	addi $t1, $0, 1
pow2:	sll $t1, $t1, 1
	addi $t0, $t0, -1
	bne $t0, $0, pow2
	
	mult $a0, $t1
	mflo $v0
	mfhi $t1
	add $v0, $v0, $t1
	
	jr $ra
	
	
end:	
	move $s5, $v0
	
	la $a0, prompt10
	li $v0, 4
	syscall	
	
	move $a0, $s5
	li $v0, 34
	syscall
	
	
	li $v0,10  			# system call to exit
	syscall				#bye bye

#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
prompt1:	.asciiz "Enter the decimal number: "
prompt2:	.asciiz "Enter the shift amount: "
prompt3:	.asciiz "To shift left, enter 0, to shift right, enter 1: "
prompt4:	.asciiz "Invalid value entered."
prompt5:	.asciiz "Number to be Shifted: "
prompt6:	.asciiz "The Shift Amount: "
prompt7:	.asciiz "Shifting Direction: "
prompt8:	.asciiz	"Right\n"
prompt9:	.asciiz	"Left\n"
prompt10:	.asciiz "Shifted Version: "
endl:		.asciiz "\n"

##
## end of circular_shifts.asm
