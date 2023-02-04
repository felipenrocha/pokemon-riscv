
.text
ATTACK_MENU:
    addi sp, sp, -4
    sw ra, 0(sp)

    # new menu loop,
    # remember: if user press x, we need to reprint the old menu and set all variables.
    call PRINTATTACKMENU
    call PRINTMOVESMENU

ATTACKMENULOOP:

    # lets print the attacks of our pokemon
    call KEYATTACKMENU
        

    beq a0, zero, NKPA
        ## if keys were pressed, clear all last POSITIONS of arrows
        call CLEAR_LAST_ARROW
        li a0, 0

# NO keys pressed:
NKPA:
    call PRINT_MENU_ARROW

    li t0, 5
    beq t0, a0, ENDAM

    
j ATTACKMENULOOP


ENDAM:

    la a0, debug
    li a7, 4
    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    
    ret


KEYATTACKMENU:
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
		beq t2,t0,ATTACK_MENU_OPTION	

		li t0,'x'
		beq t2,t0,PRINT_BACK_MENU		
		
		
FKAM:		ret				# retorna




ATTACK_MENU_OPTION:
    addi sp, sp, -4
    sw ra, 0(sp)

    # when user attacks well need to know which move was used so we can inflict damage on our oponent.
    # we can get which move was used by taking advantege of the value of current_menu_option:


    # based on the menu option we can get the move index with the adress of the pokemon data
    # the move index will be pokemon_data_adress + 10 (when moves starts) + c urrent_menu_option*2
    # t1 = current menu option

    # getting pokemon data adress:
    la t0, current_friendly_pokemon
    lh t2 0(t0)
    # t2 = current friendly pokemon index
    mv a0, t2

    # a0 = index of pokemon
    call GET_CURRENT_POKEMON_DATA
    # a0 = adress of pokemon data
    mv t2, a0
    # t1 = current menu option, t2 = adress of pokemon

    # # move index = 8 + pokemon_data_adress + 2*(currentmenuoption)
    la t0, current_menu_option
    lb t1, 0(t0)

    addi t2, t2, 8
    slli t1, t1, 1
    add t1, t1, t2

    lh t3, 0(t1)

    # t3 = INDEX OF MOVE selected


    # lets get the ammount of base power the move has:
    mv a0, t3
    call GET_MOVE_DATA_ADRESS
    # a0 = adress of current move data

    # base power = 4 + base adress
    mv s2, a0
    # s2 will store the adress of move selected for later
    #  t0 = base power

    # lets check if the oponents pokemon has weakness agains my mov
    # auxiliar procedure that returns the multiplier of move used in enemy type
    # t3 has the adress of move
    mv a0, t3
    #  index of enemy pokemon
    la t2, current_enemy_pokemon
    lh t3, 0(t2)
    mv a1, t3
    # a0 = index of move, a1 = index of enemy pokemon
    call CHECK_WEAKNESS
    ## a0 == multiplier of move a0 attacking pokemon a1 from 0 to 200
    lh t0, 4(s2) # base power
    # total damage = multiplier * base power / 100

    mul a0, a0, t0
    li t1, 100
    div a0, a0, t1
    
    #a0 = total damage to deal to enemy
    # update stats in data, and reprint hpbars.
    # s2 will store the damage that will be done
    mv s2, a0

    # lets get the data adress so we can change the current hp value of the enemy pokemon

    la t0, current_enemy_pokemon
    lh t1, 0(t0)
    #t1 = index

    mv a0, t1
    call GET_CURRENT_POKEMON_DATA

    # calculate new hp: current hp - total damage:
    # current hp = 
    lh t1, 2(a0)
    sub t1, t1, s2
    blt t1, zero, ENEMY_DIED
    sh t1, 2(a0)
    j ENEMY_NOT_DEAD

ENEMY_DIED:
    li t0, 2
    sh t0, 2(a0)
    call PRINT_BLACK_ENEMY_BAR
    J FIM_ATTACK_MENU


ENEMY_NOT_DEAD:

    
    #  reprint moves when shits over
    # call PRINTMOVESMENU
    call PRINT_BLACK_ENEMY_BAR
    call PRINT_ENEMY_BAR


FIM_ATTACK_MENU:
        lw ra, 0(sp)
        addi sp, sp, 4
        ret



CHECK_WEAKNESS:
# a0 = index of move, a1 = index of enemy pokemon
    addi sp, sp, -4
    sw ra, 0(sp)

    # get type of move of index 0:

    call GET_MOVE_DATA_ADRESS
    # a0 = data adress of move with index a0
    lh s3, 2(a0) # type = adress + 2
    #  s3 = type of move (store it for later lol)
    # s4 adress of movce (save it for later too lol)
    mv s4, a0
    # now lets get the type of the enemy of index a1.
    mv a0, a1
    call GET_CURRENT_POKEMON_DATA
    lh t1, 6(a0)
    mv t0, s3
    # t0 = type of move, t1 = type of enemy pokemon
    

    mv a0, t0
    mv a1, t1
    call CHECK_WEAKNESS_MULTIPLIER
    
    # a0 = multiplier damage of move in enemy


    lw ra, 0(sp)
    addi sp, sp,4
    ret


CHECK_WEAKNESS_MULTIPLIER:

    # IF TYPE of move == NORMAL (0)
    bne a0, zero, CWBNN
        # normal move 1 multiplier against all types:
        li a0, 100
        ret         
# not normal move
CWBNN:

    li t0, 1
    # dragon type:
    bne a0, t0, CWBND
        # its 2x against dragons and only dragons (type 1)
        li t0, 1
        ## if enemy == dragon multiply by 2:
        bne a1, t0, CWBDND
            li a0, 150
            ret
    CWBDND:
        # dragon type but not dragon enemy
        # # if types == grass water fire  multiplier = 0.5
        # we can check that if the oponent type has index >=2
            li t0, 2
            blt a1, t0, CWBND
            li a0, 50
            ret
CWBND:
# not dragon type or normal 
    li t0, 2 # grass type
    bne a0, t0, CWBNG
    # grass move:
        #  x50 against fire and grass
        # x150 agains water
        # x100 else
        bne a0, a1, CWBNGG
        # grass and grass = .50
        li a0, 50
        ret
    CWBNGG:
            li t0, 4
            bne a1, t0, CWBNGF
            # grass and fire = .50
            li a0, 50
            ret
    CWBNGF:
            li t0, 3
            bne a1, t0, CWBNGW
            #  grass and water = 1.50
            li a0, 150
            ret
    CWBNGW:
            j CWBDEFAULT
CWBNG:
# not normal, dragon and grass
    li t0, 3
    bne a0, t0, CWBNW
    #  water style:
        # x50 against dragon water and grass
        # 150 agains fire
        li t0, 4
        # water and fire:
        bne a1, t0, CWBNWF
        li a0, 150
        ret
CWBNWF:
        li t0, 1
        # water and dragon = .5
        bne a1, t0, CWBNWD
        li a0, 50
        ret
CWBNWD:
        li t0, 2
        # water and grass = .5x
        bne a1, t0, CWBNWG
        li a0, 50
        ret
CWBNWG: 
        j CWBDEFAULT
CWBNW:
# not normal, dragon, grass nor water (just fire remaining to test)

    li t0, 4
    bne a0, t0, CWBDEFAULT
    # fire type:
        # 150x against grass
        # 50x against dragon, fire and water
        li t0, 2
        bne a1, t0, CWBNFG
        # fire attacking grass:
        li a0, 150
        ret
CWBNFG:
        # check if its normal otherwise its the other ones:
        bne a1, zero, CWBNFN
        li a0, 100
        ret
CWBNFN:
        li a0, 50
        ret


CWBDEFAULT:
    li a0, 100
    ret

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




PRINTMOVESMENU:
    # print moves of current pokemon on screen
    addi sp, sp,-4
    sw ra, 0(sp)
    # get current index of pokemon:
    la t0, current_friendly_pokemon
    lh t1, 0(t0)
    # t0 == index of current pokemon
    # get adress of data of current pokemon
    mv a0, t1
    call GET_CURRENT_POKEMON_DATA
    # a0 = adress of data of pokemon
    mv t2, a0
    #  well sotre that adress in t2

    # moves = data[4:7]
    # print string of move 0:
    lh t1, 8(t2) # position 4 
    # use procedure to return string of move of index a0
    mv a0, t1
    call GET_MOVE_STRING
    mv t0, a0
    # a0 = string containing name of move

    # print string on screen:
    # a7 104
    li a7, 104
    li a1,174
    li a2, 182
    li a3, 0xc700
    li a4, 0
    ecall
    mv a0, t0
    li a4, 1
    ecall

#  print move 1:

    lh t1, 10(t2) # position 5 
    # use procedure to return string of move of index a0
    mv a0, t1
    call GET_MOVE_STRING
    mv t0, a0
    # a0 = string containing name of move
    # print string on screen:
    # a7 104
    li a1, 248
    li a2, 182
    li a4, 0
    ecall
    mv a0, t0
    li a4, 1
    ecall


# print move 2
    lh t1, 12(t2) # position 6 
    # use procedure to return string of move of index a0
    mv a0, t1
    call GET_MOVE_STRING
    mv t0, a0
    # a0 = string containing name of move
    # print string on screen:
    # a7 104
    li a1, 174
    li a2, 204
    li a4, 0
    ecall
    mv a0, t0
    li a4, 1
    ecall

# print move 3
    lh t1, 14(t2) # position 7 
    # use procedure to return string of move of index a0
    mv a0, t1
    call GET_MOVE_STRING
    mv t0, a0
    # a0 = string containing name of move
    # print string on screen:
    # a7 104
    li a1, 248
    li a2, 204
    li a4, 0
    ecall
    mv a0, t0
    li a4, 1
    ecall



    lw ra, 0(sp)
    addi sp, sp, 4
    ret


