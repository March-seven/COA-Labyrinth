# 数据准备
   .data
Data2: .word  0xffffffff,0x00000000,0x00000000,0x00000000,
		0x994ebeb7,0x80008085,0x9ffdfffd,0x90041005,
		0x97ddf405,0xd44517f5,0xd5755445,0xc5454575,
		0xd5dd7d15,0xd4010515,0x940107d5,0x9fdfe057,
		0x84510051,0xbd75fd11,0xa11405f1,0xafd7dd19,
		0xa1144149,0xb7357778,0x91211549,0xd93fd159,
		0x89041141,0x99f47f5d,0x88500045,0xe955d5f5,
		0x89145455,0x99ffdfdd,0x80040011,0xffffffff
		
Data1: .word  0xffffffff,0x80080885,0xff7beabd,0x914a2210,
		0x994ebeb7,0x80008085,0x9ffdfffd,0x90041005,
		0x97ddf405,0xd44517f5,0xd5755445,0xc5454575,
		0xd5dd7d15,0xd4010515,0x940107d5,0x9fdfe057,
		0x84510051,0xbd75fd11,0xa11405f1,0xafd7dd19,
		0xa1144149,0xb7357778,0x91211549,0xd93fd159,
		0x89041141,0x99f47f5d,0x88500045,0xe955d5f5,
		0x89145455,0x99ffdfdd,0x80040011,0xffffffff
		

		
Successdata:.word  
		0x00000000,0x00000000,0x00000000,0x00000000,
		0x00000000,0x00000000,0x00000000,0x00000000,
		0x00000000,0x00000000,0x00000000,0xffffffff,
		0x00000000,0x35337334,0x45444444,0x45444444,
		0x25447224,0x15444114,0x15444110,0x62337664,
		0x00000000,0xffffffff,0x00000000,0x00000000,
		0x00000000,0x00000000,0x00000000,0x00000000,
		0x00000000,0x00000000,0x00000000,0x00000000,
		
	
Row: .word    0x40000000                 
   .text

start:
addi $12,$0,1
la $7,Data1
addi $1,$0,-1
addi $9,$0,31

interface:
addi $1,$1,1
lw $2,0($7)
addi $7,$7,4
beq $1,$9,step1
j interface

step1:
la $7,Data1  			#
addi $7,$7,4			#迷宫所在行地址
lw $3,0($7)			#迷宫所在行信息
addi $5,$0,1			#迷宫所在行

la $8,Row			#物体地址
lw $4,0($8)			#物体信息
addi $6,$0,1			#物体所在行

or $3,$3,$4			
sw $3,0($7)			#保存运算结果

addi $1,$5,0
lw $2,0($7)			#信息输入外设			
loop:
beq $0,$0,loop		#原地循环
################上移判断################
up:
addi $10,$7,0              #另存迷宫你所在行的地址
addi $11,$3,0		      #另存迷宫所在行的信息

addi $7,$7,-4			#迷宫up行所在地址
lw $3,0($7)			#迷宫up所在行信息
addi $5,$5,-1			#迷宫up所在行

and $9,$3,$4			#判断与up是否相撞

beq $9,$0,moveup		#不相撞则跳转至moveup
noup:
addi $7,$7,4			
lw $3,0($7)
addi $5,$5,1			#恢复到迷宫原来的信息
j endup
moveup:
sub $11,$11,$4		#移动后的原先行信息变化
sw $11,0($10)			#保存移动后的原先行信息变化

addi $1,$5,1
lw $2,0($10)			#信息输入外设	

or $3,$3,$4			#移动后up行信息
sw $3,0($7)			#保存up行的信息

addi $1,$5,0			
lw $2,0($7)			#信息输入外设

addi $6,$6,-1			#物体所在行
endup:
eret

################下移判断################
down:
addi $10,$7,0              #另存迷宫你所在行的地址
addi $11,$3,0		#另存迷宫所在行的信息

addi $7,$7,4			#迷宫down行所在地址
lw $3,0($7)			#迷宫down所在行信息
addi $5,$5,1			#迷宫down所在行

and $9,$3,$4			#判断与down是否相撞
beq $9,$0,movedown		#不相撞则跳转至movedown
nodown:
addi $7,$7,-4			
lw $3,0($7)
addi $5,$5,-1			#恢复迷宫原来的信息
j enddown
movedown:
sub $11,$11,$4		#移动后的原先行信息变化
sw $11,0($10)			#保存移动后的原先行信息变化

addi $1,$5,-1			
lw $2,0($10)			#信息输入外设

or $3,$3,$4			#移动后down行信息
sw $3,0($7)			#保存down行的信息

addi $6,$6,1			#物体所在行
addi $1,$5,0			
lw $2,0($7)			#信息输入外设
enddown:
eret

################左移判断################
left:
sll $10,$4,1			#将物体信息左移
and $9,$3,$10   		#判断与left是否相撞
beq $9,$0,moveleft
noleft:
j endleft
moveleft:
sub $3,$3,$4			#取出物体
sll $4,$4,1			#物体左移
sw $4,0($8)			#保存物体信息
or $3,$3,$4			#物体放入迷宫
sw $3,0($7)			#保存迷宫所在行信息

addi $1,$5,0			
lw $2,0($7)			#信息输入外设
endleft:
eret

################右移判断################
right:
srl $10,$4,1			#将物体信息右移
and $9,$3,$10   		#判断与right是否相撞
beq $9,$0,moveright
noright:
j endright
moveright:
sub $3,$3,$4			#取出物体
srl $4,$4,1			#物体右移
sw $4,0($8)			#保存物体信息
or $3,$3,$4			#物体放入迷宫
sw $3,0($7)			#保存迷宫所在行信息

addi $1,$5,0			
lw $2,0($7)			#信息输入外设
beq $4,$12,success
endright:
eret
################找到出口判断################
success:
endstart:
addi $12,$0,1
la $7,Successdata
addi $1,$0,-1
addi $9,$0,31

endinterface:
addi $1,$1,1
lw $2,0($7)
addi $7,$7,4
beq $1,$9,endsuccess
j endinterface

endsuccess:
eret

