title	work_5_1
;写一个程序，调用本书连接库中的SetTextColor过程，以4种不同的颜色显示同一个字符串，要求使用一个循环
INCLUDE Irvine32.inc
.686P
.code
main proc
	call Randomize
	mov ecx,4

next:
	xor eax,eax
	xor ebx,ebx
	mov eax,16	;随机数范围
	call RandomRange	;获取随机数
	mov ebx,eax	;随机数1
	imul ebx,16
	mov eax,16	;随机数范围
	call RandomRange	;获取随机数
	add eax,ebx
	call SetTextColor
	mov al,'a'
	call WriteChar

	loop next
	add eax,15
	call SetTextColor
	exit
main endp
end main