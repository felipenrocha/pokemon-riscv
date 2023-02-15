.data
msg0: .ascii "Welcome to Pokemon!"
current_index_msg: .byte 0
msg1: .ascii "This game is different...\n"

#skip data segment bug
msg1b: .byte 0
msg2: .ascii "You'll Choose 3 pokemons!\n"
msg2b:.byte 0
msg3: .ascii "And fight 3 gym leaders!\n"
msg3b:.byte 0
msg4: .ascii "You have unlimited Pots!\n"
msg4b:.byte 0
msg5: .ascii "Pots are used in battle(only)\n"
msg5b:.byte 0
msg6: .ascii "After each battle,\n"
msg6b:.byte 0
msg7: .ascii "Your pokemons will recover!\n"
msg7b:.byte 0
msg8: .ascii "If all your Pokemons faint\n"
msg8b:.byte 0
msg9: .ascii "You'll Lose!\n"
msg9b:.byte 0
msg10: .ascii "And start all over again.\n"
msg10b:.byte 0
msg11: .ascii "If you beat them all\n"
msg11b:.byte 0
msg12: .ascii "You WIN!\n"
msg12b:.byte 0
msg13: .ascii "Just a reminder...\n"
msg13b:.byte 0
msg14: .ascii "Your pokemons faint at 2HP\n"
msg14b:.byte 0
msg15: .ascii "Good Luck!!!!\n"
msg15b:.byte 0
msg16: .ascii "You've Beaten the Game!\n"

msg16b:.byte 0
msg17: .ascii "Congratulations! \n"

msg17b:.byte 0
msg18: .ascii "Here is your cookie:\n"





.text

INICIO_JOGO:

    addi    sp, sp, -4
    sw      ra, 0(sp)  

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
    
    li t0, 15
    beq s6, t0, END_INICIO

    beq s6, zero, NAO_IMPRIMIR_PROXIMA_CAIXA
        call GET_CURRENT_INICIO_MSG
	    call PRINTBOX
        mv s6, zero
NAO_IMPRIMIR_PROXIMA_CAIXA:

    j INICIO_TEXT








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

    addi sp, sp, -4
    sw ra, 0(sp)
    call PLAY_SELECT
    lw ra, 0(sp)
    addi sp, sp, 4

    la t0, current_index_msg
    lb t1, 0(t0)
    addi t1, t1, 1

    # max msg == 2
    li t2, 15
    bgt t1, t2, RESETA_MENSAGEM
    sb t1, 0(t0)
    li s6, 1

    ret


RESETA_MENSAGEM:
    	li s6, 15
        # a0 == 3 -> ended inicio
        ret


END_INICIO:
    lw      ra, 0(sp)                      # 4-byte Folded Reload
    addi    sp, sp, 4    
	ret














GET_CURRENT_INICIO_MSG:
    li t2, 0 
    la t0, current_index_msg
    lb t1, 0(t0)
    bne t1, t2, PULA_MSG_0
    la a0, msg0
    ret
PULA_MSG_0:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_1
    la a0, msg1
    ret

PULA_MSG_1:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_2
    la a0, msg2
    ret
PULA_MSG_2:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_3
    la a0, msg3
    ret
PULA_MSG_3:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_4
    la a0, msg4
    ret
PULA_MSG_4:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_5
    la a0, msg5
    ret
PULA_MSG_5:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_6
    la a0, msg6
    ret
PULA_MSG_6:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_7
    la a0, msg7
    ret
PULA_MSG_7:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_8
    la a0, msg8
    ret
PULA_MSG_8:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_9
    la a0, msg9
    ret
PULA_MSG_9:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_10
    la a0, msg10
    ret
PULA_MSG_10:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_11
    la a0, msg11
    ret
PULA_MSG_11:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_12
    la a0, msg12
    ret
PULA_MSG_12:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_13
    la a0, msg13
    ret
PULA_MSG_13:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_14
    la a0, msg14
    ret
PULA_MSG_14:
    addi t2, t2, 1
    bne t1, t2, PULA_MSG_15
    la a0, msg15
    ret
PULA_MSG_15:
    # default will be msg 1:
    la a0, msg0
    ret



END_GAME: 
# game beaten
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

    la a0, msg16
    call PRINTBOX
    li a0, 1000
    call SLEEP

    li a0, 1000
    call SLEEP
    call PLAY_SELECT
    la a0, msg17
    call PRINTBOX
    li a0, 1000
    call SLEEP
    li a0, 1000
    call SLEEP
    call PLAY_SELECT


li a7, 10
ecall