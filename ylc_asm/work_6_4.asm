title 加权概率
;写一个程序从三种颜色中随机选择一种并在屏幕上以该颜色显示文本。
;使用循环显示20行文本，每行文本的颜色都是随机选择的。选择每种颜色的概率如下:白色=30%，蓝色=10%，绿色=60%
;提示：可以生成一个0-9之间的随机整数，如果整数在0~2范围内，选择白色；如果整数等于3，选择蓝色；如果整数在4~9范围内，则选择绿色。
INCLUDE Irvine32.inc
.686p
.data
strVal byte 'abcdefghijklmnopqrstuvwxyz',0
.code
main proc

	mov ecx,20
	call Randomize

next:
	call crlf
	mov eax,9
	call RandomRange
	.if (eax >= 0) && (eax <= 2)
		mov eax,white
	.elseif eax == 3
		mov eax,blue
	.elseif (eax >= 4) && (eax <= 9)
		mov eax,green
	.endif
	call SetTextColor
	lea edx,strVal
	call writeString

	loop next
	
over:	
	exit	
main endp
end main