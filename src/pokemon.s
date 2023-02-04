.data
.include "../data/pokemon0.s"
.include "../data/pokemon1.s"
.include "../data/pokemon2.s"
.include "../data/pokemon3.s"
.include "../data/pokemon4.s"
.include "../data/pokemon5.s"
.include "../data/pokemon6.s"


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
    # index == 0 -> return pokemon1.s
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
    la a0, pikachufriendly
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

NEPIA1:   

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

GPSDEFAULT:
#default case
    la a0, pokemon0str
    ret
