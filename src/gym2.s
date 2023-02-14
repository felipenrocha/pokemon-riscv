.data
NPC1STR1: .ascii "Defeat the first gym to come!"
NPC1CURRENTSTR: .half 2
NPC1STR2: .ascii "You beated the first gym..."
NPC1SSTR2: .byte 0
NPC1STR3: .ascii "Well, im not that easy..."
NPC1STR4: .ascii "You see... Im a Grass Leader"
NPC1SSTR3: .byte 0
NPC1STR5: .ascii "I can damage some of your"
NPC1SSTR4: .byte 0
NPC1STR6: .ascii "Pokemons super effectively"
NPC1SSTR5: .byte 0
NPC1STR7: .ascii "So be careful..."
NPC1SSTR7: .byte 0
NPC1STR8: .ascii "Good Luck!"
NPC1SSTR8: .byte 0
NPC1STR9: .ascii "You already beated me!"
NPC1SSTR9: .byte 0

.text

START_GYM_2:
    addi sp, sp, -4
    sw ra, 0(sp)

    # check if gym 1 was beaten (checkpoint > 0)
    la t0, checkpoint
    lh t1, 0(t0)
    bgt t1, zero, SG2BG1
    # print( you have to defeat the first gym)
    la a0, NPC1STR1
    call PRINTBOX
    li a0, 1000
    call SLEEP
    li a0, 250
    call SLEEP
    j SG2END
SG2BG1:
#start gym 2 already beaten gym 1
## if ccharacter already defeated this gym -> print "you already defeated me!"
    la t0, checkpoint
    lh t1, 0(t0)
    li t2, 1
    ble t1, t2,SGYM22APS # if checkpoint > 1 -> player has been defeated
    # player already defeated gym leader:
    # set current str to 9

    li a0, 9
    call GET_NPC_0_STR
    call PRINTBOX
    li a0, 1000
    call SLEEP
    j SG2END

SGYM22APS:
    # gym 2 hasnt been defeated yet
    # story and battle time

        # loop 1:
    # story of gym 1:
    la t0, NPC1CURRENTSTR
    lh a0, 0(t0)
    call GET_NPC_1_STR
    li a7, 4
    ecall
    call PRINTBOX
SGYM2LOOP:
    call KEYGYM2NMENU
    li t0, 5
	beq t0, a0, SG2END

    j SGYM2LOOP

SG2END:
    lw ra, 0(sp)
    addi sp, sp,4
    ret




GET_NPC_1_STR:
    # A0 = CURRENT inde
    li t0, 1
    bne a0, t0, GN1S1
    la a0, NPC1STR1
    ret
GN1S1:
    addi t0, t0, 1
    bne a0, t0, GN1S2
    la a0, NPC1STR2
    ret
GN1S2:
    addi t0, t0, 1
    bne a0, t0, GN1S3
    la a0, NPC1STR3
    ret
GN1S3:
    addi t0, t0, 1
    bne a0, t0, GN1S4
    la a0, NPC1STR4
    ret
GN1S4:
    addi t0, t0, 1
    bne a0, t0, GN1S5
    la a0, NPC1STR5
    ret
GN1S5:
    addi t0, t0, 1
    bne a0, t0, GN1S6
    la a0, NPC1STR6
    ret
GN1S6:
    addi t0, t0, 1
    bne a0, t0, GN1S7
    la a0, NPC1STR7
    ret
GN1S7:
    addi t0, t0, 1
    bne a0, t0, GN1S8
    la a0, NPC1STR8
    ret
GN1S8:
    addi t0, t0, 1
    bne a0, t0, GN1S9
    la a0, NPC1STR9
    ret
GN1S9:
    la a0, NPC1STR1
    ret




KEYGYM2NMENU:
		li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001			# mascara o bit menos significativo
   		beq t0,zero,FIM_KEYGYM2NMENU 	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  				# le o valor da tecla tecla
		
		li t0,'z'
		beq t2,t0,SELECT_KEY_GYM2_MENU	

		li t0,'x'
		beq t2,t0,GO_BACK_KEYGYM2NMENU		
		
		
FIM_KEYGYM2NMENU:		ret				# retorna

GO_BACK_KEYGYM2NMENU:
    li a0, 5
    la t0, NPC1CURRENTSTR
    li t1, 2
    sh t1, 0(t0)
    ret


SELECT_KEY_GYM2_MENU:
addi sp, sp, -4
sw ra, 0(sp)


    la t0, NPC1CURRENTSTR
    lh t1, 0(t0)
    li t2, 8 # t0 = max npc str
    bne t1, t2, SKNMNS2
    # final string
    # set current enemy top npc 2
    la t0, current_enemy
    li t1, 1
    sh t1, 0(t0)
    
    call START_BATTLE

    j SELECT_KEY_NPC_MENU_END2

SKNMNS2:
# select key npc menu next string:
    addi t1, t1, 1
    sh t1, 0(t0)
    mv a0, t1
    call GET_NPC_1_STR
    call PRINTBOX


SELECT_KEY_NPC_MENU_END2:
lw ra, 0(sp)
addi sp, sp, 4
ret
