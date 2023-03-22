title	
;写一个程序，以所有可能的前景和背景色组合（16*16=256）显示某个字符。
;颜色值的取值范围是0~15，因此可以使用一个嵌套的循环来产生所有可能的组合。
INCLUDE Irvine32.inc
.686p
.data
.code
main proc

	mov esi,-1

next1:
	inc esi
	cmp esi,15
	ja	over
	mov edi,-1
next2:
	inc edi
	cmp edi,15
	ja next1
	imul eax,esi,16
	add eax,edi
	call SetTextColor
	mov al,'A'
	mov al,'A'
	call writechar		;显示."A"
	jmp next2

over:	
	exit	
main endp
end main