.data
.include "../sprites/characters/gym1npc.s"s
current_npc: .half 0
checkpoint: .half 0
NPC0STR1: .ascii "Come back when you have"
NPC0SSTR1: .byte 0
NPC0STR2: .ascii "All your pokemons!"
NPC0SSTR2: .byte 0
NPC0STR3: .ascii "You have all your pokemons..."
NPC0CURRENTSTR: .half 3
NPC0STR4: .ascii "I'm the Normal Type leader"
NPC0SSTR3: .byte 0
NPC0STR5: .ascii "I'm the weakest here and"
NPC0SSTR4: .byte 0
NPC0STR6: .ascii "I only have one pokemon."
NPC0SSTR5: .byte 0
NPC0STR7: .ascii "Consider this your training."
NPC0SSTR7: .byte 0
NPC0STR8: .ascii "Good Luck!"
NPC0SSTR8: .byte 0
NPC0STR9: .ascii "You already beated me!"
NPC0SSTR9: .byte 0

.text

GET_NPC_IMAGE_ADRESS:
# a0 = index of npc
    li t0, 0
    bne t0, a0, GNPIA0
    la a0, gym1npc
    ret
GNPIA0:
    la a0, gym1npc
    ret


PRINT_NPC:
addi sp, sp, -4
sw ra, 0(sp)
# a0 = index of npc to be printed (fixed top of gym)
        call GET_NPC_IMAGE_ADRESS
        # a0 = adress
        li a1, 148
        li a2, 80
        li a3, 0
        call PRINT
        li a3, 1
        call PRINT


lw ra, 0(sp)
addi sp, sp, 4
ret


START_GYM_1:
addi sp, sp, -4
sw ra, 0(sp)
    # VOID EVENT TO START BATTLE OF GYM 1

    ##  if  character doesnt have 3 pokemons -> print "Come back when you have all your pokemons!"

call CHECK_ALL_POKEMONS_SELECTED
    # a0 == boolean representing if all 3 pokemons are  selected
    bne a0, zero, SGYM1APS
    # pokemons not selected
    la a0, NPC0STR1
    call PRINTBOX
    li a0, 750
    call SLEEP
    la a0, NPC0STR2
    call PRINTBOX
    li a0, 1000
    call SLEEP
    j SGYM1END
SGYM1APS:
## if ccharacter already defeated this gym -> print "you already defeated me!"
    la t0, checkpoint
    lh t1, 0(t0)
    beq t1, zero,SGYM2APS # if checkpoint == 0 -> player hasnt defeated yet
    # player already defeated gym leader:
    # set current str to 9
    li a0, 9
    call GET_NPC_0_STR
    call PRINTBOX
    li a0, 1000
    call SLEEP
    j SGYM1END

SGYM2APS:
    # loop 1:
    # story of gym 1:
    la t0, NPC0CURRENTSTR
    lh a0, 0(t0)
    call GET_NPC_0_STR
    call PRINTBOX
    SGYM1LOOP:
    call KEYNPCMENU
    li t0, 5
	beq t0, a0, SGYM1END

    j SGYM1LOOP

SGYM1LOOPEND:
    
SGYM1END:
lw ra, 0(sp)
addi sp, sp, 4
ret


GET_NPC_0_STR:
    # A0 = CURRENT inde
    li t0, 1
    bne a0, t0, GN0S1
    la a0, NPC0STR1
    ret
GN0S1:
    addi t0, t0, 1
    bne a0, t0, GN0S2
    la a0, NPC0STR2
    ret
GN0S2:
    addi t0, t0, 1
    bne a0, t0, GN0S3
    la a0, NPC0STR3
    ret
GN0S3:
    addi t0, t0, 1
    bne a0, t0, GN0S4
    la a0, NPC0STR4
    ret
GN0S4:
    addi t0, t0, 1
    bne a0, t0, GN0S5
    la a0, NPC0STR5
    ret
GN0S5:
    addi t0, t0, 1
    bne a0, t0, GN0S6
    la a0, NPC0STR6
    ret
GN0S6:
    addi t0, t0, 1
    bne a0, t0, GN0S7
    la a0, NPC0STR7
    ret
GN0S7:
    addi t0, t0, 1
    bne a0, t0, GN0S8
    la a0, NPC0STR8
    ret
GN0S8:
    addi t0, t0, 1
    bne a0, t0, GN0S9
    la a0, NPC0STR9
    ret
GN0S9:
    la a0, NPC0STR1
    ret



KEYNPCMENU:
		li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001			# mascara o bit menos significativo
   		beq t0,zero,FIM_KEYNPCMENU 	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  				# le o valor da tecla tecla
		
		li t0,'z'
		beq t2,t0,SELECT_KEY_NPC_MENU	

		li t0,'x'
		beq t2,t0,GO_BACK_KNPCM		
		
		
FIM_KEYNPCMENU:		ret				# retorna


GO_BACK_KNPCM:
    la t0, NPC0CURRENTSTR
    li t1, 3
    sh t1, 0(t0)
    li a0, 5
    ret


SELECT_KEY_NPC_MENU:
addi sp, sp, -4
sw ra, 0(sp)


    la t0, NPC0CURRENTSTR
    lh t1, 0(t0)
    li t2, 8 # t0 = max npc str
    bne t1, t2, SKNMNS
    # final string
    call START_BATTLE

    j SELECT_KEY_NPC_MENU_END

SKNMNS:
# select key npc menu next string:
    addi t1, t1, 1
    sh t1, 0(t0)
    mv a0, t1
    call GET_NPC_0_STR
    call PRINTBOX


SELECT_KEY_NPC_MENU_END:
lw ra, 0(sp)
addi sp, sp, 4
ret