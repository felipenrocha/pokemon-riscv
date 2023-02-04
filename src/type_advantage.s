.data
tastr0: .ascii "It's Super\n"
taseparator: .byte 0
tastr1: .ascii "Effective! \n "


taseparator1: .byte 0

tastr2: .ascii "It's not very\n"
taseparator2: .byte 0
tastr3: .ascii "effective...\n"
taseparator3: .byte 0

.text


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
        # tpye of move
        li s7, 0
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
            li s7, 1
            ret
    CWBDND:
        # dragon type but not dragon enemy
        # # if types == grass water fire  multiplier = 0.5
        # we can check that if the oponent type has index >=2
            li t0, 2
            blt a1, t0, CWBND
            li a0, 50
            li s7, 2
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
        li s7, 2
        ret
    CWBNGG:
            li t0, 4
            bne a1, t0, CWBNGF
            # grass and fire = .50
            li a0, 50
            li s7, 2

            ret
    CWBNGF:
            li t0, 3
            bne a1, t0, CWBNGW
            #  grass and water = 1.50
            li a0, 150
            li s7, 1

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
        li s7, 1

        ret
CWBNWF:
        li t0, 1
        # water and dragon = .5
        bne a1, t0, CWBNWD
        li a0, 50
        li s7, 2
        ret
CWBNWD:
        li t0, 2
        # water and grass = .5x
        bne a1, t0, CWBNWG
        li a0, 50
        li s7, 2

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
        li s7, 1

        ret
CWBNFG:
        # check if its normal otherwise its the other ones:
        bne a1, zero, CWBNFN
        li a0, 100
        li s7, 0

        ret
CWBNFN:
        li a0, 50
        li s7, 2

        ret


CWBDEFAULT:
        li a0, 100
        li s7, 0

    ret


WEAKNESS_STR:
        addi sp, sp, -4
        sw ra, 0(sp)

        # Print its super effective! or its not very effective... BASED ON TYPE a0 
        li a7, 1
        ecall

        li t0, 1
        bne a0, t0, WS0
                # super effective case
                #  print its super :
                la a0, tastr0
                li a1, 174
                li a2, 182
                li a3, 0xc700
                li a4, 0
                li a7, 104
                ecall
                la a0, tastr0
                li a4, 1
                ecall

                # print effective!
                la a0, tastr1
                li a1, 174
                li a2, 204
                li a3, 0xc700
                li a4, 0
                li a7, 104
                ecall
                la a0, tastr1
                li a4, 1
                ecall
                j EWSTR
WS0:

        # case not very effective:
        # print its not very effective...
               #  print its not ver :
                la a0, tastr2
                li a1, 174
                li a2, 182
                li a3, 0xc700
                li a4, 0
                li a7, 104
                ecall
                la a0, tastr2
                li a4, 1
                ecall

                # print effective!
                la a0, tastr3
                li a1, 174
                li a2, 204
                li a3, 0xc700
                li a4, 0
                li a7, 104
                ecall
                la a0, tastr3
                li a4, 1
                ecall

EWSTR:

        lw ra, 0(sp)
        addi sp, sp, 4
        ret