title	
;写一个程序，生成并显示20个随机字符串，每个字符串包含10个大写字母（A~Z）.
INCLUDE Irvine32.inc
.686p
.data
.code
main proc
	mov esi,-1
	
	call Randomize
	
next1:
	inc esi
	cmp esi,20
	jz over
	mov ecx,20;每行字符串20个字符
	mov edi,-1
next2:
	inc edi
	.if edi < 10
		mov eax,24
	.else
		mov eax,5eh
	.endif
	call RandomRange
	.if edi < 10
		add eax,41h
	.else
		add eax,20h
	.endif
	call writeChar
	
	loop next2

	call crlf
	jmp next1

over:
	exit	
main endp
end main