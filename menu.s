.data
.include "sprites/menu/menu_1.data"
.include "sprites/menu/menu_2.data"
.include "sprites/menu/menu_3.data"
RA_STACK_MENU: .word 0

.text

MENU:
		mv s0, ra
		la t1, RA_STACK_MENU
		mv t0, ra
		sw t0, 0(t1)

	
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

SLEEP1:
	
	li t0, 0 # i = 0
	li t1, 0x0000ffff

	LOOPSLEEP:
	beq t0, t1, OUTSLEEP1
	addi t0, t0, 1
	j LOOPSLEEP

OUTSLEEP1:

SLEEP2:
	
	li t0, 0 # i = 0
	li t1, 0x0000ffff

	LOOPSLEEP2:
	beq t0, t1, OUTSLEEP2
	addi t0, t0, 1
	j LOOPSLEEP2

OUTSLEEP2:



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
	
	
	
SLEEP3:
	
	li t0, 0 # i = 0
	li t1, 0x00000fff

	LOOPSLEEP3:
	beq t0, t1, OUTSLEEP3
	addi t0, t0, 1
	j LOOPSLEEP3

OUTSLEEP3:
J MENU



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
	mv ra, s0
	ret



