
.text
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

				
		li t0,'z'
		beq t2,t0,SELECT_ACTION
				
		li t0,'x'
		beq t2,t0,JUMP_START_BATTLE



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



	
FIM:		

		ret				# retorna
				


JUMP_START_BATTLE:
addi sp, sp, -4
sw ra, 0(sp)

call START_BATTLE

lw ra, 0(sp)
addi sp, sp, 4
ret




SELECT_ACTION:
# press z on map
addi sp, sp, -4
sw ra, 0(sp)

## if its character selection map -> check position-> if its equal to a pokeball one , select it
	call IS_POKEMON_SELECTION # a0 == boolean if current maps is pokemon
	beq a0, zero, NPSMS
		# pokemon selection zone:
		# CHECK IF current position is equal to a pokeball area:
		la t0, CHAR_POS
		lh t1, 0(t0) # x
		lh t2, 2(t0) # y 

		# y == 84 -> correct y
		# 112 <= x <= 192 -> correct x
		li t3, 84
		bne t2, t3, NPSMS # if y not correct, not correct position
		li t3, 112
		blt t1, t3, NPSMS # if x < 112 -> not correct position
		li t3, 192
		bgt t1, t3, NPSMS  # if x > 192 -> not correct position
		#  CORRECT POSITION
			# SELECT POKEMON:
			# PRINT menu with pokemon index of that position
			# index of pokemon based on x -> 112 = 0, 1
			li a0, 112
			call GET_POKEMON_INDEX_SELECTION
			call POKEMON_SELECT_MENU
		call PRINT_CURRENT_MAP
		j SAEND
NPSMS:
# NOT POKEMON SELECTION MAP SELECTION


SAEND:
lw ra, 0(sp)
addi sp, sp, 4
ret






CHAR_ESQ:
	# right colision = current map data + 2 

	#  CHECA SE x >= colisao do mapa atual de baixo
	addi sp, sp, -4
	sw ra, 0(sp)
	call GET_DATA_FROM_MAP
	lw ra, 0(sp)
	addi sp, sp, 4
	# a0 = adress of map
	addi a0, a0, 2
	lh t4, 0(a0)

	la t0, 	CHAR_POS
	lh t1, 0(t0)			# carrega o x atual do personagem
	lh t3, 2(t0)
	la t2,OLD_CHAR_POS
	sh t1, 0(t2)	
	sh t3, 2(t2)
	addi t1, t1, -16
	ble t1, t4, PULA_COLISAO_ESQUERDA # if t1 < zerot1 then target
	sh t1, 0(t0)    		# salva novo x em char_pos

PULA_COLISAO_ESQUERDA:	
	
	ret
	
CHAR_DIR:
	# right colision = current map data +4 

	#  CHECA SE x >= colisao do mapa atual de baixo
	addi sp, sp, -4
	sw ra, 0(sp)
	call GET_DATA_FROM_MAP
	lw ra, 0(sp)
	addi sp, sp, 4
	# a0 = adress of map
	addi a0, a0, 4
	lh t4, 0(a0)


	la t0, 	CHAR_POS
	lh t1, 0(t0)			# carrega o x atual do personagem
	lh t3, 2(t0)

	la t2, OLD_CHAR_POS
	sh t1, 0(t2)	
	sh t3, 2(t2)	


	# salva a posicao atual do personagem em OLD_CHAR_POS
	addi t1, t1, 16 		# incrementa 16
	bge t1, t4, PULA_COLISAO_DIREITA 
	sh t1, 0(t0)    		# salva novo x em char_pos
PULA_COLISAO_DIREITA:	

	ret
	
																																											
CHAR_CIMA:
	# top colision = current map data + 8

	#  CHECA SE y >= colisao do mapa atual de baixo
	addi sp, sp, -4
	sw ra, 0(sp)
	call GET_DATA_FROM_MAP
	lw ra, 0(sp)
	addi sp, sp, 4
	# a0 = adress of map
	addi a0, a0, 6
	lh t4, 0(a0)

	la t0,CHAR_POS
	lh t1, 0(t0)			# carrega o x atual do personagem
	lh t3, 2(t0)

	la t2, OLD_CHAR_POS
	sh t1, 0(t2)	
	sh t3, 2(t2)	

	lh t1, 2(t0)				# carrega y
	addi t1,t1,-16				# decrementa 16 pixeis

	ble t1, t4, PULA_COLISAO_CIMA # if t1 < zerot1 then target
	sh t1,2(t0)		    		# salva y
PULA_COLISAO_CIMA:	
	ret
	
					
CHAR_BAIXO:
	# bottom colision = current map data + 8

	#  CHECA SE y >= colisao do mapa atual de baixo
	addi sp, sp, -4
	sw ra, 0(sp)
	call GET_DATA_FROM_MAP
	lw ra, 0(sp)
	addi sp, sp, 4
	# a0 = adress of map
	addi a0, a0, 8
	lh t4, 0(a0)

	la t0,CHAR_POS
	lh t1, 0(t0)    			# carrega x atual
	lh t3, 2(t0)				# carrega o y atual


	la t2,OLD_CHAR_POS
	sh t1, 0(t2)				
	sh t3, 2(t2)				# salva a posicao atual do personagem em OLD_CHAR_POS


	lh t1, 2(t0)				# carrega y
	addi t1,t1,16				# incrementa 16 pixeis


	# li t4, 240
	bge t1, t4, PULA_COLISAO_BAIXO # if t1 < zerot1 then target
	sh t1,2(t0)			  		# salva y
PULA_COLISAO_BAIXO:	

	ret						


    
#  SET CURRENT FRAME TO 1

RESET_FRAME:
	li  t5, 1
	mv t4, t5
	j PULA_SOMA_FRAME

							




