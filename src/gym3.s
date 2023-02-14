.data
NPC2STR1: .ascii "Defeat the second gym first!"
NPC2CURRENTSTR: .half 2
NPC2STR2: .ascii "You defeated all gyms..."
NPC2SSTR2: .byte 0
NPC2STR3: .ascii "You are a worthy opponent..."
NPC2STR4: .ascii "But i have all kinds of pokemons"
NPC2SSTR3: .byte 0
NPC2STR5: .ascii "And they're much stronger..."
NPC2SSTR4: .byte 0
NPC2STR6: .ascii "If you beat me you're a true"
NPC2SSTR5: .byte 0
NPC2STR7: .ascii "Pokemon Champion!!"
NPC2SSTR7: .byte 0
NPC2STR8: .ascii "Good Luck!"
NPC2SSTR8: .byte 0
NPC2STR9: .ascii "You already beated me!"
NPC2SSTR9: .byte 0

.text

START_GYM_3:
    addi sp, sp, -4
    sw ra, 0(sp)

    # check if gym 2 was beaten (checkpoint >= 2)
    la t0, checkpoint
    lh t1, 0(t0)
    li t2, 1
    bgt t1, t2, SG3BG1
    # print( you have to defeat the first gym)
    la a0, NPC2STR1
    call PRINTBOX
    li a0, 1000
    call SLEEP
    li a0, 250
    call SLEEP
    j SG3END
SG3BG1:
    # gym 3 hasnt been defeated yet
    # story and battle time
    # loop 1:
    # story of gym 3:
    la t0, NPC2CURRENTSTR
    lh a0, 0(t0)
    call GET_NPC_2_STR
    li a7, 4
    ecall
    call PRINTBOX

    SGYM3LOOP:
    call KEYGYM3NMENU
    li t0, 5
	beq t0, a0, SG3END

    j SGYM3LOOP


SG3END:
    lw ra, 0(sp)
    addi sp, sp,4
    ret


KEYGYM3NMENU:
		li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001			# mascara o bit menos significativo
   		beq t0,zero,FIM_KEYGYM3NMENU 	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  				# le o valor da tecla tecla
		
		li t0,'z'
		beq t2,t0,SELECT_KEY_GYM3_MENU	

		li t0,'x'
		beq t2,t0,GO_BACK_KEYGYM3NMENU		
		
		
FIM_KEYGYM3NMENU:		ret				# retorna

GO_BACK_KEYGYM3NMENU:
    li a0, 5
    la t0, NPC2CURRENTSTR
    li t1, 2
    sh t1, 0(t0)
    ret


SELECT_KEY_GYM3_MENU:
addi sp, sp, -4
sw ra, 0(sp)


    la t0, NPC2CURRENTSTR
    lh t1, 0(t0)
    li t2, 8 # t0 = max npc str
    bne t1, t2, SKNMNS3
    # final string
    # set current enemy top npc 2
    la t0, current_enemy
    li t1, 2
    sh t1, 0(t0) # CURRENT ENEMY = 2


    # HEAL venusaur and snorlax (todo: fix this lol)
    li a0, 1 #venusaur id
    call GET_CURRENT_POKEMON_DATA
    # a0 = adress of venusaur
    # a0 + 2 = current hp, a0 + 4 =total hp
    lh t1, 4(a0) # gett full hp
    sh t1, 2(a0) # save in current hp

    li a0, 7 # snorlax id
    call GET_CURRENT_POKEMON_DATA
    # a0 = adress of venusaur
    # a0 + 2 = current hp, a0 + 4 =total hp
    lh t1, 4(a0) # gett full hp
    sh t1, 2(a0) # save in current hp




    call START_BATTLE

    j SELECT_KEY_NPC_MENU_END3

SKNMNS3:
# select key npc menu next string:
    addi t1, t1, 1
    sh t1, 0(t0)
    mv a0, t1
    call GET_NPC_2_STR
    call PRINTBOX


SELECT_KEY_NPC_MENU_END3:
lw ra, 0(sp)
addi sp, sp, 4
ret

