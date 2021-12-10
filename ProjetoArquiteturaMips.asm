.data

#CODE GENERATOR

### WORD BANK ###
BLUE:     .byte 'B'
GREEN:    .byte 'G'
ORANGE:   .byte 'O'
WHITE:    .byte 'W'
YELLOW:   .byte 'Y'
RED:      .byte 'R'

CODE: .space 16  # acho que pode ser apenas 4!!

MSG1: .asciiz "O Codigo e: "

ERROR: .asciiz "Introduza uma cor do universo de cores (B, G, O, W, Y, R)"

#PONTOS

PONTOS1: .asciiz "Ten(s) "
PONTOS2: .asciiz " pontos!"
PONTOSF1: .asciiz "Acabas te com "
PONTOS3: .asciiz "Ganhaste! Recebes 12 pontos"


#PRINT BOARD

BOARD: .space 40
       
SIZECOLS: .word 4
SIZELINS: .word 10

.eqv DATA_SIZE 4      #SAME AS #DEFINE in C

#READ TRIES

MSG2: .asciiz " Tentativa:"
TRIES: .space 80

#E

confirmation_e: .asciiz     "Prime 'e' para parar, outra tecla para continuar"
e: .asciiz "e"
input_e: .space 80


#MISCELLANEOUS

NewLine:    .asciiz     "\n"
Tab:    .asciiz     "\t"
buffer: .space 20

.text

#-----------------------------CODE GENERATOR------------------------------------------------------------------------------------------------------------------------------------------------------------


main:

	li $s7, 0   #pontos
	
	j LOOP_GAME
	
	
LOOP_GAME:

	li $s0, 0
	li $t1, 0
	li $t0, 0

	li $v0, 4                		# printf("\n")
	la $a0, PONTOS1
	syscall
	
	li $v0, 1                		
	move $a0, $s7
	syscall
	
	li $v0, 4                		# printf("\n")
	la $a0, PONTOS2
	syscall
	
	li $v0, 4                		# printf("\n")
	la $a0, NewLine
	syscall

	
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
	lb $t4, 0($a0)
	la $a0, CODE
	add $a0, $a0, $s0
	sb $t4, 0($a0)

	addi $s0, $s0, 1
	addi $t0, $t0 ,1  # qual a diference entre estes??
	j LOOP_RANDOM

CGREEN:   
	la $a0, GREEN
	lb $t4, 0($a0)
	la $a0, CODE
	add $a0, $a0, $s0
	sb $t4, 0($a0)

	addi $s0, $s0, 1
	addi $t0, $t0 ,1
	j LOOP_RANDOM

CORANGE:  
	la $a0, ORANGE
	lb $t4, 0($a0)
	la $a0, CODE
	add $a0, $a0, $s0
	sb $t4, 0($a0)

	addi $s0, $s0, 1
	addi $t0, $t0 ,1
	j LOOP_RANDOM

CWHITE:  
	la $a0, WHITE
	lb $t4, 0($a0)
	la $a0, CODE
	add $a0, $a0, $s0
	sb $t4, 0($a0)

	addi $s0, $s0, 1
	addi $t0, $t0 ,1
	j LOOP_RANDOM

CYELLOW:  
	la $a0, YELLOW
	lb $t4, 0($a0)
	la $a0, CODE
	add $a0, $a0, $s0
	sb $t4, 0($a0)

	addi $s0, $s0, 1
	addi $t0, $t0 ,1
	j LOOP_RANDOM

CRED:
	la $a0, RED
	lb $t4, 0($a0)
	la $a0, CODE
	add $a0, $a0, $s0
	sb $t4, 0($a0)

	addi $s0, $s0, 1
	addi $t0, $t0 ,1
	j LOOP_RANDOM

PRINT_LOOP_RANDOM_RESET:
	li $s0, 0
	la $t0, MSG1
	li $v0, 4
	move $a0, $t0
	syscall

j PRINT_LOOP_RANDOM

PRINT_LOOP_RANDOM:  # imprimir codigo
	beq $s0, 4, BOARD_
	
	lb $t6, CODE($s0)
	
	li $v0, 11
	move $a0, $t6
	syscall

	addi $s0, $s0, 1
	
	j PRINT_LOOP_RANDOM


#------------------------------------------PRINT BOARD---------------------------------------------------------------------------------------------------------------------------------

BOARD_:

	li $t6, 0

	li $v0, 4                		# printf("\n")
	la $a0, NewLine
	syscall
	
	la $a0, BOARD
	lw $a1, SIZELINS
	lw $a2, SIZECOLS
	
	jal BOARD_PRINT
	j confirme_loop_e
	
BOARD_PRINT:
        add $t3, $zero, $a0
        add $t0, $zero, $zero           	# i = 0

BOARD_PRINT_WHILE1:   				#First for loop printing the Matrix

        slt $t7, $t0, $a1                   	# if (i < size) continue
        beq $t7, $zero, BOARD_PRINT_END       	# If not, already printed all matrix 
    
    	li $v0, 1
        addi $a0, $t0, 0
        syscall
    	
    	la      $a0, MSG2
        li      $v0, 4
   	syscall
    	
        #--------------------------------------------------------------------------READ TRIES---------------------------------------------------------------------------------------
        la      $s2, TRIES			# s2 = apontador para TRIES
        la  	$s4, CODE  			# s4 = apontador para CODE
       
       
        move 	$a0,$s2				# ler as tentativas
        li      $a3,20
        li      $v0,8
        syscall
       
        move    $s6, $zero  			# s6 = contador do loop
        
COMPARE_LOOP_GOOD:

	beq $t6, 4, COMPARE_LOOP_RESET
	
	lb      $t8,($s2)                   # get next char from TRIES
	
	lb 	$s0, WHITE			 # they are valid
	beq     $t8, $s0, GOOD            
	lb 	$s0, BLUE
	beq     $t8, $s0, GOOD  
	lb 	$s0, GREEN		
	beq     $t8, $s0, GOOD  
	lb 	$s0, YELLOW	
	beq     $t8, $s0, GOOD  
	lb 	$s0, ORANGE	
	beq     $t8, $s0, GOOD  
	lb 	$s0, RED	
	beq     $t8, $s0, GOOD  
	
	li $v0, 4
	la $a0, ERROR
	syscall
	
	li $v0, 4                		# printf("\n")
	la $a0, NewLine
	syscall
	
	j BOARD_PRINT_WHILE1
	
GOOD:
	addi 	$t6, $t6, 1		   #incrementar loop para verificar GOOD
	addi    $s2,$s2,1                  # point to next char no input
	j COMPARE_LOOP_GOOD


COMPARE_LOOP_RESET:  
	la $s2, TRIES
	la $s4, CODE
	li $t6, 0
   
	li $v0, 4
	la $a0, NewLine                 		# printf("\n")
	syscall
   
	j COMPARE_LOOP

COMPARE_LOOP:
	lb      $t8,($s2)                   # get next char from TRIES
	
	lb      $t9, 0($s4)          # get next "char" from CODE
	
						
	bne     $t8,$t9,cmpne              # they are different

	addi    $s2,$s2,1                  # point to next char no input
	addi    $s4,$s4,1                  # point to next char no code
	
	addi    $s6, $s6, 1  		   # incrementar s6 = contador do loop
	beq      $s6, 4, cmpeq
	j COMPARE_LOOP
       
       #--------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
BOARD_PRINT_WHILE2:				#Second for loop printing the Matrix
        add $t6, $zero, $zero	
        slt $t6, $t1, $a2             		# if (j < size) continue
        beq $t6, $zero, BOARD_PRINT_END_LINE    # if not, already printed the whole line
 
        mul $t5, $t0, $a2  			# t5 = rowIndex * colSize
        add $t5, $t5, $t1  			# t5 = (rowIndex * colSize) + colIndex
        sll $t4, $t5, 0   			# t5 = (rowIndex * colSize + colIndex) * DATA_SIZE
        add $t5, $t4, $t3  			# t5 = (rowIndex * colSize + colIndex * DATA_SIZE) + base adress
        
        
        lb      $t8, 0($s2)          		# get next char from TRIES
        move    $t5, $t8			# move content to inside the position in the matrix
    
    	        
        li $v0, 11				#print content inside of the matrix
        move $a0, $t8				#only prints one line (change)
        syscall
    
    
        li $v0, 4
        la $a0, Tab                 		# printf("\t")
        syscall
    	
    	addi $s2, $s2, 1			# point to next char no input
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

 j BOARD_PRINT_WHILE2
 
cmpne:
       la $s2, TRIES
       li $t1, 0
       j BOARD_PRINT_WHILE2


cmpeq:
 	 li $v0, 4                		
	 la $a0, PONTOS3
	 syscall
       
	 li $v0, 4                		
	 la $a0, NewLine
	 syscall
	       
	                     
         addi $s7, $s7, 12
     
         j confirme_loop_e

#------------------------------------------------------------------E-----------------------------------------------------------------------------------

confirme_loop_e:

    la $a0, confirmation_e
    li $v0,4
    syscall
    
    la      $s2, input_e
    move    $t2, $s2
    
    move    $a0,$t2
    li      $a1,79
    li      $v0,8
    syscall
   
    la $s3, e
    j compare_e

compare_e:

     lb      $t2,($s2)                  # get next char from str1
     lb      $t3,($s3)                  # get next char from str2
     
     bne     $t2,$t3, LOOP_GAME              # are they different? if yes, fly

     beq     $t2,$zero, END             # at EOS? yes, fly (strings equal)

     addi    $s2,$s2,4                  # point to next char
     addi    $s3,$s3,4                  # point to next char
     j       compare_e


END:
	li $v0, 10
	syscall
