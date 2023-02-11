.data
.include "../sprites/menu/menu_1.s"
.include "../sprites/menu/menu_2.s"
.include "../sprites/menu/menu_3.s"

RA_STACK_MENU: .word 0

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

