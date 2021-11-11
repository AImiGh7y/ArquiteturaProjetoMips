
.data
### WORD BANK ###
BLUE:     .asciiz "B"
GREEN:    .asciiz "G"
ORANGE:   .asciiz "O"
WHITE:    .asciiz "W"
YELLOW:   .asciiz "Y"
RED:      .asciiz "R"

.text

main:

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
li  $v0, 4
la  $a0, BLUE
syscall

addi $t0, $t0 ,1
j main

CGREEN:    
li  $v0, 4
la  $a0, GREEN
syscall

addi $t0, $t0 ,1
j main

CORANGE:  
li  $v0, 4
la  $a0, ORANGE
syscall

addi $t0, $t0 ,1
j main

CWHITE:   
li  $v0, 4
la  $a0, WHITE
syscall

addi $t0, $t0 ,1
j main

CYELLOW:   
li  $v0, 4
la  $a0, YELLOW
syscall

addi $t0, $t0 ,1
j main

CRED:     
li  $v0, 4
la  $a0, RED
syscall

addi $t0, $t0 ,1
j main

END:
li $v0, 10
syscall