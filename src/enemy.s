.data
.include "../data/enemy0.s"
.include "../data/enemy1.s"


.text

GET_ENEMY_DATA:
    # a0 = index
    li t0, 0
    bne a0, t0, GED0
        #  INDEX == 0 
        la a0, enemy0
        ret
GED0:
    addi t0, t0, 1
    bne a0, t0, GED1
    la a0, enemy1
    ret
GED1:
    la a0, enemy0
    ret

CHECK_REMAINING_POKEMON_ENEMY:
# returns true if enemy still has pokemons
    addi sp, sp, -8
    sw ra, 4(sp)
    sh a0, 0(sp)


    # a0 = index of enemy
    call GET_ENEMY_DATA
    #  a0 = adress of current a0 data
    lh t0, 0(a0)
    


    # t0 =  total pokemon
    bne t0, zero, CRPEND
    # no pokemon left
    li a0, 0
    lw ra, 4(sp)
    addi sp, sp, 8
    ret
CRPEND:
# pokemons left
    li a0, 1
    lw ra, 4(sp)
    addi sp, sp, 8
    ret

SWITCH_POKEMON_ENEMY:

    addi sp, sp, -4
    sw ra, 0(sp)


    # SWITCH CURRENT ENEMY POKEMON (how ?)
    # pokemon died -> we have current enemy pokemon and current enemy.
    # we need to check when the current enemy pokemon index == the currents enemy list
    # then we update the current enemy pokemon and decrease the total of pokemons alive.

    #  current pokemon index
    la t0, current_enemy_pokemon
    lh t1, 0(t0) # t1 == index of current pokemon
    mv s6, t1 #store this index
    # get the position of this pokemon in current enemy
    la t0, current_enemy
    lh a0, 0(t0)

    call GET_ENEMY_DATA
    #  a0  == adress of dcurrent enemy data, s6 == index of current pokemon
    addi a0, a0, 2
    #  a0 = adress of first pokemon
    # switch pokemon enemy loop

SPEL:
    lh t0, 0(a0)
    # t0 = indexof pokemon
    beq t0, s6, SPCL
    ## if not equal, get next adress and continue loop
    addi a0, a0, 2
    j SPEL
    
     # get next pokemon:


SPCL:
    addi a0, a0, 2
    lh t0, 0(a0)
    

    # FOund next index
    # a0 = adress of index 
    # t0 == index of pokemon
    #  store pokemon as new
    la t3, current_enemy_pokemon
    sh t0, 0(t3)



    lw ra, 0(sp)
    addi sp, sp, 4
    ret