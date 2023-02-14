.data

CURRENT_MAP: .byte 1

.text

GET_DATA_FROM_MAP:
    # return the adress of file that contains informations about current map
    # get current index:
    la t0, CURRENT_MAP
    lb t1, 0(t0) # t1 = current map index


    # currrent index = 0
    beq t1, zero, DATA_MAP_0
    li t2, 1
    beq t1, t2, DATA_MAP_1
    addi t2, t2, 1
    beq t1, t2, DATA_MAP_2
    addi t2, t2, 1
    beq t1, t2, DATA_MAP_3
    addi t2, t2, 1
    beq t1, t2, DATA_MAP_4

DATA_MAP_0:
    la a0, citydata
    ret

DATA_MAP_1:
    la a0, labdata
    ret
DATA_MAP_2:
    la a0, gym1data
    ret
DATA_MAP_3:
    la a0, gym2data
    ret
DATA_MAP_4:
    la a0, gym3data
    ret


GET_MAP_ADRESS:
    # return adress of current map (image)
    la t0, CURRENT_MAP
    lb t1, 0(t0) # t1 = current map index
    # elif for all maps

    # currrent index = 0
    beq t1, zero, MAP_0
    li t2, 1
    beq t1, t2, MAP_1
    addi t2, t2, 1
    beq t1, t2, MAP_2
    addi t2, t2, 1
    beq t1, t2, MAP_3
    addi t2, t2, 1
    beq t1, t2, MAP_4

MAP_0:
    la a0, city
    ret
MAP_1:
    la a0, lab
    ret

MAP_2:
    la a0, gym1
    ret
MAP_3:
    la a0, gym2
    ret
MAP_4:
    la a0, gym3
    ret

CHECK_TELEPORT:
    # check if the character is in tp range
    mv t0, a0
    #a0 adress of map data:
    la t1, CHAR_POS
    lh t2, 0(t1) # x position
    lh t3, 2(t1) # y position

# change this loop
    #  in position a0 + 12 we have the amount of tps in current map, this will limit  our counter
    addi a0, a0, 10
    lh t1, 0(a0) # t1 = amount of tps in current map
    li t6, 0 # counter
    addi a0, a0, 2 # a0=[0] = first tp

CTP0:
    beq t1, t6, NCTPOUTLOOP
    # the tp 1 positions are in adresses a0[0] and a0[2]:
    lh t4,  0(a0) #x tp
    lh t5, 2(a0)  # y tp

    #  check if t2 == t4 and  t3 == t5
    bne t2, t4, NCTP0 # if diff jump to next loop
    bne t3, t5, NCTP0  # if diff jump to next loop
    # x and y equals:
    # store new current map and return true
    # new current map == a0 + 4
    la t0, CURRENT_MAP
    lb t1, 4(a0)
    sb t1, 0(t0)

    # set new x, y in char pos:
    la t0, CHAR_POS
    lh t1, 6(a0) # x 
    sh t1, 0(t0)

    lh t1, 8(a0) # y
    sh t1, 2(t0) 


    #  return true

    li a0, 1
    j END_TELEPORT
NCTP0:
    addi a0, a0, 10 # jump to next tp adress
    addi t6, t6, 1 # increase counter
    j CTP0

NCTPOUTLOOP:
    # none positions are equal -> return false
    li a0, 0

END_TELEPORT:
ret


UPDATE_CHAR_POS:
# function to update current char pos based on current map (player teleported)

    # since were calling another procedure well need to store current RA

    addi sp, sp, -4
    sw ra, 0(sp)
    
    la t0, CURRENT_MAP
    lb a0, 0(t0)
    call GET_DATA_FROM_MAP


    # a0 = map data

    la t0, CHAR_POS
    lh t1, 8(a0) # x new map
    lh t2, 10(a0) # y new map

    sh t1, 0(t0)
    sh t2, 2(t0)


    # change current direction to up
    la t0, CURR_DIRECTION
    li t1, 0
    sb t1, 0(t0)

    lw ra, 0(sp)
    addi sp, sp, 4

ret

PRINT_CURRENT_MAP:
    addi sp, sp, -4
    sw ra, 0(sp)

        call GET_MAP_ADRESS #a0 = current map adress
		li a1, 0
		li a2, 0
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT

    #  check if its the pokemon selection map to print the pokeballs
    # # if map is pokemon selection  -> print 6 pokeballs
    call IS_POKEMON_SELECTION
    # li a0, 0
    # a0 == boolean
    beq a0, zero, PCMNPS
        #pokemon seleciton case
        # PRINT 6 POKEBALLS
        call PRINT_POKEBALLS
        j PCMEND
PCMNPS:
#print current map not pokemon selection

    # check if its gym 1 map:
    call IS_GYM_ONE
    # a0 = boolean if its gym one
    beq a0, zero, PCMNGYM1
        # current npc == gym 1 npc
        la t0, current_npc
        li t1, 0 # index of gym 1 npc
        sh t1, 0(t0) # save

        # print npc
        call PRINT_NPC


    j PCMEND
PCMNGYM1:
    call IS_GYM_TWO
      # check if its gym 2 map:
    # a0 = boolean if its gym two
    beq a0, zero, PCMNGYM2
        # current npc == gym 2 npc
        la t0, current_npc
        li t1, 1 # index of gym 2 npc
        sh t1, 0(t0) # save
        # print npc
        call PRINT_NPC


    j PCMEND
PCMNGYM2:


    call IS_GYM_THREE
    beq a0, zero, PCMNGYM3
        # current npc == gym 3 npc
        la t0, current_npc
        li t1, 2 # index of gym 3 npc
        sh t1, 0(t0) # save
        # print npc
        li a7,1
        mv a0, t1
        ecall
        call PRINT_NPC
PCMNGYM3:
PCMEND:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


IS_POKEMON_SELECTION:
# returns if current map is the pokemon selection one
    la t0, CURRENT_MAP
    lb t1, 0(t0) 
    ## if t1 == 1 -> true: else: false
    li t2, 1
    bne t1, t2, IPSF
    # true:
    li a0, 1
    ret
IPSF:
    #is pokemon selection false case
    li a0, 0
    ret





IS_GYM_ONE:
    la t0, CURRENT_MAP
    lb t1, 0(t0) 
    ## if t1 == 2 -> true: else: false
    li t2, 2
    bne t1, t2, IGYM1F
    # true:
    li a0, 1
    ret
IGYM1F:
    #GYM 1  false case
    li a0, 0
    ret


IS_GYM_TWO:
    la t0, CURRENT_MAP
    lb t1, 0(t0) 
    ## if t1 == 3 -> true: else: false
    li t2, 3
    bne t1, t2, IGYM2F
    # true:
    li a0, 1
    ret
IGYM2F:
    #GYM 1  false case
    li a0, 0
    ret

IS_GYM_THREE:
    la t0, CURRENT_MAP
    lb t1, 0(t0) 
    ## if t1 == 4 -> true: else: false
    li t2, 4
    bne t1, t2, IGYM3F
    # true:
    li a0, 1
    ret
IGYM3F:
    #GYM 1  false case
    li a0, 0
    ret



PRINT_POKEBALLS:
    addi sp, sp, -4
    sw ra, 0(sp)
    li s2, 0 # counters
        li s1, 6 # counters
        li a1, 112
        li a2, 64
    IPSLOOP:
        beq s2, s1, PCMPS0
            la a0, pokeball
            li a3, 0
            call PRINT 
            li a3, 1
            call PRINT
            addi a1, a1, 16
            addi s2, s2, 1
            j IPSLOOP
    PCMPS0:
    lw ra, 0(sp)
    addi sp, sp, 4
    ret


CLS:	
	li a0,0x00
	li a7,148
	li a1,0
	ecall
	ret





.data
.include "../sprites/backgrounds/gym3.s"
.include "../sprites/backgrounds/gym3data.s"
.include "../sprites/backgrounds/gym2.s"
.include "../sprites/backgrounds/gym2data.s"
.include "../sprites/backgrounds/gym1.s"
.include "../sprites/backgrounds/gym1data.s"
.include "../sprites/backgrounds/city.s"
.include "../sprites/backgrounds/citydata.s"
.include "../sprites/backgrounds/lab.s"
.include "../sprites/backgrounds/labdata.s"
.include "../sprites/misc/pokeball.s"
