.data
instruction: .ascii "Welcome to the game of Battleship!\n"
"\nThis game will take place on 7x7 grids with rows lettered A-G from top to bottom and columns numbered 1-7 from left to right.\n"
"At first, each player will have 3 2x1 ships, 2 3x1 ships and 1 4x1 ship.\n" 
"They have to place all of their ships vertically or horizontally inside their map so that the ships cannot overlap with each other.\n"
"After that, both players will take turn targeting a box on the other player\'s map blindly.\n"
"If the attack hits a cell that is occupied by a ship, an announcement will pop up in the terminal and say \"HIT!\", otherwise say \"MISS!\".\n"
"The players will need to remember the cells that have been hit themselves.\n"
"A ship is completely destroyed if all of the cells it\'s occupying are targeted.\n"	
"A player will lose if all of their ships got destroyed first.\n\0"	
cau1: .asciiz "Let's play the game!\nFirst, 2 players have to set up their ships."
cau2: .asciiz "After setting up the ships, 2 players now take turn to target a cell on the other player's map."
fileName: .asciiz "Battleship.txt"
board2: .byte 32:200
board1: .byte 32:200
header: .byte 32:23
endl: .asciiz "\n"
p1Board: .asciiz "Player 1's board:\n"
p2Board: .asciiz "\n\nPlayer 2's board:\n"
input234: .asciiz "The input must be 2,3 or 4!"
askSize: .asciiz "Input the ship size (2,3 or 4): "
quitGame: .asciiz "Do you want to quit the game?"
noInput: .asciiz "You have not inputted anything!"
manyShip2: .asciiz "There are already 3 2x1 ships!"
manyShip3: .asciiz "There are already 2 3x1 ships!"
manyShip4: .asciiz "There is already a 4x1 ship!"
askRow: .asciiz "Input the row letter (A-G): "
askCol: .asciiz "Input the column number (1-7): "
askDir: .asciiz "Input the direction letter (U for Up, D for Down, L for Left, R for Right): "
input: .space 2
inputAG: .asciiz "The input must be a letter A-G!"
input17: .asciiz "The input must be a number 1-7!"
inputUDLR: .asciiz "The input must be U,D,L or R!"
inside: .asciiz "The ship must be inside the 7x7 grid!"
notOverlap: .asciiz "The ship must not overlap with other ships!"
placed: .asciiz "The ship has been placed successfully!"
p1turn: .asciiz "Player1's turn"
p2turn: .asciiz "Player2's turn"
miss: .asciiz "MISS!"
hit: .asciiz "HIT!"
p1win: .asciiz "The game ended. Player 1 won the game!"
p2win: .asciiz "The game ended. Player 2 won the game!"
nowin: .asciiz "The game ended. No one won the game!"
p1guess: .asciiz "Player 1's guess: "
p2guess: .asciiz "Player 2's guess: "
guess: .byte 0:2

.text
main:
	la $a0,instruction
	li $a1,1
	li $v0,55
	syscall
	la $a0,cau1
	li $a1,1
	li $v0,55
	syscall
	la $s0,board1
	jal setupBoard
	la $a0,p1turn
	li $a1,1
	li $v0,55
	syscall
	la $s0,board1
	jal setupShips
	
	la $s0,board2
	jal setupBoard
	la $a0,p2turn
	li $a1,1
	li $v0,55
	syscall
	la $s0,board2
	jal setupShips
	
	jal writeBoards
	
	li $s2,0
	li $s3,0
	la $a0,cau2
	li $a1,1
	li $v0,55
	syscall
play:
	la $a0,p1turn
	li $a1,1
	li $v0,55
	syscall
	la $s0,board2
	li $s1,1
	jal guessShip
	
	la $a0,p2turn
	li $a1,1
	li $v0,55
	syscall
	la $s0,board1
	li $s1,2
	jal guessShip
	j play
	
writeBoards:
	la $a0,fileName
	li $a1,1
	li $a2,0
	li $v0,13
	syscall
	move $s6,$v0
	move $a0,$v0
	li $t0,1
	li $t1,3
	la $s5,header
while13:
	beq $t0,8,exit13
	mul $t2,$t1,$t0
	add $t2,$t2,$s5
	addi $t3,$t0,48
	sb $t3,0($t2)
	addi $t0,$t0,1
	j while13
exit13:
	li $t0,10
	sb $t0,22($s5)

	
	la $a1,p1Board
	li $a2,18
	li $v0,15
	syscall
	la $a1,header
	li $a2,23
	li $v0,15
	syscall
	la $s5,board1
	addi $a1,$s5,25
	li $a2,175
	li $v0,15
	syscall
	
	la $a1,p2Board
	li $a2,20
	li $v0,15
	syscall
	la $a1,header
	li $a2,23
	li $v0,15
	syscall
	la $s5,board2
	addi $a1,$s5,25
	li $a2,175
	li $v0,15
	syscall
	
	la $a1,endl
	li $a2,1
	li $v0,15
	syscall
	li $v0,15
	syscall
	jr $ra
	
endGame:
	move $a0,$s6
	la $a1,endl
	li $a2,1
	li $v0,15
	syscall
	la $a1,nowin
	li $a2,36
	li $v0,15
	syscall
	li $v0,16
	syscall
	li $v0,10
	syscall

guessShip:
f1:
	la $a0,askRow
	la $a1,input
	li $a2,2
	li $v0,54
	syscall
	beq $a1,0,f0
	beq $a1,-2,f2
	beq $a1,-3,f3
	beq $a1,-4,f4
f2:
	la $a0,quitGame
	li $v0,50
	syscall
	bne $a0,0,f1
	jal endGame
f3:
	la $a0,noInput
	li $a1,2
	li $v0,55
	syscall
	j f1
f4:
	la $a0,inputAG
	li $a1,2
	li $v0,55
	syscall
	j f1
f0:
	la $t0,input
	lb $t0,0($t0)
	slti $t1,$t0,65
	beq $t1,1,f4
	slti $t1,$t0,72
	beq $t1,0,f4
	move $t8,$t0		#row
	
g4:
	la $a0,askCol
	li $v0,51
	syscall
	beq $a1,0,g0
	beq $a1,-1,g1
	beq $a1,-2,g2
	beq $a1,-3,g3
g1:
	la $a0,input17
	li $a1,2
	li $v0,55
	syscall
	j g4
g2:
	la $a0,quitGame
	li $v0,50
	syscall
	bne $a0,0,g4
	jal endGame
g3:
	la $a0,noInput
	li $a1,2
	li $v0,55
	syscall
	j g4
g0:
	slti $t0,$a0,1
	beq $t0,1,g1
	slti $t0,$a0,8
	beq $t0,0,g1
	move $t9,$a0		#col
	
	la $s5,guess
	sb $t8,0($s5)
	addi $t9,$t9,48
	sb $t9,1($s5)
	addi $t9,$t9,-48
	
	beq $s1,2,p2
	la $a1,p1guess
	j p1
p2:
	la $a1,p2guess
p1:
	li $a2,18
	li $v0,15
	move $a0,$s6
	syscall
	la $a1,guess
	li $a2,2
	li $v0,15
	syscall
	la $a1,endl
	li $a2,1
	li $v0,15
	syscall
	
	li $t0,25
	li $t1,3
	addi $t2,$t8,-64
	mul $t2,$t2,$t0
	mul $t1,$t1,$t9
	add $t2,$t2,$t1
	add $t2,$t2,$s0
	lb $t0,0($t2)
	beq $t0,48,false
	beq $t0,49,true
false:
	la $a0,miss
	li $a1,0
	li $v0,55
	syscall
	jr $ra
true:
	la $a0,hit
	li $a1,1
	li $v0,55
	syscall
	li $t0,48
	sb $t0,0($t2)
	beq $s1,1,h1
	beq $s1,2,h2
h1:
	addi $s2,$s2,1
	beq $s2,16,h3
	jr $ra
h3:
	la $a0,p1win
	li $a1,1
	li $v0,55
	syscall

	move $a0,$s6
	la $a1,endl
	li $a2,1
	li $v0,15
	syscall
	la $a1,p1win
	li $a2,38
	li $v0,15
	syscall
	li $v0,16
	syscall
	
	li $v0,10
	syscall
h2:
	addi $s3,$s3,1
	beq $s3,16,h4
	jr $ra
h4:
	la $a0,p2win
	li $a1,1
	li $v0,55
	syscall
	
	move $a0,$s6
	la $a1,endl
	li $a2,1
	li $v0,15
	syscall
	la $a1,p1win
	li $a2,38
	li $v0,15
	syscall
	li $v0,16
	syscall
	
	li $v0,10
	syscall
	
	
	
setupBoard:
	li $t0,1
	li $t1,3
	li $t2,25
while1:
	beq $t0,8,exit1
	mul $t3,$t0,$t1
	addi $t3,$t3,2
	add $t3,$s0,$t3
	addi $t4,$t0,48
	sb $t4,0($t3)
	mul $t3,$t2,$t0
	add $t3,$t3,$s0
	addi $t4,$t0,64
	sb $t4,0($t3)
	li $t4,10
	sb $t4,-1($t3)
	addi $t0,$t0,1
	j while1
exit1:
	sb $0,199($s0)
	
	li $t0,48
	li $t1,25
	li $t2,1
while2:
	beq $t2,8,exit2
	li $t3,3
while3:
	beq $t3,24,exit3
	mul $t5,$t2,$t1
	add $t5,$t5,$t3
	add $t5,$t5,$s0
	sb $t0,0($t5)
	addi $t3,$t3,3
	j while3
exit3:
	addi $t2,$t2,1
	j while2
exit2:
	jr $ra
	
setupShips:
	li $s1,0
	li $s2,0
	li $s3,0
	li $s4,0	
while4:
	li $v0,55
	li $a1,1
	move $a0,$s0
	syscall
	beq $s1,6,exit4
a4:
	li $v0,51
	la $a0,askSize
	syscall
	beq $a1,0,a0
	beq $a1,-1,a1
	beq $a1,-2,a2
	beq $a1,-3,a3
a1:
	la $a0,input234
	li $a1,2
	li $v0,55
	syscall
	j a4
a2:
	la $a0,quitGame
	li $v0,50
	syscall
	bne $a0,0,a4
	jal endGame
a3:
	la $a0,noInput
	li $a1,2
	li $v0,55
	syscall
	j a4
a0:
	beq $a0,2,a5
	beq $a0,3,a6
	beq $a0,4,a7
	j a1
a5:
	bne $s2,3,a8
	la $a0,manyShip2
	li $a1,2
	li $v0,55
	syscall
	j a4
a6:
	bne $s3,2,a8
	la $a0,manyShip3
	li $a1,2
	li $v0,55
	syscall 
	j a4
a7:
	bne $s4,1,a8
	la $a0,manyShip4
	li $a1,2
	li $v0,55
	syscall
	j a4
a8:
	move $t7,$a0 #size

b1:
	la $a0,askRow
	la $a1,input
	li $a2,2
	li $v0,54
	syscall
	beq $a1,0,b0
	beq $a1,-2,b2
	beq $a1,-3,b3
	beq $a1,-4,b4
b2:
	la $a0,quitGame
	li $v0,50
	syscall
	bne $a0,0,b1
	jal endGame
b3:
	la $a0,noInput
	li $a1,2
	li $v0,55
	syscall
	j b1
b4:
	la $a0,inputAG
	li $a1,2
	li $v0,55
	syscall
	j b1
b0:
	la $t0,input
	lb $t0,0($t0)
	slti $t1,$t0,65
	beq $t1,1,b4
	slti $t1,$t0,72
	beq $t1,0,b4
	move $t8,$t0		#row
	
c4:
	la $a0,askCol
	li $v0,51
	syscall
	beq $a1,0,c0
	beq $a1,-1,c1
	beq $a1,-2,c2
	beq $a1,-3,c3
c1:
	la $a0,input17
	li $a1,2
	li $v0,55
	syscall
	j c4
c2:
	la $a0,quitGame
	li $v0,50
	syscall
	bne $a0,0,c4
	jal endGame
c3:
	la $a0,noInput
	li $a1,2
	li $v0,55
	syscall
	j c4
c0:
	slti $t0,$a0,1
	beq $t0,1,c1
	slti $t0,$a0,8
	beq $t0,0,c1
	move $t9,$a0		#col
	
d1:
	la $a0,askDir
	la $a1,input
	li $a2,2
	li $v0,54
	syscall
	beq $a1,0,d0
	beq $a1,-2,d2
	beq $a1,-3,d3
	beq $a1,-4,d4
d2:
	la $a0,quitGame
	li $v0,50
	syscall
	bne $a0,0,d1
	jal endGame
d3:
	la $a0,noInput
	li $a1,2
	li $v0,55
	syscall
	j d1
d4:
	la $a0,inputUDLR
	li $a1,2
	li $v0,55
	syscall
	j d1
d0:
	la $t0,input
	lb $t0,0($t0)
	beq $t0,85,up
	beq $t0,68,down
	beq $t0,76,left
	beq $t0,82,right
	j d4

outside:
	la $a0,inside
	li $a1,2
	li $v0,55
	syscall
	j a4
	
overlap:
	la $a0,notOverlap
	li $a1,2
	li $v0,55
	syscall
	j a4
	
insert:
	beq $t7,2,e2
	beq $t7,3,e3
	beq $t7,4,e4
e2:
	addi $s2,$s2,1
	j e1
e3:
	addi $s3,$s3,1
	j e1
e4:
	addi $s4,$s4,1
	j e1
e1:
	addi $s1,$s1,1
	la $a0,placed
	li $a1,1
	li $v0,55
	syscall
	j while4

up:
	sub $t0,$t8,$t7
	slti $t1,$t0,64
	beq $t1,1,outside
	addi $t0,$t8,-64
	sub $t1,$t0,$t7
	li $t2,25
	li $t3,3
while5:
	beq $t0,$t1,exit5
	mul $t4,$t0,$t2
	mul $t5,$t9,$t3
	add $t4,$t4,$t5
	add $t4,$t4,$s0
	lb $t4,0($t4)
	beq $t4,49,overlap
	addi $t0,$t0,-1
	j while5
exit5:
	addi $t0,$t8,-64
while6:
	beq $t0,$t1,insert
	mul $t4,$t0,$t2
	mul $t5,$t9,$t3
	add $t4,$t4,$t5
	add $t4,$t4,$s0
	li $t5,49
	sb $t5,0($t4)
	addi $t0,$t0,-1
	j while6

down:
	add $t0,$t7,$t8
	slti $t1,$t0,73
	beq $t1,0,outside
	addi $t0,$t8,-64
	add $t1,$t0,$t7
	li $t2,25
	li $t3,3
while7:
	beq $t0,$t1,exit7
	mul $t4,$t0,$t2
	mul $t5,$t9,$t3
	add $t4,$t4,$t5
	add $t4,$t4,$s0
	lb $t4,0($t4)
	beq $t4,49,overlap
	addi $t0,$t0,1
	j while7
exit7:
	addi $t0,$t8,-64
while8:
	beq $t0,$t1,insert
	mul $t4,$t0,$t2
	mul $t5,$t9,$t3
	add $t4,$t4,$t5
	add $t4,$t4,$s0
	li $t5,49
	sb $t5,0($t4)
	addi $t0,$t0,1
	j while8

left:
	sub $t0,$t9,$t7
	slti $t1,$t0,0
	beq $t1,1,outside
	addi $t2,$t8,-64
	li $t3,25
	li $t4,3
	mul $t2,$t2,$t3
	move $t1,$t9
while9:
	beq $t1,$t0,exit9
	mul $t5,$t1,$t4
	add $t5,$t5,$t2
	add $t5,$t5,$s0
	lb $t5,0($t5)
	beq $t5,49,overlap
	addi $t1,$t1,-1
	j while9
exit9:
	move $t1,$t9
while10:
	beq $t1,$t0,insert
	mul $t5,$t1,$t4
	add $t5,$t5,$t2
	add $t5,$t5,$s0
	li $t6,49
	sb $t6,0($t5)
	addi $t1,$t1,-1
	j while10
	
right:
	add $t0,$t9,$t7
	slti $t1,$t0,9
	beq $t1,0,outside
	addi $t2,$t8,-64
	li $t3,25
	li $t4,3
	mul $t2,$t2,$t3
	move $t1,$t9
while11:
	beq $t1,$t0,exit11
	mul $t5,$t1,$t4
	add $t5,$t5,$t2
	add $t5,$t5,$s0
	lb $t5,0($t5)
	beq $t5,49,overlap
	addi $t1,$t1,1
	j while11
exit11:
	move $t1,$t9
while12:
	beq $t1,$t0,insert
	mul $t5,$t1,$t4
	add $t5,$t5,$t2
	add $t5,$t5,$s0
	li $t6,49
	sb $t6,0($t5)
	addi $t1,$t1,1
	j while12
																
exit4:
	jr $ra