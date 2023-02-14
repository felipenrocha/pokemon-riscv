.data
.include "../sprites/backgrounds/switchbg.s"
.include "../data/heropokemons.s"

current_menu_switch: .half 0
switchnotallowedstr: .ascii "Not Allowed! \n"
separatorswitch0: .half 0
switchnotallowedst1r: .ascii "Pokemon is fainted!\n"
separatorswitch1: .half 0

.text
# procedures to implement the switch pokemon system


POKEMON_SWITCH_MENU:
    addi sp, sp, -4
    sw ra, 0(sp)

    # PRINT POKEMON SWITCH MENU

    # print list of pokmemons of user,
    # interface to interact between them
    # when a pokemon is selected then the pokemon is switched
    ## if x is pressed then well go back with same pokemon ( i guess its easier to reprint the whole battle
    # battle since the hp is stored in memory anyways.

    # print inventory bg:
    call SETUP_SWITCH_BG
    call PRINTSWITCHNAMES
    
    PSMLOOP:
    # menu loop
    call KEYSWITCHMENU
        li t0, 5 #CHECK IF X WAS PRESSED TO GO BACK
        beq a0, t0, FIMSWITCHMENU
        bne a0, zero, NO_CLEAR_ARROW_MENU
        call CLEAR_ARROW_MENU_SWITCH
NO_CLEAR_ARROW_MENU:

    
        # well net to animate an arrow and and option that will store whic pokemon is selected
        #  PRINT ARROW BASED ON CURRENT OPTION 
        call PRINT_SWITCH_ARROW


    j PSMLOOP




FIMSWITCHMENU:
    call SETUP_BATTLE
    lw ra, 0(sp)
    addi sp, sp, 4
    ret




PRINTSWITCHNAMES:
    addi sp, sp, -4
    sw ra, 0(sp)
    # print on screen name of all heros pokemons (void)
    # load players pokemons
    la t0, heropokemons
    # pokemon index 0 == 2(t0)
    lh t1, 2(t0)
    # mv s2, t1
    mv a0, t1 # a0 == idnex of pokemon on position 0 in menu

    call GET_POKEMON_STRING
    # a0 = string to be printed
    mv s2, a0
    li a1, 32
    li a2, 32
    li a3, 0xc700
    li a4, 0
    li a7, 104
    ecall
    mv a0, s2
    li a4, 1
    ecall


#  print next pokemon name
    la t0, heropokemons
    # pokemon index 0 == 2(t0)
    lh t1, 4(t0)
    # mv s2, t1
    mv a0, t1 # a0 == idnex of pokemon on position 0 in menu

    call GET_POKEMON_STRING
    # a0 = string to be printed
    mv s2, a0
    li a1, 32
    li a2, 52
    li a3, 0xc700
    li a4, 0
    li a7, 104
    ecall
    mv a0, s2
    li a4, 1
    ecall
#  print next pokemon name
    la t0, heropokemons
    # pokemon index 0 == 2(t0)
    lh t1, 6(t0)
    # mv s2, t1
    mv a0, t1 # a0 == idnex of pokemon on position 0 in menu

    call GET_POKEMON_STRING
    # a0 = string to be printed
    mv s2, a0
    li a1, 32
    li a2, 72
    li a3, 0xc700
    li a4, 0
    li a7, 104
    ecall
    mv a0, s2
    li a4, 1
    ecall
# #  print next pokemon name
#     la t0, heropokemons
#     # pokemon index 0 == 2(t0)
#     lh t1, 8(t0)
#     # mv s2, t1
#     mv a0, t1 # a0 == idnex of pokemon on position 0 in menu

#     call GET_POKEMON_STRING
#     # a0 = string to be printed
#     mv s2, a0
#     li a1, 32
#     li a2, 92
#     li a3, 0xc700
#     li a4, 0
#     li a7, 104
#     ecall
#     mv a0, s2
#     li a4, 1
#     ecall

# #  print next pokemon name
#     la t0, heropokemons
#     # pokemon index 0 == 2(t0)
#     lh t1, 10(t0)
#     # mv s2, t1
#     mv a0, t1 # a0 == idnex of pokemon on position 0 in menu

#     call GET_POKEMON_STRING
#     # a0 = string to be printed
#     mv s2, a0
#     li a1, 32
#     li a2, 112
#     li a3, 0xc700
#     li a4, 0
#     li a7, 104
#     ecall
#     mv a0, s2
#     li a4, 1
#     ecall

# #  print next pokemon name
#     la t0, heropokemons
#     # pokemon index 0 == 2(t0)
#     lh t1, 12(t0)
#     # mv s2, t1
#     mv a0, t1 # a0 == idnex of pokemon on position 0 in menu

#     call GET_POKEMON_STRING
#     # a0 = string to be printed
#     mv s2, a0
#     li a1, 32
#     li a2, 132
#     li a3, 0xc700
#     li a4, 0
#     li a7, 104
#     ecall
#     mv a0, s2
#     li a4, 1
#     ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    ret




KEYSWITCHMENU:
		li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001			# mascara o bit menos significativo
   		beq t0,zero,FIMKEYSWITCHMENU   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  				# le o valor da tecla tecla
		
		li t0,'x'
		beq t2,t0,GO_BACK_SWITCH_MENU		
        
        li t0,'d'
		beq t2,t0,SWITCH_NEXT_OPTION
                
        li t0,'a'
		beq t2,t0,SWITCH_PREVIOUS_OPTION	

        li t0,'z'
		beq t2,t0,SELECT_SWITCH_OPTION
		
		
FIMKEYSWITCHMENU:
		ret				# retorna

GO_BACK_SWITCH_MENU:
    li a0, 5
    ret

SWITCH_NEXT_OPTION:
    # add menu option by 1 up to 5 (0-5 pokemon)
    la t0, current_menu_switch
    lh t1, 0(t0)
    addi t1, t1, 1

    li a7,1
    mv a0, t1
    ecall

    li t2, 5
    bgt t1, t2, RESET_SWITCH_OPTION1
    sh t1, 0(t0)
    li a0, 0
    ret

RESET_SWITCH_OPTION1:
    # store current option as 0
    li t1, 0
    sh t1, 0(t0)
    li a0, 0
    ret


SWITCH_PREVIOUS_OPTION:
    # add menu option by 1 up to 5 (0-5 pokemon)
    la t0, current_menu_switch
    lb t1, 0(t0)
    addi t1, t1, -1
    li t2, 0

    li a7,1
    mv a0, t1
    ecall

    blt t1, t2, RESET_SWITCH_OPTION2
    sb t1, 0(t0)
    li a0, 0

    ret
RESET_SWITCH_OPTION2:
    # store current option as 5
    li t1, 5
    sb t1, 0(t0)
    li a0, 0

    ret




SELECT_SWITCH_OPTION:
    addi sp, sp, -4
    sw ra, 0(sp)
    call PLAY_SELECT

# SELECT_SWITCH_OPTION beggining
SWOB:
    #   Change value of current friendly pokemon index based on option
    # index of pokemon will be: heropokemons + 4 + index*2

    la t0, current_menu_switch
    # index of menu
    lh t1, 0(t0)
    #  index * 2
    slli t1, t1, 1



    la t2, heropokemons
    addi t2, t2, 2
    # t2 = adress pokemon[0]

   



    add t2, t2, t1
    #  t2 =  adress of pokemon[index menu]

    lh t1, 0(t2) 
    #  t1 = index of pokemon selected
    mv s6, t1

    #  CHECK IF pokemon is dead:
    mv a0, t1
    call CHECK_POKEMON_DEAD
    # a0 == 1 if pokemon is dead and 0 if not
    beq a0, zero, SWOND
    # POKEMON is dead ( u cant choose ) 
    #  print you cant choose this pokemon!
    la a0, switchnotallowedstr
    call PRINTBOX
    li a0, 500
    call SLEEP
    la a0, switchnotallowedst1r
    call PRINTBOX


    lw ra, 0(sp)
    addi sp, sp, 4
    ret

SWOND:
    la t0, current_friendly_pokemon
    mv t1, s6
    sh t1, 0(t0)
    li a0, 5
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

SETUP_SWITCH_BG:

    addi sp, sp -4
    sw ra, 0(sp)

    la a0, switchbg
    li a1, 0
    li a2, 0
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT

    lw ra 0(sp)
    addi, sp, sp, 4

    ret


PRINT_SWITCH_ARROW:
    addi sp, sp, -4
    sw ra, 0(sp)

    #  clear all arrows:

    #print line of color 

    # print arrow based om menuswitch position

    li a1, 8
    call GET_ARROW_Y_MENU_POS
    mv a2, a0
    la a0, arrow2
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

GET_ARROW_Y_MENU_POS:
    # position yi = 30 + 20*i (i == menu selected position)
    la t0, current_menu_switch
    lh t1, 0(t0)
    li t3, 20
    mul t1, t1,t3
    addi t1, t1, 30
    mv a0, t1
    ret


CLEAR_ARROW_MENU_SWITCH:
    addi sp, sp, -4
    sw ra, 0(sp)

    # drawn column of color 73
    # ecall drawline
    
    li a0, 4
    li a2, 20

    li a1, 28
    li a3, 28
    li a5,0
    li a4, 0x59
    li a7,47

    # contadores
    li s0, 0
    li s1, 128

CAMSL:
    beq s0, s1, CAMS0
        addi s0, s0, 1
        addi a1, a1, 1
        addi a3, a3, 1
        ecall
        xori a5, a5, 1
        ecall

    j CAMSL

CAMS0:

    lw ra, 0(sp)
    addi sp,sp,4
    ret


