.data
.include "../sprites/menu/menu_1.s"
.include "../sprites/menu/menu_2.s"
.include "../sprites/menu/menu_3.s"
.include "../sprites/misc/pokemonbox.s"

pokemonselectstr: .ascii "Select This Pokemon?"
RA_STACK_MENU: .word 0

pokemonselectstr1: .ascii "Press Z or X."
pss1: .byte 0
pokemonselectstr2: .ascii "Congratulations for your new"
pss2: .byte 0
pokemonselectstr3: .ascii "You're full of Pokemons!"
pss3: .byte 0
pokemonselectstr4: .ascii "Pokemon already in party!"
pss4: .byte 0





.text

MENU:	
		addi sp, sp, -4
		sw ra, 0(sp)
		#  print menu 1

		la a0, menu_1
		li a1, 0
		li a2, 0
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		# call PLAY_INTRO
		mv s0, ra
MENU_LOOP:
		
	

		call KEYMENU
		mv ra, s0
	
        li t1,0xFF000000	        # endereco inicial da Memoria VGA - Frame 0
        li t2,0xFF012C00	    # endereco final 
        la s1,menu_2		    # endereço dos dados da tela na memoria
        addi s1,s1,8		    # primeiro pixels depois das informações de nlin ncol


LOOP_MENU_2:
     	    beq t1,t2,LEAVE_LOOP_2	
                                    # Se for o último endereço então sai do loop
            lw t3,0(s1)		        # le um conjunto de 4 pixels : word
            sw t3,0(t1)		        # escreve a word na memória VGA
            addi t1,t1,4		    # soma 4 ao endereço
            addi s1,s1,4
            j LOOP_MENU_2  

LEAVE_LOOP_2:
			
			li a0, 1000
			call SLEEP
			mv ra, s0


            li t1,0xFF000000	        	# endereco inicial da Memoria VGA - Frame 0
            li t2,0xFF012C00	    		# endereco final 
            la s1,menu_3		    	# endereço dos dados da tela na memoria
            addi s1,s1,8		    	# primeiro pixels depois das informações de nlin ncol



LOOP_MENU_3:
     	    beq t1,t2,LEAVE_LOOP_3	
                                    # Se for o último endereço então sai do loop
            lw t3,0(s1)		        # le um conjunto de 4 pixels : word
            sw t3,0(t1)		        # escreve a word na memória VGA
            addi t1,t1,4		    # soma 4 ao endereço
            addi s1,s1,4
            j LOOP_MENU_3  

LEAVE_LOOP_3:
	
			li a0, 500
			call SLEEP
			mv ra, s0


j MENU_LOOP



KEYMENU:
		li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001			# mascara o bit menos significativo
   		beq t0,zero,FIM_key_menu   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  				# le o valor da tecla tecla
		
		li t0,'z'
		beq t2,t0,CONTINUE_MENU		
		
		
FIM_key_menu:		ret				# retorna

CONTINUE_MENU:
	call PLAY_SELECT
	lw ra, 0(sp)
	addi sp, sp, 4
	ret




POKEMON_SELECT_MENU:
	# a0 =  index of pokemon that can be selected
	# a0 = index

	addi sp, sp, -8
	sw ra, 0(sp)
	sw a0, 4(sp) # store the index also
	# print white box
	la a0, pokemonbox
	li a1, 72
	li a2, 48
	li a3, 1
	call PRINT
	li a3, 0
	call PRINT
	# print  pokemon sprite (96x96) unfortenetely

	lw a0, 4(sp)
	call GET_FRIENDLY_POKEMON_IMAGE_ADRESS
	li a1, 108
	li a2, 70
	li a3, 1
	call PRINT
	li a3, 0
	call PRINT




PSSMLOOP:
	# loop to select pokemon
	# print textbox "Select this pokemon?"
	call KEYPSM
	li t0, 5
	beq t0, a0, PSMEND
	la a0, pokemonselectstr
	call PRINTBOX
	li a0, 1000
	call SLEEP



	## if selected -> add to heropokemons (store it and increment it based on current ammount) 
	# (if more than 3 pokemons -> print you already choose)
j PSSMLOOP

PSMEND:
	lw ra, 0(sp)
	addi sp, sp, 8
	ret


KEYPSM:
		li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001			# mascara o bit menos significativo
   		beq t0,zero,FIM_KEYPSM  	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  				# le o valor da tecla tecla
		
		li t0,'z'
		beq t2,t0,SELECT_POKEMON_OPTION	

		li t0,'x'
		beq t2,t0,DONT_SELECT_POKEMON		
		
		
FIM_KEYPSM:		ret				# retorna



SELECT_POKEMON_OPTION:
	# PRINT POKEMON SELECTED
	lw s9, 4(sp)  # pokemon index = s9

	addi sp, sp, -4
	sw ra, 0(sp)


	# check if current selected pokemon already is selected:
	mv a0, s9
	call CHECK_POKEMON_ALREADY_SELECTED
	li t0, 1

	bne t0, a0, SLPONF0
	
	#print  "pokemon already selected"
		la a0, pokemonselectstr4
		call PRINTBOX
		li a0, 1000
		call SLEEP
	j SELECT_POKEMON_OPTION_END

SLPONF0:
	# check if all pokemons are selected:
	call CHECK_ALL_POKEMONS_SELECTED
	# # if true -> print all popkemons selected and return
	li t0, 1

	bne t0, a0, SLPONF
	la a0, pokemonselectstr3
	call PRINTBOX
	li a0, 750
	call SLEEP
	j SELECT_POKEMON_OPTION_END
	
SLPONF:
 	# TODO: play sound:

	# now we update the heropokemons data-> 
	mv a0, s9
	call SET_NEW_POKEMON

# print first pokemon for debug
la t0, heropokemons
lh t1, 2(t0)
mv a0, t1
li a7, 1
ecall

	la a0, pokemonselectstr2
	call PRINTBOX
	li a0, 750
	call SLEEP
	mv a0, s9
	call GET_POKEMON_STRING
	call PRINTBOX
	li a0, 750
	call SLEEP




SELECT_POKEMON_OPTION_END:
	lw ra, 0(sp)
	addi, sp, sp,4
	li a0, 5
	ret


DONT_SELECT_POKEMON:
	li a0, 5
	ret