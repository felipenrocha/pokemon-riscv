.data
.include "../data/inventory.s"
.include "../data/item0.s"
.include "../data/item1.s"



item0str: .ascii "Potion \n"
strisp0: .byte 0
item1str: .ascii "Super Potion \n"
strisp1: .byte 0
item2str: .ascii "You've used a \n"
strisp2: .byte 0
current_menu_inventory: .byte 0

.text

INVENTORY_MENU:
# PRINT INVENTORY MENU
    addi sp, sp, -4
    sw ra, 0(sp)    


    # PRINT bg
    call SETUP_SWITCH_BG


    # print item and quantity
    call PRINTITEMS

    IML:
    call KEYINVENTORYMENU
        li t0, 5 #CHECK IF X WAS PRESSED TO GO BACK
        beq a0, t0, FIMINVENTORYMENU
        bne a0, zero, NO_CLEAR_ARROW_MENU_INVENTORY
        call CLEAR_ARROW_MENU_SWITCH

NO_CLEAR_ARROW_MENU_INVENTORY:
    # inventory menu loop
    call PRINT_SWITCH_ARROW
    
    j IML

FIMINVENTORYMENU:
    call SETUP_BATTLE
    lw ra, 0(sp)
    addi, sp, sp, 4
    ret

















KEYINVENTORYMENU:
		li t1,0xFF200000			# carrega o endereco de controle do KDMMIO
		lw t0,0(t1)				# Le bit de Controle Teclado
		andi t0,t0,0x0001			# mascara o bit menos significativo
   		beq t0,zero,FIMKEYINVENTORYMENU   	   	# Se nao ha tecla pressionada entao vai para FIM
  		lw t2,4(t1)  				# le o valor da tecla tecla
		
		li t0,'x'
		beq t2,t0,GO_BACK_INVENTORY_MENU		
        
        li t0,'d'
		beq t2,t0,INVENTORY_NEXT_OPTION
                
        li t0,'a'
		beq t2,t0,INVENTORY_PREVIOUS_OPTION	

        li t0,'z'
		beq t2,t0,SELECT_INVENTORY_OPTION
		
		
FIMKEYINVENTORYMENU:
		ret				# retorna



GO_BACK_INVENTORY_MENU:
    li a0, 5
    ret




SELECT_INVENTORY_OPTION:
    addi sp, sp, -4
    sw ra, 0(sp)

    #  select item index -> raise current pokemon hp 
    #  i can get the item index with the values of current menu option and inventory

    # INDEX = current menu option
    la t0, current_menu_switch
    lh t1, 0(t0)
    # index = t1

    # the item index will be adress of inventory + 2 + 2* index
    la t2, inventory
    addi t2, t2, 2
    # index = index * 2
    slli t1, t1, 1
    # adress = t2
    add t2, t2, t1

    lh t1, 0(t2)
    # t1 == item index
    # now we get the ammount of hp we need to raise our current pokemon
    mv a0, t1
    mv s6, t1
    call GET_ITEM_DATA
    # amount to raise = adress + 2
    lh t0, 2(a0)

    #  t0 ==  amount to raise hp

    #  store in s0
    mv s0, t0

    #  now lets get the current pokemon hp
    la t0, current_friendly_pokemon
    lh a0, 0(t0)
    call GET_CURRENT_POKEMON_DATA
    # A0 == adress
    #  current hp == adress + 2
    # total hp = adress +4
    lh t1, 2(a0) # t1 = curr hp
    lh t2, 4(a0) # t2 = total hp

    # NEW HP = current hp + potion value
    add t1, t1, s0
    #  t1 =  new hp


    ## if new hp > total hp -> set to total hp, else: set to new hp
    bge t1, t2, THP0
    sh t1, 2(a0)
    j THP1
THP0:
    # store total hp value in current hp data
    sh t2, 2(a0)

THP1:



    call SETUP_BATTLE
    call PRINTATTACKMENU # void

    #  print = you used a "item name"
    la a0, item2str
    li a7, 104
    li a1, 174
    li a2, 182
    li a3, 0xc700
    li a4, 0
    ecall
    la a0, item2str
    li a4, 1
    ecall

    #  print =  "item name"
    mv a0, s6
    call GET_ITEM_STR
    li a7, 104
    li a1, 174
    li a2, 200
    li a3, 0xc700
    li a4, 0
    ecall
    mv a0, s6
    call GET_ITEM_STR
    li a4, 1
    ecall


    li a0, 1000
    call SLEEP
    li a0, 500
    call SLEEP

    
    call IA_ATTACK

    la t0, current_friendly_pokemon
    lh a0, 0(t0)
    call CHECK_POKEMON_DEAD
    # print if pokemon died:
    # a0 == boolean if pokemon died
    addi sp, sp, -4
    sw a0, 0(sp) # store a0 for and late

    call CHECK_REMAING_POKEMON
    # a0 boolean if player has pokemons still
    ## if all pokemons are dead, end battle 
    beq a0, zero, LOSE_BATTLE  
    
    lw a0, 0(sp)
    addi sp, sp, 4
    #  a0 == boolean if pokemon died:
    ## if pokemon died and still have pokemons -> call switch
    ## if pokemon died a0 == 1
    li t0, 1
    blt a0, t0, PSNW1
        # call print: "your pokemon died"
        la t0, current_friendly_pokemon
        lh a0, 0(t0)
        call PRINT_DEAD_POKEMON_STR
        call POKEMON_SWITCH_MENU

PSNW1:
#  no need for pokemon switch



    li a0, 5
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
    


INVENTORY_NEXT_OPTION:
    # add menu option by 1 up to 5 (0-5 pokemon)
    la t0, current_menu_switch
    lh t1, 0(t0)
    addi t1, t1, 1


    li t2, 1
    bgt t1, t2, RESET_INVENTORY_OPTION1
    sh t1, 0(t0)
    li a0, 0
    ret

RESET_INVENTORY_OPTION1:
    # store current option as 0
    li t1, 0
    sh t1, 0(t0)
    li a0, 0
    ret


INVENTORY_PREVIOUS_OPTION:
    # add menu option by 1 up to 5 (0-5 pokemon)
    la t0, current_menu_switch
    lb t1, 0(t0)
    addi t1, t1, -1
    li t2, 0

    li a7,1
    mv a0, t1
    ecall

    blt t1, t2, RESET_INVENTORY_OPTION2
    sb t1, 0(t0)
    li a0, 0

    ret
RESET_INVENTORY_OPTION2:
    # store current option as 5
    li t1, 1
    sb t1, 0(t0)
    li a0, 0

    ret    






PRINTITEMS:
    addi sp, sp, -4
    sw ra, 0(sp)    

    # get items
    # total items = inventory[0]
    # for each item, print it, its quantity
    # s0 adress of inventory
    # s1 = amount of items in inventory
    # s2 = counter
    la s0, inventory
    lh s1, 0(s0)
    addi s0, s0, 2 # t0 = adress of item 0 on inventory
    
    mv a0, s1
    li a7, 1
    ecall

    # t1 == number of items (in our case: 2)
    li s2, 0 # t2 == counter
    li a1, 32
    li a2, 32
    li a3, 0xc700


PIL:
    beq s2, s1, PIO0
    
    #  print item name of index 0(s0)
    lh a0, 0(s0)
    call GET_ITEM_STR
    li a7, 4
    ecall
    # a0 = str to be printed
    mv t0, a0
    li a7, 104
    li a4, 0
    ecall
    mv a0, t0
    li a4, 1
    ecall
    addi a1, a1, -128
    addi a2, a2, 20  
    addi s0, s0, 2 # jump to next item
    addi s2, s2, 1 # add counter
    j PIL

PIO0:

    lw ra, 0(sp)
    addi, sp, sp, 4
    ret




GET_ITEM_DATA:
    # a0 =  index
    li t0, 0
    bne t0, a0, GID0
    la a0, item0
    ret
GID0:
    addi t0, t0, 1
    bne t0, a0, GID1
    la a0, item1
    ret
GID1:
    # default = super potion
    la a0, item0
    ret


GET_ITEM_STR:
#a0 = index
    li t0, 0
    bne t0, a0, GIS0
    la a0, item0str
    ret
GIS0:
    addi t0, t0, 1
    bne t0, a0, GIS1
    la a0, item1str
    ret
GIS1:
    # default = super potion
    la a0, item0
    ret