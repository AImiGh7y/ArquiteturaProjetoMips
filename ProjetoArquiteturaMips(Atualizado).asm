.data

#CODE GENERATOR

### WORD BANK ###
BLUE:     .asciiz "B"
GREEN:    .asciiz "G"
ORANGE:   .asciiz "O"
WHITE:    .asciiz "W"
YELLOW:   .asciiz "Y"
RED:      .asciiz "R"

CODE: .space 16

MSG1: .asciiz "O Codigo e: "

#PRINT BOARD

BOARD: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

       
SIZECOLS: .word 4
SIZELINS: .word 10

.eqv DATA_SIZE 4      #SAME AS #DEFINE in C

#READ TRIES

MSG2: .asciiz " Tentativa:"

#MISCELLANEOUS

NewLine:    .asciiz     "\n"
Tab:    .asciiz     "\t"
buffer: .space 20

.text


#-----------------------------CODE GENERATOR------------------------------------------------------------------------------------------------------------------------------------------------------------


main:
	li $s0, 0
	li $t1, 0
	j LOOP_RANDOM

LOOP_RANDOM:
	beq $t0, 4, PRINT_LOOP_RANDOM_RESET

	li $a1, 6
	li $v0, 42         		 # Service 42, random int
	syscall           		 # Generate random int (returns in $a0)

	beq $a0, 0, CBLUE		 #Switch (valor)
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
	j LOOP_RANDOM

CGREEN:   
	la $a0, GREEN
	sw $a0, CODE($s0)

	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOP_RANDOM

CORANGE:  
	la $a0, ORANGE
	sw $a0, CODE($s0)

	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOP_RANDOM

CWHITE:  
	la $a0, WHITE
	sw $a0, CODE($s0)

	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOP_RANDOM

CYELLOW:  
	la $a0, YELLOW
	sw $a0, CODE($s0)

	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOP_RANDOM

CRED:    
	la $a0, RED
	sw $a0, CODE($s0)

	addi $s0, $s0, 4
	addi $t0, $t0 ,1
	j LOOP_RANDOM

PRINT_LOOP_RANDOM_RESET:
	li $s0, 0
	la $t0, MSG1
	li $v0, 4
	move $a0, $t0
	syscall

j PRINT_LOOP_RANDOM

PRINT_LOOP_RANDOM:
	beq $s0, 16, BOARD_
	
	lw $t6, CODE($s0)
	
	li $v0, 4
	move $a0, $t6
	syscall

	addi $s0, $s0, 4
	
	j PRINT_LOOP_RANDOM


#------------------------------------------PRINT BOARD---------------------------------------------------------------------------------------------------------------------------------
BOARD_:
	li $v0, 4                		# printf("\n")
	la $a0, NewLine
	syscall
	
	la $a0, BOARD
	lw $a1, SIZELINS
	lw $a2, SIZECOLS
	
	jal BOARD_PRINT
	j END
	
BOARD_PRINT:
        add $t3, $zero, $a0
        add $t0, $zero, $zero           	# i = 0

BOARD_PRINT_WHILE1:   				#First for loop printing the Matrix
       	li $t7, 0
        slt $t7, $t0, $a1                   	# if (i < size) continue
        beq $t7, $zero, BOARD_PRINT_END       	# If not, already printed all matrix 
    
    	li $v0, 1
        addi $a0, $t0, 0
        syscall
    	
    
#------------------------------------------READ TRIES--------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    	la $a0, MSG2         #Load and print string asking for string
        li $v0,4
        syscall

	#				printf("\n(%d) Tentativa->", i);
        #				gets(tentativa);

        li $v0,8         #take in input
        la $a0, buffer     #load byte space into address
        li $a3, 20         #allot the byte space for string
        move $t9,$a0         #save string to t0
        syscall
         
        la $a0, buffer     #reload byte space to primary address
        move $a0,$t9         #primary address = t0 address (load pointer)
        li $v0,4         #print string
        syscall
    
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
        li $t1, 0               		# j = 0
    
BOARD_PRINT_WHILE2:				#Second for loop printing the Matrix
        add $t6, $zero, $zero	
        slt $t6, $t1, $a2             		# if (j < size) continue
        beq $t6, $zero, BOARD_PRINT_END_LINE    # if not, already printed the whole line
 
        mul $t5, $t0, $a2  			# t5 = rowIndex * colSize
        add $t5, $t5, $t1  			# t5 = (rowIndex * colSize) + colIndex
        sll $t4, $t5, 2   			# t5 = (rowIndex * colSize + colIndex) * DATA_SIZE
        add $t5, $t4, $t3  			# t5 = (rowIndex * colSize + colIndex * DATA_SIZE) + base adress
        
       
    	
        li $v0, 4
        la $a0, Tab                 		# printf("\t")
        syscall
    
        addi $t1, $t1, 1                	# j++
        j BOARD_PRINT_WHILE2
 
BOARD_PRINT_END_LINE :                		# printf("\n")
        li $v0, 4
        la $a0, NewLine
        syscall
    
        addi $t0, $t0, 1                	# i++
        j BOARD_PRINT_WHILE1
            
BOARD_PRINT_END:                      		# End
        jr $ra







END:
	li $v0, 10
	syscall