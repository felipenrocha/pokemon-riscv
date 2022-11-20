.data 
CHAR_POS: .half 0,0
OLD_CHAR_POS:	.half 0,0			# x, y
.text

SETUP:
	la a0, home_1f
	li a1, 0
	li a2, 0
	li a3, 0
	call PRINT
	li a3, 1
	call PRINT
	

GAME_LOOP:

	call KEY2
	xori s0, s0, 1
	
	la t0,CHAR_POS			# carrega em t0 o endereco de CHAR_POS
	
	
	la t0, CHAR_POS
	la a0, hero_1
	lh a1, 0(t0)
	lh a2, 2(t0)
	mv a3, s0
	call PRINT_USER

	li t0,0xFF200604
	sw s0, 0(t0)
	
	j GAME_LOOP



	

KEY2:		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla tecla
		
		li t0,'w'
		beq t2,t0,CHAR_CIMA		# se tecla pressionada for 'w', chama CHAR_CIMA
		
		li t0,'a'
		beq t2,t0,CHAR_ESQ		# se tecla pressionada for 'a', chama CHAR_CIMA
		
		li t0,'s'
		beq t2,t0,CHAR_BAIXO		# se tecla pressionada for 's', chama CHAR_CIMA
		
		li t0,'d'
		beq t2,t0,CHAR_DIR		# se tecla pressionada for 'd', chama CHAR_CIMA
	
FIM:		ret				# retorna
				

				
CHAR_ESQ:
	la t0, 	CHAR_POS
	lh t1, 0(t0)
	li t2, 16
	ble t1, t2, BORDA_ESQUERDA
	addi t1, t1, -16
	sh t1, 0(t0)
	ret
	
CHAR_DIR:
	la t0, 	CHAR_POS
	lh t1, 0(t0)
	li t2, 288                       # right bound
	bge  t1, t2, BORDA_DIREITA
	addi t1, t1, 16
	sh t1, 0(t0)
	ret
	
																																											
CHAR_CIMA:
	la t0,CHAR_POS
	li t2, 16                        # upper bound
	lh t1,2(t0)		         # carrega o y atual do personagem
	ble t1, t2, BORDA_CIMA
	addi t1,t1, -16 			# decrementa 16 pixeis
	sh t1,2(t0)			# salva
	ret
	

					
															
CHAR_BAIXO:
	la t0,CHAR_POS
	li t2, 192 			# lower bound
	lh t1,2(t0)   			# carrega o y atual do personagem
	bge  t1, t2, BORDA_BAIXO
	addi t1,t1, 16			# incrementa 16 pixeis
	sh t1,2(t0)			# salva
	ret												



BORDA_CIMA:	
	li t1, 0
	sh t1, 2(t0)
	ret
BORDA_BAIXO:
	li t1, 208
	sh t1, 2(t0)
	ret

BORDA_DIREITA:
	li t1, 288
	sh t1, 0(t0)
	ret
BORDA_ESQUERDA:
	li t1, 0
	sh t1, 0(t0)
	ret
	
	
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
	






PRINT_USER: 	
#different fgunction to print the npcs and the user	
	# loading adress of bitmap
	li t0, 0xFF0
	add t0, t0, a3
	slli t0, t0, 20
	
	#load background color:
	li s1, 223
	
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
	
	
PRINT_LINHA_USER:
	lb t6, 0(t1)
	lbu s2, 0(t1)
	beq s2, s1, PULA_BACKGROUND # pula background rosa
	sb t6, 0(t0)
PULA_BACKGROUND:	
	addi t0,t0, 1
	addi t1,t1, 1
	addi t3, t3, 1
	
	blt t3, t4, PRINT_LINHA_USER
	# pula de lih e volta para o inicio
	addi t0, t0, 320
	sub t0, t0, t4
	
	li t3, 0
	addi t2, t2, 1
	blt t2, t4, PRINT_LINHA_USER
	
	ret

	
.data
.include "sprites/backgrounds/home_1f.s"
.include "sprites/characters/hero_1.s"
