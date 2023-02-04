.text
ATTACK_MENU:
    addi sp, sp, -4
    sw ra, 0(sp)

    li a7, 4
    la a0, debug
    ecall
    # new menu loop,
    # remember: if user press b, we need to reprint the old menu and set all variables.
    call PRINTATTACKMENU

ATTACKMENULOOP:



    call KEYATTACKMENU

    li t0, 5
       beq t0, a0, ENDAM

j ATTACKMENULOOP


ENDAM:


    lw ra, 0(sp)
    addi sp, sp, 4
    
    ret


KEYATTACKMENU:
		li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001			# mascara o bit menos significativo
   		beq t0,zero,FKAM   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  				# le o valor da tecla tecla
		
		li t0,'x'
		beq t2,t0,PRINT_BACK_MENU		
		
		
FKAM:		ret				# retorna




PRINTATTACKMENU:

    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, attackmenubg
    # MENU FIXED POSITION: 156,166
    li a1, 156
    li a2, 166
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

PRINT_BACK_MENU:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, battlemenu
    # MENU FIXED POSITION: 156,166
    li a1, 156
    li a2, 166
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT
    li a0, 5

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

