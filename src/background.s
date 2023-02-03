.data

CURRENT_MAP: .byte 0

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


DATA_MAP_0:
    la a0, h1fdata
    ret

DATA_MAP_1:
    la a0, labdata
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


MAP_0:
    la a0, home_1f
    ret
MAP_1:
    la a0, lab
    ret

CHECK_TELEPORT:
# check if the character is in tp range
    #a0 adress of map data:
    mv t0, a0
    la t1, CHAR_POS
    lh t2, 0(t1) # x position
    lh t3, 2(t1) # y position

    # the tp 1 positions are in adresses a0[1] and a0[2]:
    lh t4,  2(a0) #x tp
    lh t5, 4(a0)  # y tp




    # check if positions are close:
    # return 1 if teleport occurred and 0 if not
    li a0,0
    bne t2, t4, PULA_TELEPORT
    bne t3, t5, PULA_TELEPORT
    # IF EQUAL DO STUFF HERE
    # new current map will be a0[3]
    la t1, CURRENT_MAP
    lh t2, 6(t0)
    sb t2, 0(t1)  
    # store ra and print new background
    li a0, 1
PULA_TELEPORT:
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



CLS:	
	li a0,0x00
	li a7,148
	li a1,0
	ecall
	ret

    
.data



.include "../sprites/backgrounds/h1f.s"
# .include "animation.s"
.include "../sprites/backgrounds/h1fdata.s"
.include "../sprites/backgrounds/lab.s"
.include "../sprites/backgrounds/labdata.s"