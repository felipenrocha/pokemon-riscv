.data 


.text
SETUP:
	
	la a0, home_1f
	li a1, 0
	li a2, 0
	li a3, 0
	call PRINT
	li a3, 1
	call PRINT
	
#

GAME_LOOP:

	call KEY2

	xori s0, s0, 1
	call PRINT_LAST_POS
	

	# load current frame of character set it to a0:	

	# print last square of characters based on current map (32x32)

	# get the adress of image to be used (a0 = adress of image) 
	call SPRITE_ADRESS
	la t0, CHAR_POS
	lh a1, 0(t0)
	lh a2, 2(t0)
	mv a3, s0
	call PRINT

	li t0,0xFF200604
	sw s0, 0(t0)
	
	j GAME_LOOP



# KEY POOLING:
	

KEY2:		
		li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla tecla
		

		# ANIMATION OF SPRITE (STORE CURRENT FRAME):
	# get current sprite frame adress
		la t3, CURR_FRAME
		# get current frame
		lb t4, 0(t3)
		# top frame == 3:
		li t5, 3
		# IF current frame == 3, next frame = 1
		beq t4, t5, RESET_FRAME
		# add 1:
		addi t4, t4, 1


		PULA_SOMA_FRAME:
			sb t4, 0(t3)

	# END STORE CURRENT FRAME


		li t0,'w'
		# store direction
		la t3, CURR_DIRECTION
		# direction up: 0
		li t4, 0
		sb t4, 0(t3)
		beq t2,t0,CHAR_CIMA		# se tecla pressionada for 'w', chama CHAR_CIMA

		
		
		li t0,'a'
		# store direction
		la t3, CURR_DIRECTION
		li t4, 1
		sb t4, 0(t3)


		
	

		beq t2,t0,CHAR_ESQ		# se tecla pressionada for 'a', chama CHAR_CIMA
		
		li t0,'s'
		# store direction
		la t3, CURR_DIRECTION
		# direction down: 2
		li t4, 2
		sb t4, 0(t3)
		beq t2,t0,CHAR_BAIXO		# se tecla pressionada for 's', chama CHAR_CIMA
		
		li t0,'d'
		# store direction
		la t3, CURR_DIRECTION
		# direction right: 3
		li t4, 3
		sb t4, 0(t3)
		beq t2,t0,CHAR_DIR		# se tecla pressionada for 'd', chama CHAR_CIMA



	
FIM:		ret				# retorna
				
	
CHAR_ESQ:
	la t0, 	CHAR_POS
	lh t1, 0(t0)			# carrega o x atual do personagem
	lh t3, 2(t0)

	la t2,OLD_CHAR_POS
	sh t1, 0(t2)	
	sh t3, 2(t2)


	addi t1, t1, -32
	sh t1, 0(t0)    		# salva novo x em char_pos
	ret
	
CHAR_DIR:
	la t0, 	CHAR_POS
	lh t1, 0(t0)			# carrega o x atual do personagem
	lh t3, 2(t0)

	la t2, OLD_CHAR_POS
	sh t1, 0(t2)	
	sh t3, 2(t2)	


	# salva a posicao atual do personagem em OLD_CHAR_POS
	addi t1, t1, 32 		# incrementa 16
	sh t1, 0(t0)  			# salva x em char_pos[0]

	ret
	
																																											
CHAR_CIMA:
	la t0,CHAR_POS
	lh t1, 0(t0)			# carrega o x atual do personagem
	lh t3, 2(t0)

	la t2, OLD_CHAR_POS
	sh t1, 0(t2)	
	sh t3, 2(t2)	

	lh t1, 2(t0)				# carrega y
	addi t1,t1,-32				# decrementa 16 pixeis
	sh t1,2(t0)		    		# salva y
	ret
	
					
CHAR_BAIXO:

	la t0,CHAR_POS
	lh t1, 0(t0)    			# carrega x atual
	lh t3, 2(t0)				# carrega o y atual


	la t2,OLD_CHAR_POS
	sh t1, 0(t2)				
	sh t3, 2(t2)				# salva a posicao atual do personagem em OLD_CHAR_POS


	lh t1, 2(t0)				# carrega y
	addi t1,t1,32				# incrementa 16 pixeis
	sh t1,2(t0)			  		# salva y
	ret												






#  SET CURRENT FRAME TO 1

RESET_FRAME:
	li  t5, 1
	mv t4, t5
	J PULA_SOMA_FRAME
			
	
.data

.include "animation.s"
