.data
# index of current pokemon from character
current_friendly_pokemon: .byte 0

#indedx for current enemy being battled
current_enemy: .byte 1


# index of current pokemon from enemy
current_enemy_pokemon: .byte 0
.text


START_BATTLE:

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

    call GET_ENEMY_POKEMON_IMAGE_ADRESS
    #a0 now has adress of image to be printed
    li a1, 184
    li a2, 50
    li a3, 0
    call PRINT
    li a3, 1
    call PRINT

#ENDSETUP START, lets loop this shit
 



BATTLELOOP:
j BATTLELOOP

j END_START_BATTLE


#end battle:
END_START_BATTLE:

    lw ra, 0(sp)
    addi sp, sp, 4
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


.data
.include "../sprites/backgrounds/battlebg1.s"
.include "../sprites/pokemons/dragonitefriendly.s"
.include "../sprites/pokemons/venusaurenemy.s"

