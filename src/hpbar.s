.data
hpbarseparator: .ascii " / \n"
hpbarseparator0: .byte 0
hpbarbuffer: .ascii "          "

.text
PRINT_HP_BAR:
    addi sp, sp, -4
    sw ra, 0(sp)

    # well print a black line to represent the full hp and a green to represent the current one

    
    # first print the friendly bar
    call PRINT_FRIENDLY_BAR
    call PRINT_ENEMY_BAR

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

PRINT_FRIENDLY_BAR:

    addi sp, sp, -4
    sw ra, 0(sp)
# well need to get the data from friendly pokemon

# PRINT green line
# green line should be at length 116 when 100% and length 0 when 0% of hp
# well calculate the % of 116 based on the % of current hp and pass it as length of green bar



    la t0, current_friendly_pokemon
    lb t1, 0(t0)
    mv a0, t1
    # a0 will have the index of the current pokemon
    call GET_CURRENT_POKEMON_DATA
    # a0 = adress of friendly pokemon data
    mv t0, a0
    # t0 = adress
    lh t1, 2(t0) # current hp
    lh t2, 4(t0) # total hp


    # % of current hp
    # multiply current hp by 100 and divide by total (% in 0-100)
    li t3, 100
    mul t1, t1, t3
    div t1, t1, t2
    # t1 = % from 0 to 100 of current hp compared to total hp

    li t4, 116
    # len = 116*%/100
    mul t1, t1, t4 # 116 * %

    div t1, t1, t3 # /100

    # t1 = length of green line:

#  draw GREEN line position 16, 148 of length 116 and height 8
    li a0, 16
    mv a2, zero
    add a2, t1, a0
    li a1, 148
    li a3, 148
	li a4, 0xc738
	li a5,0
	li a7,47
	ecall
    xori a5, a5, 1
    ecall
    # PRINT FOR 8 COLUMNS
    li t0, 0
    li t1, 8
LPFBIN2:
    beq  t0, t1, LPFBOUT2
    addi t0, t0, 1
    addi a1, a1, 1
    addi a3, a3, 1
    ecall
    xori a5, a5, 1
    ecall
    j LPFBIN2

LPFBOUT2:


    # clear the old one if it has:
    li a7, 104
    la a0, hpbarbuffer
    li a1, 20
    li a2, 136
    li a3, 0xfefe

    li a4, 0
    ecall
    # la a0, hpbarbuffer
    # li a4, 1
    # ecall


#  well also print the current amount of hp and the total of the pokemon

    la t0, current_friendly_pokemon
    lb t1, 0(t0)
    mv a0, t1
    # a0 will have the index of the current pokemon
    call GET_CURRENT_POKEMON_DATA
    # a0 = adress of friendly pokemon data
    mv t0, a0
    # t0 = adress
    lh t1, 2(t0) # current hp
    lh t2, 4(t0) # total hp

    # print integer syscall
    li a7, 101
    mv a0, t1
    li a1, 20
    li a2, 136
    li a3, 0xc700
    li a4, 0
    ecall
    li a4, 1
    ecall

    #print separator

    li a7, 104
    la a0, hpbarseparator
    li a1, 36
    li a4, 0
    ecall
    la a0, hpbarseparator
    li a4, 1
    ecall

    # print integer syscall
    li a7, 101
    mv a0, t2
    li a1, 52
    li a2, 136
    li a3, 0xc700
    li a4, 0
    ecall
    li a4, 1
    ecall


    lw ra, 0(sp)
    addi sp, sp, 4
    ret




PRINT_ENEMY_BAR:

    addi sp, sp, -4
    sw ra, 0(sp)
# well need to get the data from friendly pokemon

# PRINT green line
# green line should be at length 116 when 100% and length 0 when 0% of hp
# well calculate the % of 116 based on the % of current hp and pass it as length of green bar



    la t0, current_enemy_pokemon
    lb t1, 0(t0)
    mv a0, t1
    # a0 will have the index of the current pokemon
    call GET_CURRENT_POKEMON_DATA
    # a0 = adress of friendly pokemon data
    mv t0, a0
    # t0 = adress
    lh t1, 2(t0) # current hp
    lh t2, 4(t0) # total hp


    # % of current hp
    # multiply current hp by 100 and divide by total (% in 0-100)
    li t3, 100
    mul t1, t1, t3
    div t1, t1, t2
    # t1 = % from 0 to 100 of current hp compared to total hp

    li t4, 116
    # len = 116*%/100
    mul t1, t1, t4 # 116 * %

    div t1, t1, t3 # /100

    # t1 = length of green line:

#  draw GREEN line position 16, 148 of length 116 and height 8
    li a0, 132
    mv a2, zero
    add a2, t1, a0
    li a1, 32
    li a3, 32
	li a4, 0xc738
	li a5,0
	li a7,47
	ecall
    xori a5, a5, 1
    ecall
    # PRINT FOR 8 COLUMNS
    li t0, 0
    li t1, 8
LPEBIN2:
    beq  t0, t1, LPEBOUT2
    addi t0, t0, 1
    addi a1, a1, 1
    addi a3, a3, 1
    ecall
    xori a5, a5, 1
    ecall
    j LPEBIN2

LPEBOUT2:



    lw ra, 0(sp)
    addi sp, sp, 4
    ret




PRINT_BLACK_FRIENDLY_BAR:
    # print black and green lines
    # syscall from class

# PRINT BLACK LINE:
#  draw black line position 16, 148 of length 116 and height 8
    li a0, 16
    li a2, 132
    li a1, 148
    li a3, 148
	li a4, 0x0
	li a5,0
	li a7,47
	ecall
    # PRINT FOR 8 COLUMNS
    li t0, 0
    li t1, 8
    LPFBIN1:
        beq  t0, t1, LPFBOUT1
        addi t0, t0, 1
        addi a1, a1, 1
        addi a3, a3, 1
        ecall
        j LPFBIN1

    LPFBOUT1:

ret




PRINT_BLACK_ENEMY_BAR:
    # print black and green lines
    # syscall from class

# PRINT BLACK LINE:
#  draw black line position 132, 32 of length 116 and height 8
    # x's
    li a0, 132
    li a2, 248

    # y's
    li a1, 32
    li a3, 32
	li a4, 0x0
	li a5,0
	li a7,47
	ecall
    # PRINT FOR 8 COLUMNS
    li t0, 0
    li t1, 8
LPEBIN1:
    beq  t0, t1, LPEBOUT1
    addi t0, t0, 1
    addi a1, a1, 1
    addi a3, a3, 1
    ecall
    j LPEBIN1

LPEBOUT1:

ret
