.data
# index of current pokemon from character
current_menu_option: .byte 0
# hold status of which menu phase we are: 0: INITIAL, 1: battle phase, 2: bag
current_menu_selected: .byte 0
#indedx for current enemy being battled
current_enemy: .byte 1
debug: .ascii "In"

AM_STASH: .word 0

# index of current pokemon from enemy
.text


START_BATTLE:


    la t0, AM_STASH
    sw ra, 0(t0)

    addi sp, sp, -4
    sw ra, 0(sp)

    #do stuff here

#SETUP START BATTLE:
    # print BACKGROUND:
    la a0, battlebg1
    li a1, 0
    li a2, 0
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT

    # Print friendly and enemy pokemon
    la t0, current_friendly_pokemon
    lb a0, 0(t0)


    call GET_FRIENDLY_POKEMON_IMAGE_ADRESS
    #a0 now has adress of image to be printed
    li a1, 32
    li a2, 154
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT

    # print enemy pokemon
    la t0, current_enemy_pokemon
    lb a0, 0(t0)
    call GET_ENEMY_POKEMON_IMAGE_ADRESS
    #a0 now has adress of image to be printed
    # enemy fixed position: 184, 50
    li a1, 184
    li a2, 50
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT

# PRINT MENU:
    la a0, battlemenu
    # MENU FIXED POSITION: 156,166
    li a1, 156
    li a2, 166
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT


#END SETUP START
call PRINT_BLACK_FRIENDLY_BAR
call PRINT_BLACK_ENEMY_BAR

# now well need a battle loop to see whats going on, navigate thorug menu, etc.


BATTLELOOP:
# first lets add a way to navigate through the menu
#  print a square on the current option:
# we'll use a byte to identify on which option the player is
    call KEYBATTLE
    # 
    # 
    beq a0, zero, NKPB
        call CLEAR_LAST_ARROW
        li a0, 0
    # if keys were pressed, clear all last POSITIONS of arrows
# NO keys pressed:
NKPB:
# void to print current hp bar
    call PRINT_HP_BAR
    
# void to print menu arrow
    call PRINT_MENU_ARROW
        


j BATTLELOOP

# this will return to main 
j END_START_BATTLE


#end battle:
END_START_BATTLE:


    lw ra, 0(sp)
    addi sp, sp, 4
    ret



PRINT_MENU_ARROW:
    addi sp, sp, -4
    sw ra, 0(sp)

    call GET_ARROW_X_POS
    mv a1, a0
    call GET_ARROW_Y_POS
    mv a2, a0
    la a0, arrow
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT

    lw ra, 0(sp)
    addi sp, sp, 4
    ret


GET_ARROW_X_POS:
    la t0, current_menu_option
    # t1 will have current menu option: 0 = fight,  1 = bag, 2 = pokemon, 3 = run
    lb t1, 0(t0)
    # OPTION 0 or 2: x POSITION = FIXED 164
    bne t1, zero, GAXPN0
    li a0, 164
    ret
# GET ARROW X POSITION NOT OPTION 0:
GAXPN0:
    li t2, 1
    bne t1, t2, GAXPN1
    # option 1 = x -> 236
    li a0, 236
    ret
GAXPN1:
    li t2, 2
    bne t1, t2, GAXPN2
    li a0, 164
    ret
GAXPN2:
    li t2, 3
    bne t1, t2, GAXPN3
    li a0, 236
    ret
GAXPN3:
# default:
    li a0, 164
    ret
    




GET_ARROW_Y_POS:
    la t0, current_menu_option
    # t1 will have current menu option: 0 = fight,  1 = bag, 2 = pokemon, 3 = run
    lb t1, 0(t0)
    # OPTION 0 or 1: y POSITION = FIXED 180
    bne t1, zero, GAYPN0
    li a0, 180
    ret
# GET ARROW Y POSITION NOT OPTION 0:
GAYPN0:
    li t2, 1
    # OPTION 2 or 3: y POSITION = FIXED 180
    bne t1,t2, GAYPN1
    li a0, 180
    ret
GAYPN1:
    li t2, 2
    # OPTION 2 or 3: y POSITION = FIXED 180
    bne t1,t2, GAYPN2
    li a0, 200
    ret
GAYPN2:
    li t2, 3
    # OPTION 2 or 3: y POSITION = FIXED 180
    bne t1,t2, GAYPN3
    li a0, 200
    ret
GAYPN3:
# DEFAULT:
    li a0, 180
    ret










KEYBATTLE:
		li t1,0xFF200000			    # carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				        # Le bit de Controle Teclado
		andi t0,t0,0x0001			    # mascara o bit menos significativo
   		beq t0,zero,FIM_MENU_BATTLE   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  				    # le o valor da tecla tecla
		
		li t0,'d'
		beq t2,t0,NEXT_OPTION_MENU_BATTLE	

		li t0,'a'
		beq t2,t0,PREVIOUS_OPTION_MENU_BATTLE	

        li t0,'z'
		beq t2,t0,SELECT_OPTION_MENU_BATTLE	
        
		
FIM_MENU_BATTLE:
        li a0, 0
		ret				# retorna




NEXT_OPTION_MENU_BATTLE:
# add current menu option to 1, if its bigger than 3 return 0
    la t0, current_menu_option
    lb t1, 0(t0)

    addi t1,t1,1


    li t2, 3
    bgt t1,t2,NOMB1 
    sb t1, 0(t0)
    li a0, 1
    ret
NOMB1:
    li t1, 0
    sb t1, 0(t0)
    li a0, 1
    ret

PREVIOUS_OPTION_MENU_BATTLE:
# SUB current menu option to 1, if its smaller than 0 return 3
    la t0, current_menu_option
    lb t1, 0(t0)
    addi t1,t1,-1
    li t2, 0
    blt t1,t2,POMB1 
    sb t1, 0(t0)
    li a0, 1
    ret
POMB1:
    li t1, 3
    sb t1, 0(t0)
    li a0, 1
    ret


SELECT_OPTION_MENU_BATTLE:
# still need to program this
# rn only leaving 
 

    la t0, current_menu_option
    lb t1, 0(t0)
    # new menu option will be 0:
    sb zero, 0(t0)
    # option 0 == attack menu
    bne t1, zero,SOMB0
    #  attack menu phase

    addi sp, sp -4
    sw ra, 0(sp)
        

    call ATTACK_MENU



    lw ra, 0(sp)
    addi sp, sp, 4
    ret

SOMB0:
    li t2,3
    bne t1, t2, SOMB3 
    j END_START_BATTLE
SOMB3:
ret










CLEAR_LAST_ARROW:
# clear all arrows from screen in battle:
# its easier to just add white to the places thats supposed to be printed
#  since were calling another procedure, we need to stack our ra

    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, arrow_clear
    # position 0: 
    li a1, 164
    li a2, 180
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT
    # position 1: 
    li a1, 236
    li a2, 180
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT
    # position 2:
    li a1, 164
    li a2, 200
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT

    # position 3:
    li a1, 236
    li a2, 200
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT



    lw ra, 0(sp)
    addi sp, sp, 4
    ret

.data
.include "../sprites/backgrounds/battlebg1.s"
.include "../sprites/backgrounds/attackmenubg.s"


.include "../sprites/menu/battlemenu.s"
.include "../sprites/menu/arrow.s"
.include "../sprites/menu/arrow_clear.s"



.include "../sprites/pokemons/dragonitefriendly.s"
.include "../sprites/pokemons/venusaurenemy.s"

