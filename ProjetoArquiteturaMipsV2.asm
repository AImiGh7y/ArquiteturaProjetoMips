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
MSG3: .asciiz "O Codigo era: "
ERROR: .asciiz "Introduza uma cor do universo de cores (B, G, O, W, Y, R)"

BLACKCOUNTMSG: .asciiz "Tens "
BLACKCOUNTMSG1: .asciiz " cores certas na posicao correta"

WHITECOUNTMSG: .asciiz "Tens "
WHITECOUNTMSG1: .asciiz " cores certas na posicao errada"

LOSE: .asciiz "Perdeste!"

#PONTOS

PONTOS1: .asciiz "Ten(s) "
PONTOS2: .asciiz " pontos!"
PONTOS3: .asciiz "Ganhaste!"
PONTOS4: .asciiz "Recebeste "


#PRINT BOARD

BOARD: .space 40
       
SIZECOLS: .word 4
SIZELINS: .word 10

.eqv DATA_SIZE 4      #SAME AS #DEFINE in C

#READ TRIES

MSG2: .asciiz " Tentativa:"
TRIES: .space 80

TRIES_TEMP: .space 80
CODE_TEMP: .space 80
REMOVE_TRY:       .byte 'X'
REMOVE_CODE:      .byte 'Z'

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
	j PRINT_LOOP_RANDOM_RESET_END
	
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

	beq $t6, 4, START_COMPARE
	
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



## black = cor certa, posicao certa

START_COMPARE:
	# comeca por copiar o TRIES e o CODE para variaveis temporarias
	li $t0, 0
START_COMPARE_LOOP:
	la $t1, TRIES
	la $t2, TRIES_TEMP
	add $t1, $t1, $t0
	add $t2, $t2, $t0
	lb $t3, 0($t1)
	sb $t3, 0($t2)

	la $t1, CODE
	la $t2, CODE_TEMP
	add $t1, $t1, $t0
	add $t2, $t2, $t0
	lb $t3, 0($t1)
	sb $t3, 0($t2)

	addi $t0, $t0, 1
	beq $t0, 4, BLACKCOUNT_RESET
	j START_COMPARE_LOOP


BLACKCOUNT_RESET:  
	la      $s2, TRIES			# s2 = apontador para TRIES
        la  	$s4, CODE  			# s4 = apontador para CODE
	
	li $s5, 0			                #BLACKCOUNT
   	li $t6, 0
   	
	j BLACKCOUNT

BLACKCOUNT:
	
	beq     $t6, 4, TERMINA_BLACKCOUNT

	lb      $t8, 0($s2)                   # get next char from TRIES
	lb      $t9, 0($s4)          # get next "char" from CODE

	beq     $t8,$t9, BLACK_COUNTER              # they are the same
	
	addi    $t6, $t6, 1		#counter
	addi    $s2,$s2,1                  # point to next char no input
	addi    $s4,$s4,1                  # point to next char no code	
	
	j BLACKCOUNT

BLACK_COUNTER:
	# modificamos o valor do TRIES (para zero) para nao voltar a contar
	la $t0, REMOVE_TRY
	lb $t0, 0($t0)
	la $t1, TRIES_TEMP
	add $t1, $t1, $t6
	sb $t0, 0($t1)
	# modificamos o valor do CODE (para um) para nao voltar a contar
	la $t0, REMOVE_CODE
	lb $t0, 0($t0)
	la $t1, CODE_TEMP
	add $t1, $t1, $t6
	sb $t0, 0($t1)

	addi    $t6, $t6, 1		#counter
	addi    $s2,$s2,1                  # point to next char no input
	addi    $s4,$s4,1                  # point to next char no code	
	addi 	$s5, $s5, 1		   #Blackcount++
	j BLACKCOUNT


TERMINA_BLACKCOUNT:
	la $s2, TRIES         # <---- esta linha nao precisa existir
	la $s4, CODE          # <---- esta linha nao precisa existir
	li $t6, 0             # <---- esta linha nao precisa existir

	li $v0, 4
	la $a0, NewLine                 		# printf("\n")
	syscall
   
   	li $v0, 4
	la $a0, BLACKCOUNTMSG                 		
	syscall
   
   	li $v0, 1
   	move $a0, $s5
   	syscall
   
   	li $v0, 4
	la $a0, BLACKCOUNTMSG1                 		
	syscall
   
   
	li $v0, 4
	la $a0, NewLine                 		# printf("\n")
	syscall
   
	j WHITECOUNT_RESET

## white = cor certa, posicao errada
# o WHITE usa o TRIES_TEMP e CODE_TEMP em que foram eliminados os caracteres encontrados

WHITECOUNT_RESET:
   	li $t6, 0       # iterador do CODE
        la $s4, CODE_TEMP  			# s4 = apontador para CODE
	li $s6, 0       # WHITECOUNT
	j WHITECOUNT_EACH_CODE

WHITECOUNT_EACH_CODE:
	beq     $t6, 4, TERMINA_WHITECOUNT
	la $s2, TRIES_TEMP			# s2 = apontador para TRIES
   	li $t7, 0       # iterador do TRIES
	j WHITECOUNT

WHITECOUNT_EACH_CODE_INC:
	addi    $t6, $t6, 1
	addi    $s4, $s4, 1                  # point to next char no code
	j WHITECOUNT_EACH_CODE

WHITECOUNT:
	
	beq     $t7, 4, WHITECOUNT_EACH_CODE_INC
	beq     $t6, $t7, WHITECOUNT_CONTINUE

	lb      $t8, 0($s2)                   # get next char from TRIES
	lb      $t9, 0($s4)          # get next "char" from CODE
	addi    $t7, $t7, 1		#iterador do tries
			
	beq     $t8, $t9, WHITE_COUNTER              # they are the same
	addi    $s2, $s2, 1                  # point to next char no code	
	j WHITECOUNT

WHITECOUNT_CONTINUE:
	addi    $t7, $t7, 1		# avancar iterador
	addi    $s2, $s2, 1             # avancar apontador
	j WHITECOUNT

WHITE_COUNTER:
	addi 	$s6, $s6, 1         # Whitecount++
	j WHITECOUNT_EACH_CODE_INC  # break


TERMINA_WHITECOUNT:
	la $s2, TRIES
	la $s4, CODE
	li $t6, 0
   
	li $v0, 4
	la $a0, NewLine                 		# printf("\n")
	syscall
   
   	li $v0, 4
	la $a0, WHITECOUNTMSG                 		
	syscall
   
   	li $v0, 1
   	move $a0, $s6
   	syscall
   
   	li $v0, 4
	la $a0, WHITECOUNTMSG1                 		
	syscall
   
   
	li $v0, 4
	la $a0, NewLine                 		# printf("\n")
	syscall
   
	j VERIFICA_GANHOU_JOGO


VERIFICA_GANHOU_JOGO:
	beq     $s5, 4, GANHOU_JOGO
	j NAO_GANHOU_JOGO

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
  	
        li $v0, 11				
        move $a0, $t8				
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
        
        beq $t0, 10, POINTS
        
        j BOARD_PRINT_WHILE1
        
POINTS:

	mul $s6, $s5, 3				#last round x3 number of correct guesses
	add $s7, $s7, $s6			#3x + previous points
        
        beq $s6, 0, LOST			#missed everything
        
        li $v0, 4                		
	la $a0, PONTOS4
	syscall
        
        li $v0, 1		
	move $a0, $s6
	syscall
        
        li $v0, 4                		
	la $a0, PONTOS2
	syscall
	 
	li $v0, 4
        la $a0, NewLine
        syscall
	 
        j BOARD_PRINT_WHILE1

LOST:

	li $v0, 4
	la $a0, LOSE
	syscall
	
	li $v0, 4
        la $a0, NewLine
        syscall
	
	bne $s7, 0, LOST_POINTS
	
	j BOARD_PRINT_WHILE1
	
LOST_POINTS:

	sub $s7, $s7, 3
	j BOARD_PRINT_WHILE1

BOARD_PRINT_END:                      		# End
        jr $ra

 j BOARD_PRINT_WHILE2
 
NAO_GANHOU_JOGO:
       la $s2, TRIES
       li $t1, 0
       j BOARD_PRINT_WHILE2


GANHOU_JOGO:

 	 li $v0, 4                		
	 la $a0, PONTOS3
	 syscall
       
	 li $v0, 4                		
	 la $a0, NewLine
	 syscall
	       
	                     
         addi $s7, $s7, 12
     
         j PRINT_LOOP_RANDOM_RESET_END


PRINT_LOOP_RANDOM_RESET_END:
	li $s0, 0
	la $t0, MSG3
	li $v0, 4
	move $a0, $t0
	syscall
	j PRINT_LOOP_RANDOM_END

PRINT_LOOP_RANDOM_END:  # imprimir codigo
	beq $s0, 4, confirme_loop_e
	
	lb $t6, CODE($s0)
	
	li $v0, 11
	move $a0, $t6
	syscall

	addi $s0, $s0, 1
	
	j PRINT_LOOP_RANDOM_END

#------------------------------------------------------------------E-----------------------------------------------------------------------------------

confirme_loop_e:

	li $v0, 4                		
	la $a0, NewLine
	syscall

 	li $v0, 4                		
	la $a0, PONTOS1
	syscall

	li $v0, 1		
	move $a0, $s7
	syscall

	li $v0, 4                		
	la $a0, PONTOS2
	syscall

	li $v0, 4                		
	la $a0, NewLine
	syscall

   	la $a0, confirmation_e
   	li $v0,4
    	syscall
    
     	li $v0, 4                		
	la $a0, NewLine
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
