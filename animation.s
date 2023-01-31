.data
# stores current direction for animation: 
# 0: up, 1: left, 2: down, 3 right
CURR_DIRECTION: .byte  2

# store which frame where using on animation rn (1,2, or 3)
CURR_FRAME: .byte 1


.text



GET_CURRENT_FRAME:


        # load current frame adress
        la t2, CURR_FRAME
        #  load curr fram value
        lb t3, 0(t2)
        #  t0 == 3



        # LOAD BASED O CURRENT FRAME OF CHARACTER
        li t4, 1
        li t5, 2
        li t6, 3
        
        # t2 = Curr frame adress
        # t3 =  current frame
        # load current direction adress

        la t0, CURR_DIRECTION
        # load current direction value
        lb t1, 0(t0)

        # is character going up
        li t0, 0
        beq t1, t0, UP

        li t0, 1
        beq t1, t0, LEFT
            
        li t0, 2
        beq t1, t0, DOWN

        li t0, 3
        beq t1, t0, RIGHT

UP: 

    beq t4, t3, UP_1
    beq t5, t3, UP_2
    beq t6, t3, UP_3


UP_1:
    la a0, hero_up_1
    ret

UP_2:
    la a0, hero_up_2
    ret

UP_3:
    la a0, hero_up_3
    ret


LEFT:
    beq t4, t3, LEFT_1
    beq t5, t3, LEFT_2
    beq t6, t3, LEFT_3

LEFT_1:
    la a0, hero_left_1
    ret

LEFT_2:
    la a0, hero_left_2
    ret

LEFT_3:
    la a0, hero_left_3
    ret




DOWN:
    beq t4, t3, DOWN_1
    beq t5, t3, DOWN_2
    beq t6, t3, DOWN_3


DOWN_1:
    la a0, hero_down_1
    ret

DOWN_2:
    la a0, hero_down_2
    ret

DOWN_3:
    la a0, hero_down_3
    ret


RIGHT:
    beq t4, t3, RIGHT_1
    beq t5, t3, RIGHT_2
    beq t6, t3, RIGHT_3


RIGHT_1:
    la a0, hero_right_1
    ret

RIGHT_2:
    la a0, hero_right_2
    ret

RIGHT_3:
    la a0, hero_right_3
    ret


  

.data

.include "sprites/characters/hero_left_1.data"
.include "sprites/characters/hero_left_2.data"
.include "sprites/characters/hero_left_3.data"



.include "sprites/characters/hero_right_1.data"
.include "sprites/characters/hero_right_2.data"
.include "sprites/characters/hero_right_3.data"



.include "sprites/characters/hero_up_1.data"
.include "sprites/characters/hero_up_2.data"
.include "sprites/characters/hero_up_3.data"


.include "sprites/characters/hero_down_1.data"
.include "sprites/characters/hero_down_2.data"
.include "sprites/characters/hero_down_3.data"



