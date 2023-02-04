.data
move0str: .ascii "Tackle\n"
.moveseparator0: .byte 0
move1str: .ascii "D.Claw\n"
.moveseparator1: .byte 0
move2str: .ascii "A.Tail\n"
.moveseparator2: .byte 0
move3str: .ascii "F.Blast\n"
.moveseparator3: .byte 0
move4str: .ascii "S.Beam\n"
.moveseparator4: .byte 0

.include "../data/move0.s"
.include "../data/move1.s"
.include "../data/move2.s"
.include "../data/move3.s"
.include "../data/move4.s"




.text

GET_MOVE_STRING:
# TABLE TO GET STRING OF MOVE WITH INDEX A0
# a0 = index of move
mv t0, a0
    bne t0, zero, GMS0 
    # MOVE 0 == tackle
    la a0, move0str
    ret
GMS0:
    li t1, 1
    bne t0, t1, GMS1
    la a0, move1str
    ret
GMS1:
    li t1, 2
    bne t0, t1, GMS2
    la a0, move2str
    ret
GMS2:    
    li t1, 3
    bne t0, t1, GMS3
    la a0, move3str
    ret
GMS3:
    li t1, 4
    bne t0, t1, GMS4
    la a0, move4str
    ret
GMS4:
GMSDEFAULT:
    # DEFAULT CASE: TAcklE
    la a0, move0str
    ret

ret


GET_MOVE_DATA_ADRESS:
    # a0 = index of move
    # return adress o moves data

    mv t0, a0

    li t1, 0
    bne t0, t1, GMDA0
    la a0, move0
GMDA0:
    addi t1, t1, 1
    bne t0, t1, GMDA1
    la a0, move1
    ret
GMDA1:
    addi t1, t1, 1
    bne t0, t1, GMDA2
    la a0, move2
    ret
GMDA2:
    addi t1, t1, 1
    bne t0, t1, GMDA3
    la a0, move3
    ret
GMDA3:
    addi t1, t1, 1
    bne t0, t1, GMDA4
    la a0, move4
    ret
GMDA4:

GMDADEFAULT:
    # defaul: tacle
    la a0, move0
    ret

