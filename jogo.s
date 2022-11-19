.text

SETUP:
	call PRINT_MAP
	call PRINT_USER
#
PRINT_MAP:
	la a0, home_1f
	li a1, 0
	li a2, 0
	li a3, 0
	call PRINT
	
	
	
PRINT_USER:
	la a0, hero_1
	li a1, 160
	li a2, 120
	li a3, 0 
	call PRINT
	



#	a0 = ENDERECO DA IMAGEM
#	a1 = x
#	a2 = y
#	a3 = frame (ou ou 1)
#
##
#	t0 = endereco do bmp display
#	t1 = endereco da imagem
#       t2 = contador de linha
#	t3 = contador de coluna
#	t4 = altura
#	t5 = largura



PRINT: 		
	# loading adress of bitmap
	li t0, 0xFF0
	add t0, t0, a3
	slli t0, t0, 20
	
	# calculando x e y
	add t0, t0, a1
	li t1, 320
	mul t1, t1, a2
	add t0, t0, t1
	
	addi t1, a0, 8

	# zerando contadores
	mv t2, zero
	mv t3, zero
	
	lw t4, 0(a0)
	lw t5, 4(a0)
	
	
PRINT_LINHA:
	lw t6, 0(t1)
	sw t6, 0(t0)
	
	addi t0,t0, 4
	addi t1,t1, 4
	addi t3, t3, 4
	
	blt t3, t4, PRINT_LINHA
	# pula de linha e volta para o inicio
	addi t0, t0, 320
	sub t0, t0, t4
	
	li t3, 0
	addi t2, t2, 1
	blt t2, t4, PRINT_LINHA
	
	ret

.data
.include "sprites/backgrounds/home_1f.data"
.include "sprites/characters/hero_1.data"