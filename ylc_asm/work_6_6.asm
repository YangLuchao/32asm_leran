title 加权概率
INCLUDE Irvine32.inc
tmp1 proto val1:byte
.686p
.data
.code
;写一个程序要求用户输入一个0~100之间的概率值，调用前面的过程30次，每次调用时向过程传递用户输入的概率值并在过程返回后显示零标志的值
main proc
	mov ecx,30

next:
	call crlf
	call Randomize
	mov eax,100
	call randomrange
	invoke	tmp1,al
	jz over
	call writeint
	loop next
over:
	exit
main endp
; 写一个过程接收0~100之间的一个整数N，在该过程被调用的时候，应该有N/100的概率清除零标志
tmp1 proc uses eax, val1:byte
	xor eax,eax	;cf置1
	call Randomize
	mov eax,100
	call randomrange
	.if val1 > al	;N/100的概率将cf清空
		add eax,1
	.endif
	ret
tmp1 endp
end main