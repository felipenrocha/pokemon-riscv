.data
.include "../data/selectionlist.s"

.include "../data/pokemon0.s"
.include "../data/pokemon1.s"
.include "../data/pokemon2.s"
.include "../data/pokemon3.s"
.include "../data/pokemon4.s"
.include "../data/pokemon5.s"
.include "../data/pokemon6.s"
.include "../data/pokemon7.s"
.include "../data/pokemon8.s"
.include "../data/pokemon9.s"
.include "../data/pokemon10.s"




pokemon0str: .ascii "Dragonite \n"
current_friendly_pokemon: .half 0
pokemon1str: .ascii "Venusaur \n"
current_enemy_pokemon: .half 1
pokemon2str: .ascii "Charizard \n"
separator2: .half 1
pokemon3str: .ascii "Blastoise \n"
separator3: .half 1
pokemon4str: .ascii "Staryu \n"
separator4: .half 1
pokemon5str: .ascii "Rapidash \n"
separator5: .half 1
pokemon6str: .ascii "Raticate \n"
separator6: .half 1
pokemon7str: .ascii "Snorlax \n"
separator7: .half 1
pokemon8str: .ascii "Gyarados \n"
separator8: .half 1
pokemon9str: .ascii "Exeggutor \n"
separator9: .half 1
pokemon10str: .ascii "Moltres \n"
separator10: .half 1
deathstr: .ascii "has fainted! \n"
separator11: .half 1
.text

#TABLE TO RETURN POKEMON VALUES BASED ON ITS INDEX

GET_CURRENT_POKEMON_DATA:
    # a0 = index of pokemon
    # returning the adress having the data of pokemon with index a0
    bne a0, zero, GCPD0
    # index == 0 -> return pokemon0.s
    la a0, pokemon0
    ret
GCPD0:
    li t0, 1
    bne a0, t0, GCPD1
    # index == 1 -> return pokemon1.s
    la a0, pokemon1
    ret
GCPD1:

    addi t0, t0, 1
    bne a0, t0, GCPD2
    # index == 2 -> return pokemon2.s
    la a0, pokemon2
    ret
GCPD2:

    addi t0, t0, 1
    bne a0, t0, GCPD3
    # index == 3 -> return pokemon3.s
    la a0, pokemon3
    ret
GCPD3:
    addi t0, t0, 1
    bne a0, t0, GCPD4
    # index == 4 -> return pokemon4.s
    la a0, pokemon4
    ret
GCPD4:
    addi t0, t0, 1
    bne a0, t0, GCPD5
    # index == 5 -> return pokemon5.s
    la a0, pokemon5
    ret
GCPD5:

    addi t0, t0, 1
    bne a0, t0, GCPD6
    # index == 6 -> return pokemon6.s
    la a0, pokemon6
    ret
GCPD6:
    addi t0, t0, 1
    bne a0, t0, GCPD7
    # index == 7 -> return pokemon7.s
    la a0, pokemon7
    ret
GCPD7:
    addi t0, t0, 1
    bne a0, t0, GCPD8
    # index == 8 -> return pokemon8.s
    la a0, pokemon8
    ret
GCPD8:
    addi t0, t0, 1
    bne a0, t0, GCPD9
    # index == 9 -> return pokemon9.s
    la a0, pokemon9
    ret
GCPD9:
    addi t0, t0, 1
    bne a0, t0, GCPD10
    # index == 10 -> return pokemon10.s
    la a0, pokemon10
    ret
GCPD10:

GCPDD:   
    # default: pokemon 0
    la a0, pokemon0
    ret



GET_FRIENDLY_POKEMON_IMAGE_ADRESS:

    # a0 = index of pokemon
    # index 0 == dragonite
    bne a0, zero, NFPIA0
    la a0, dragonitefriendly
    ret
# not friendly pokemon image adress of index 0
NFPIA0:     
    li t0, 1
    bne a0, t0, NFPIA1
    la a0, dragonitefriendly
    ret
NFPIA1:
    addi t0, t0, 1
    bne a0, t0, NFPIA2
    la a0, charizardfriendly
    ret
NFPIA2:   
    addi t0, t0, 1
    bne a0, t0, NFPIA3
    la a0, blastoisefriendly
    ret
NFPIA3:
    addi t0, t0, 1
    bne a0, t0, NFPIA4
    la a0, staryufriendly
    ret
NFPIA4:
    addi t0, t0, 1
    bne a0, t0, NFPIA5
    la a0, rapidashfriendly
    ret
NFPIA5:
    addi t0, t0, 1
    bne a0, t0, NFPIA6
    la a0, raticatefriendly
    ret
NFPIA6:
    addi t0, t0, 1
    bne a0, t0, NFPIA7
    la a0, raticatefriendly
    ret
NFPIA7:

    # default
NFPIADEFAULT:
    la a0, dragonitefriendly
    ret




GET_ENEMY_POKEMON_IMAGE_ADRESS:
# index 1 == venusaur   
  # index 0 == dragonite
    bne a0, zero, NEPIA0
    la a0, dragonitefriendly
    ret
# not friendly pokemon image adress of index 0
NEPIA0:   
    li t0, 1
    bne a0, t0, NEPIA1
    la a0, venusaurenemy
    ret
NEPIA1:   
    li t0, 7
    bne a0, t0, NEPIA2
    la a0, snorlaxenemy
    ret
NEPIA2:
    addi t0, t0, 1
    bne a0, t0, NEPIA3
    la a0, gyaradosenemy
    ret
NEPIA3:
    addi t0, t0, 1
    bne a0, t0, NEPIA4
    la a0, exeggutorenemy
    ret
NEPIA4:
    addi t0, t0, 1
    bne a0, t0, NEPIA5
    la a0, moltresenemy
    ret
NEPIA5:

NEPIADEFAULT:
    # default
    la a0, venusaurenemy
    ret

ret




GET_POKEMON_STRING:
    # a0 = pokemon index
    li t0, 0
    bne a0, t0, GPS0
    la a0, pokemon0str
    ret
GPS0:
    addi t0, t0, 1
    bne a0, t0, GPS1
    la a0, pokemon1str
    ret
GPS1:    
    addi t0, t0, 1
    bne a0, t0, GPS2
    la a0, pokemon2str
    ret
GPS2:
    addi t0, t0, 1
    bne a0, t0, GPS3
    la a0, pokemon3str
    ret
GPS3:
    addi t0, t0, 1
    bne a0, t0, GPS4
    la a0, pokemon4str
    ret
GPS4:    addi t0, t0, 1
    bne a0, t0, GPS5
    la a0, pokemon5str
    ret
GPS5:    
    addi t0, t0, 1
    bne a0, t0, GPS6
    la a0, pokemon6str
    ret
GPS6:
    addi t0, t0, 1
    bne a0, t0, GPS7
    la a0, pokemon7str
    ret
GPS7:
    addi t0, t0, 1
    bne a0, t0, GPS8
    la a0, pokemon8str
    ret
GPS8:    
addi t0, t0, 1
    bne a0, t0, GPS9
    la a0, pokemon9str
    ret
GPS9:
    addi t0, t0, 1
    bne a0, t0, GPS10
    la a0, pokemon10str
    ret
GPS10:



GPSDEFAULT:
#default case
    la a0, pokemon0str
    ret




CHECK_POKEMON_DEAD:
    #  a0 = index of pokemon
    #  RETURNS boolean if pokemon is dead
    addi sp, sp -4
    sw ra, 0(sp)

    call GET_CURRENT_POKEMON_DATA
    #  a0 = adress of current a0 data
    #  check if current hp <= 2 (kill zone)
    #  current hp = adress of pokemon + 2
    #  current hp = adress of pokemon + 2
    lh t0, 2(a0)
    # t0 = current hp
    li t1, 2
    ble t0, t1, CPDT # if t0 <= t1 then target
        # pokemon not dead (return false)
        li a0, 0
        j  CPDE

# pokemon is dead
CPDT:
    # update total number of pokemons alive
    la t0, heropokemons
    lh t1, 0(t0)
    addi t1, t1, -1
    sh t1, 0(t0)

    # return true
    li a0, 1

CPDE:
# CHECK_POKEMON_DEAD END
    li a7, 1
    ecall

    lw ra, 0(sp)
    addi sp, sp, 4
    ret


CHECK_REMAING_POKEMON:
# CHECK IF PLAYER HAS REMAINING POKEMON
    la t0, heropokemons
    lh t1, 0(t0)
    ble t1, zero, CRMPF
    # pokemons still alive -> return true
        li a0, 1
        ret

CRMPF:
# CHECK REMAINING POKEMON false CASE
    # all pokemons dead
    li a0, 0
    ret

PRINT_DEAD_POKEMON_STR:
# print: "Name of pokemon has fainted!"
# a0 == index of pokemon
    addi sp, sp, -4
    sw ra, 0(sp)
    # mv s0, a0

    call GET_POKEMON_STRING
    # a0 = string of pokemon, lets print it
    li a7, 104
    li a1, 174
    li a2, 182
    li a3, 0xc700
    li a4, 0
    ecall
    mv a0, s0
    call GET_POKEMON_STRING

    li a4, 1 
    ecall


# print has fainted!
    la a0, deathstr
    li a7, 104
    li a1, 174
    li a2, 198
    li a3, 0xc700
    li a4, 0
    ecall
    la a0, deathstr
    li a4, 1 
    ecall


    li a0, 1000
    call SLEEP
    li a0, 1000
    call SLEEP

    call PRINTATTACKMENU


    lw ra, 0(sp)
    addi sp, sp, 4
    ret


GET_POKEMON_INDEX_SELECTION:
    # a0 = first x (112) 
    # GET current x and divide it by 16  to get the index 
    la t0, CHAR_POS
    lh t1, 0(t0)
    sub t1, t1, a0
    li t2, 16
    div t1, t1, t2
    slli t1, t1, 1 # INDEX = INDEX * 2 ( half words)
    # t1 = index we want to move based on selection list 
    la t0, selectionlist
    add t0, t0, t1 # new adress added to index
    lh a0, 0(t0) 
    li a7, 1
    ecall
GPISEND:    
    ret

CHECK_ALL_POKEMONS_SELECTED:
    # booleanr returning if character has max pokemons already
    la t0, heropokemons
    lh t1, 0(t0)
    li t2, 3
    bge t1,t2 CAPST
    li a0, 0
    ret
CAPST:
    #check all poikemons selected true
    li a0, 1
    ret

CHECK_POKEMON_ALREADY_SELECTED:
addi sp, sp, -4
sw ra, 0(sp)
# a0 = index of pokemon selected

# check already is in heropokemons
la t0, heropokemons
lh t1, 0(t0) #t1 = number of pokemons
li t2, 0 # t2 = counter
addi t0, t0, 2 # t0 = adress of first pokemons
CPASLOOP:
    beq t2, t1, CPASOUT
    lh t3, 0(t0) # t3 = index of pokemon in heros pokemon
    beq t3, a0, CPASTRUE
    addi t0, t0, 2 # jump to next pokemon
    addi t2, t2, 1
    j CPASLOOP
CPASTRUE:
    li a0, 1
    j CPASEND
CPASOUT:
# out loop : pokemon not selected yet
    li a0, 0 
CPASEND:
lw ra, 0(sp)
addi sp, sp ,4
ret


SET_NEW_POKEMON:
# a0 = index o pokemon to be inserted in herospokemon]
la t0, heropokemons
lh t1, 0(t0) # amount of pokemons already, well push the new pokemon at index:
# 2 +  amount of pokemon * 2
    addi t0, t0, 2
    slli t1, t1, 1
    add t0, t0, t1 # t0 = adress to store new pokemon
    sh a0, 0(t0) # stored in herospokemon
# now lets add the amount
    la t0, heropokemons
    lh t1, 0(t0) # amount of pokemons already, well push the new pokemon at index:
    addi t1, t1, 1
    sh t1, 0(t0)
ret