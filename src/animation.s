.data
# stores current direction for animation: 
# 0: up, 1: left, 2: down, 3 right
CURR_DIRECTION: .byte  1
CHAR_POS:	.half 128,128			# x, y
OLD_CHAR_POS:	.half 64,64	# x, y

# store which frame od character where using on animation rn (1 , 2, or 3)
CURR_FRAME: .byte 1


SEPARATOR2: .ascii " , "


.text

# print params:
#################################################
#	a0 = endereço imagem			#
#	a1 = x					    #
#	a2 = y					    #   
#	a3 = frame (0 ou 1)			#
#################################################
#	t0 = endereco do bitmap display		#
#	t1 = endereco da imagem			#
#	t2 = contador de linha			#
# 	t3 = contador de coluna			#
#	t4 = largura				    #   
#	t5 = altura				        #
#################################################



PRINT_LAST_POS:
    # we need to print a squareof the current map 16  by 16  starting from the old character position.
    # store ra
    addi sp, sp, -4
    sw ra, 0(sp)  


    # print syscall to see values of old char pos (debug):
    


    # load old char pos to pass it as x and y:
    la t0, OLD_CHAR_POS
    # t1 = x, t2 = y
    lh t1, 0(t0)
    lh t2, 2(t0)
    li t4, 16
    li t5, 16


	# la a0, lab
	mv a1, t1
	mv a2, t2
	mv a3, s0
    mv a4, t4
    mv a5, t5

    call PRINT_SQUARE
    
    
    #  load ra
    lw ra 0(sp)
    addi sp, sp, 4
    ret


SPRITE_ADRESS:
        # load current frame adress
        la t2, CURR_FRAME
        #  load curr fram value
        lb t3, 0(t2)
        #  t0 == 3



        # LOAD BASED O CURRENT FRAME OF CHARACTER
        li t4, 1
        li t5, 2
        li t6, 3
        
        # t2 = Curr frame adress
        # t3 =  current frame
        # load current direction adress

        la t0, CURR_DIRECTION
        # load current direction value
        lb t1, 0(t0)

        # is character going up
        li t0, 0
        beq t1, t0, UP

        li t0, 1
        beq t1, t0, LEFT
            
        li t0, 2
        beq t1, t0, DOWN

        li t0, 3
        beq t1, t0, RIGHT

UP: 

    beq t4, t3, UP_1
    beq t5, t3, UP_2
    beq t6, t3, UP_3


    UP_1:
        la a0, hero_up_1
        ret

    UP_2:
        la a0, hero_up_2
        ret

    UP_3:
        la a0, hero_up_3
        ret


LEFT:
        beq t4, t3, LEFT_1
        beq t5, t3, LEFT_2
        beq t6, t3, LEFT_3

    LEFT_1:
        la a0, hero_left_1
        ret

    LEFT_2:
        la a0, hero_left_2
        ret

    LEFT_3:
        la a0, hero_left_3
        ret




DOWN:  
    beq t4, t3, DOWN_1
    beq t5, t3, DOWN_2
    beq t6, t3, DOWN_3


    DOWN_1:
    la a0, hero_down_1
    ret

    DOWN_2:
    la a0, hero_down_2
    ret

    DOWN_3:
    la a0, hero_down_3
    ret


RIGHT:
    beq t4, t3, RIGHT_1
    beq t5, t3, RIGHT_2
    beq t6, t3, RIGHT_3


    RIGHT_1:
    la a0, hero_right_1
    ret

    RIGHT_2:
    la a0, hero_right_2
    ret

    RIGHT_3:
    la a0, hero_right_3
    ret








#################################################
#	a0 = endereço imagem			#
#	a1 = x					#
#	a2 = y					#
#	a3 = frame (0 ou 1)			#
#################################################
#	t0 = endereco do bitmap display		#
#	t1 = endereco da imagem			#
#	t2 = contador de linha			#
# 	t3 = contador de coluna			#
#	t4 = largura				#
#	t5 = altura				#
#################################################

PRINT:		

        li t0,0xFF0			# carrega 0xFF0 em t0
		add t0,t0,a3			# adiciona o frame ao FF0 (se o frame for 1 vira FF1, se for 0 fica FF0)
		slli t0,t0,20			# shift de 20 bits pra esquerda (0xFF0 vira 0xFF000000, 0xFF1 vira 0xFF100000)
		
		add t0,t0,a1			# adiciona x ao t0
		
		li t1,320			    # t1 = 320
		mul t1,t1,a2			# t1 = 320 * y
		add t0,t0,t1			# adiciona t1 ao t0
		
		addi t1,a0,8			# t1 = a0 + 8
		
		mv t2,zero			# zera t2
		mv t3,zero			# zera t3
		
		lw t4,0(a0)			# carrega a largura em t4
		lw t5,4(a0)			# carrega a altura em t5
		
PRINT_LINHA:	
        lw t6,0(t1)			# carrega em t6 uma word (4 pixeis) da imagem
		sw t6,0(t0)			# imprime no bitmap a word (4 pixeis) da imagem
		
		addi t0,t0,4			# incrementa endereco do bitmap
		addi t1,t1,4			# incrementa endereco da imagem
		
		addi t3,t3,4			# incrementa contador de coluna
		blt t3,t4,PRINT_LINHA		# se contador da coluna < largura, continue imprimindo

		addi t0,t0,320			# t0 += 320
		sub t0,t0,t4			# t0 -= largura da imagem
		# ^ isso serve pra "pular" de linha no bitmap display
		
		mv t3,zero			# zera t3 (contador de coluna)
		addi t2,t2,1			# incrementa contador de linha
		bgt t5,t2,PRINT_LINHA		# se altura > contador de linha, continue imprimindo
		
		ret				# retorna

PRINT_SQUARE: 	
     	
	# loading adress of bitmap
	li t0, 0xFF0
	add t0, t0, a3
	slli t0, t0, 20
	
    add t0,t0,a1			# adiciona x ao t0
    li t4, 320
    mv t2, a2

    mul t2, t2, t4
    add t0, t0, t2          # adiciona y ao t0

	# calculando x e y

    # calculate adress of x,y:
    #   x = a1, y = a2
    # t1 will have the adress of inicial byte from position a1, a2
    mv t1, zero
	addi t1, a0, 8
    
    mv t2, a1 
    mv t3, a2

    # x in t2 and y in t3
    li      t4, 320
    mul     t3, t3, t4
    add     t2, t2, t3

    add t1, t1, t2
    
	# zerando contadores
	mv t2, zero
	mv t3, zero
	# square 32x32
    mv t4, a4
	
	
PRINT_LINHA_SQUARE:





	lw t6, 0(t1)
	sw t6, 0(t0)

	addi t0,t0, 4
	addi t1,t1, 4
	addi t3, t3, 4
	
	blt t3, t4, PRINT_LINHA_SQUARE
	# pula de linha e volta para o inicio
	addi t0, t0, 320
	sub t0, t0, t4

    addi t1, t1, 320
    sub t1, t1, t4

	
	li t3, 0
	addi t2, t2, 1


	blt t2, t4, PRINT_LINHA_SQUARE
	
	ret
	




PRINT_BACKGROUND:
    addi    sp, sp, -4
    sw      ra, 0(sp)  

	li a1, 0
	li a2, 0
	li a3, 0
	call PRINT
	li a3, 1
	call PRINT

    lw      ra, 0(sp)                      # 4-byte Folded Reload
    addi    sp, sp, 4   
    ret



SLEEP:
	li a7,132
	ecall
    ret


DRAW_LINE:
	li a7,47
	ecall
    
.data
.include "../sprites/characters/hero_left_1.s"s
.include "../sprites/characters/hero_left_2.s"
.include "../sprites/characters/hero_left_3.s"



.include "../sprites/characters/hero_right_1.s"
.include "../sprites/characters/hero_right_2.s"
.include "../sprites/characters/hero_right_3.s"



.include "../sprites/characters/hero_up_1.s"
.include "../sprites/characters/hero_up_2.s"
.include "../sprites/characters/hero_up_3.s"


.include "../sprites/characters/hero_down_1.s"
.include "../sprites/characters/hero_down_2.s"
.include "../sprites/characters/hero_down_3.s"



.include "../sprites/characters/oak_full.s"
.include "../sprites/backgrounds/oak-introduction-bg.s"

.include "../sprites/misc/baseround.s"

