.data
### WORD BANK ###
BLUE:     .asciiz "B"
GREEN:    .asciiz "G"
ORANGE:   .asciiz "O"
WHITE:    .asciiz "W"
YELLOW:   .asciiz "Y"
RED:      .asciiz "R"

CODE: .space 16

.text
main:
	li $s0, 0
	li $t1, 0
	j LOOPRANDOM

LOOPRANDOM:
	beq $t0, 4, PRINTLOOPRANDOMRESET

	li $a1, 6
	li $v0, 42         # Service 42, random int
	syscall            # Generate random int (returns in $a0)

	beq $a0, 0, CBLUE
	beq $a0, 1, CGREEN
	beq $a0, 2, CORANGE
	beq $a0, 3, CWHITE
	beq $a0, 4, CYELLOW
	beq $a0, 5, CRED
  
CBLUE:    
	la $a0, BLUE
	sw $a0, CODE($s0)
	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOPRANDOM

CGREEN:   
	la $a0, GREEN
	sw $a0, CODE($s0)

	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOPRANDOM

CORANGE:  
	la $a0, ORANGE
	sw $a0, CODE($s0)

	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOPRANDOM

CWHITE:  
	la $a0, WHITE
	sw $a0, CODE($s0)

	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOPRANDOM

CYELLOW:  
	la $a0, YELLOW
	sw $a0, CODE($s0)

	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOPRANDOM

CRED:    
	la $a0, RED
	sw $a0, CODE($s0)

	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOPRANDOM

PRINTLOOPRANDOMRESET:
li $s0, 0
j PRINTLOOPRANDOM

PRINTLOOPRANDOM:

	beq $s0, 16, END
	
	lw $t6, CODE($s0)
	
	li $v0, 4
	move $a0, $t6
	syscall

	addi $s0, $s0, 4
	
	j PRINTLOOPRANDOM


END:
	li $v0, 10
	syscall
