
.data
### WORD BANK ###
BLUE:     .asciiz "B"
GREEN:    .asciiz "G"
ORANGE:   .asciiz "O"
WHITE:    .asciiz "W"
YELLOW:   .asciiz "Y"
RED:      .asciiz "R"

CODE: .space 12

.text

main:
la $s0, CODE
move $s1, $s0

beq $t0, 4, END
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

la  $a0, BLUE

sw $a0, ($s0)
addi $s0, $s0, 4
addi $t0, $t0 ,1

j main

CGREEN:    

la  $a0, GREEN

sw $a0, ($s0)
addi $s0, $s0, 4
addi $t0, $t0 ,1

j main

CORANGE:  
li  $v0, 4
la  $a0, ORANGE
syscall

sw $a0, ($s0)
addi $s0, $s0, 4
addi $t0, $t0 ,1

j main

CWHITE:   

la  $a0, WHITE

sw $a0, ($s0)
addi $s0, $s0, 4
addi $t0, $t0 ,1
j main

CYELLOW:   

la  $a0, YELLOW

sw $a0, ($s0)
addi $s0, $s0, 4
addi $t0, $t0 ,1

j main

CRED:     

la  $a0, RED

sw $a0, ($s0)
addi $s0, $s0, 4
addi $t0, $t0 ,1

j main

END:

li $v0, 4
la $s1, CODE
syscall

li $v0, 10
syscall
