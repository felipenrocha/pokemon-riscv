.data
.include "../data/pokemon0.s"
.include "../data/pokemon1.s"

current_friendly_pokemon: .byte 0
current_enemy_pokemon: .byte 1

.text

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

    # default

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
    # default
    la a0, venusaurenemy
    ret

ret
