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
move5str: .ascii "B.Slam\n"
.moveseparator5: .byte 0
move6str: .ascii "D.Hit \n"
.moveseparator6: .byte 0
move7str: .ascii "Waterfall\n"
.moveseparator7: .byte 0
move8str: .ascii "B.Beam\n"
.moveseparator8: .byte 0
move9str: .ascii "Ember\n"
.moveseparator9: .byte 0
move10str: .ascii "F.Wheel\n"
.moveseparator10: .byte 0
move11str: .ascii "R.Leaf\n"
.moveseparator11: .byte 0
move12str: .ascii "L.Seed\n"
.moveseparator12: .byte 0


.include "../data/move0.s"
.include "../data/move1.s"
.include "../data/move2.s"
.include "../data/move3.s"
.include "../data/move4.s"
.include "../data/move5.s"
.include "../data/move6.s"
.include "../data/move7.s"
.include "../data/move8.s"
.include "../data/move9.s"
.include "../data/move10.s"
.include "../data/move11.s"
.include "../data/move12.s"






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
    addi, t1, t1, 1
    bne t0, t1, GMS5
    la a0, move5str
    ret
GMS5:
    addi, t1, t1, 1
    bne t0, t1, GMS6
    la a0, move6str
    ret
GMS6:
    addi, t1, t1, 1
    bne t0, t1, GMS7
    la a0, move7str
    ret
GMS7:
    addi, t1, t1, 1
    bne t0, t1, GMS8
    la a0, move8str
    ret
GMS8:
    addi, t1, t1, 1
    bne t0, t1, GMS9
    la a0, move9str
    ret
GMS9:
    addi, t1, t1, 1
    bne t0, t1, GMS10
    la a0, move10str
    ret
GMS10:
    addi, t1, t1, 1
    bne t0, t1, GMS11
    la a0, move11str
    ret
GMS11:
    addi, t1, t1, 1
    bne t0, t1, GMS12
    la a0, move12str
    ret
GMS12:
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

