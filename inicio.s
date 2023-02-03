.data
msg0: .ascii "Pokemon POKEMON pokemon"
current_index_msg: .byte 0
msg1: .ascii "Mais texto pra historia\n"

#skip data segment bug
msg1b: .byte 0
msg2: .ascii "  MAIS TEXTO PRA HISTORIA 2\n"

STASH: .word 0

.text

INICIO_JOGO:


#  ra stash
    la      t0, STASH
    sw      ra, 0(t0)                      # 4-byte Folded Spill

    # print bg
    la a0, oakbg
	li a1, 0
	li a2, 0
	li a3, 0
	call PRINT # print base
	li a3, 1
	call PRINT  # print base



	# print oak with base:
	la a0, baseround
	li a1, 152
	li a2, 136
	li a3, 0
	call PRINT # print base
	li a3, 1
	call PRINT  # print base

	# print oak
	la a0, oak_full
	li a1, 160
	li a2, 64
	li a3, 0
	call PRINT # print base
	li a3, 1
	call PRINT  # print base


	# print text box explaining the game


	call GET_CURRENT_INICIO_MSG
	call PRINTBOX

INICIO_TEXT:
    call KEY_INICIO
    
    li t0, 3
    beq s6, t0, END_INICIO

    beq s6, zero, NAO_IMPRIMIR_PROXIMA_CAIXA
        call GET_CURRENT_INICIO_MSG
	    call PRINTBOX
        mv s6, zero
NAO_IMPRIMIR_PROXIMA_CAIXA:

    j INICIO_TEXT



GET_CURRENT_INICIO_MSG:
    la t0, current_index_msg
    lb t1, 0(t0)
    bne t1, zero, PULA_MSG_0
    la a0, msg0
    ret
PULA_MSG_0:
    li t2, 1
    bne t1, t2, PULA_MSG_1
    la a0, msg1
    ret

PULA_MSG_1:
    li t2, 2
    bne t1, t2, PULA_MSG_2
    la a0, msg2
    ret

PULA_MSG_2:
    # default will be msg 1:
    la a0, msg0
    ret





KEY_INICIO:
		li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001			# mascara o bit menos significativo
   		beq t0,zero,FIM_key_inicio   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  				# le o valor da tecla tecla
		
		li t0,'z'
		beq t2,t0,PROXIMA_MENSAGEM		
		
		
FIM_key_inicio:	
    mv s0, zero
	ret				# retorna

PROXIMA_MENSAGEM:

    la t0, current_index_msg
    lb t1, 0(t0)
    addi t1, t1, 1

    # max msg == 2
    li t2, 2
    bgt t1, t2, RESETA_MENSAGEM
    sb t1, 0(t0)
    li s6, 1
    ret


RESETA_MENSAGEM:
    	li s6, 3
        # a0 == 3 -> ended inicio
        ret


END_INICIO:    
    la     t0, STASH
    lw ra, 0(t0)                      # 4-byte Folded Spill
	ret
