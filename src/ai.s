
.text
# module resposible to generate attacks for ai
IA_ATTACK:
    addi sp, sp, -4
    sw ra, 0(sp)


    # lets get the move tthe current enemy pokemon index:
    la t0, current_enemy_pokemon
    lh t1, 0(t0)
    # t1 = halfword of current pokemon index
    # getting the adress of the pokemon data based on its index:
    mv a0, t1
    call GET_CURRENT_POKEMON_DATA
    #a0 = adress of pokemon data
    
    # moves are located in position data[4:7]
    # move[0] = data[4] in half words = data + 8 bytes offset
    addi a0, a0, 8
    # a0 = first move
    mv a1, a0
    # store adress

   
    # select random move to inlfict damage on cuurent player
    # random move from 0 to 3 
    # see 2 last bits only:
    # calculate random number

    
    li a7,141
	ecall
    # random word of 32 bits << 30 then shift >> 30
    slli a0, a0, 30
    srli a0, a0, 30
    #  a0 == number from 0 to 3

    # random number * 2 (halfwords)
    slli a0, a0, 1
    # move[i] = move0adress + i * 2
    add a0, a0, a1
    # adress = a0

    lh t0, 0(a0)
    # t0 == index of move selected by ai

    
    mv a0, t0
    mv s6, t0   # s6 == index of move selected

    call GET_MOVE_DATA_ADRESS
    # a0 = adress of current move data

    #  s2 = will store the adress of move selected for later 

    mv s2, a0

    # s2 has the adress of move
    # s6 == index of move selected

    # lets check if well have weakness against his.
    # auxiliar procedure that returns the multiplier of move used in enemy type

    la t0, current_friendly_pokemon
    lh t1, 0(t0)
    # t1 = index of friendly pokemon
    mv a1, t1
    mv a0, s6 # index of move
    # a0 = index of move, a1 = index of friendly pokemon
    call CHECK_WEAKNESS 
    # return multiplier

    # calculate damage dealt
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

    # lets get the data adress so we can change the current hp value of the friendly pokemon

    la t0, current_friendly_pokemon
    lh t1, 0(t0)
    #t1 = index

    mv a0, t1
    call GET_CURRENT_POKEMON_DATA

    
    # calculate new hp: current hp - total damage:
    # current hp = 
    lh t1, 2(a0)
    sub t1, t1, s2
    ble t1, zero, FRIENDLY_DIED
        sh t1, 2(a0)
        j FRIENDLY_NOT_DEAD


FRIENDLY_DIED:
    li t0, 2
    sh t0, 2(a0)
    mv a0, s6
    # a1 = index of pokemon
    la t0, current_enemy_pokemon
    lh t1, 0(t0)
    mv a1, t1
    call PRINT_ATTACK
    j FIM_IA_ATTACK

FRIENDLY_NOT_DEAD:
        #    a0 =  index of attack
        mv a0, s6
        # a1 = index of pokemon
        la t0, current_enemy_pokemon
        lh t1, 0(t0)
        mv a1, t1
        call PRINT_ATTACK
    


FIM_IA_ATTACK:
      #  reprint moves when shits over
        # call PRINTMOVESMENU
        call PRINT_BLACK_FRIENDLY_BAR
        call PRINT_FRIENDLY_BAR
        
    lw ra, 0(sp)
    addi sp, sp, 4
    ret