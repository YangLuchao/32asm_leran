title ��дһ��������ʵ�ּ򵥵Ĳ����������Ĺ��ܣ������Ķ�����32λ��������ʾһ���˵������û����±���ѡ��
INCLUDE Irvine32.inc
.686p
.data
ts1 byte 'please choose what you need!',0
ts2 byte '1:x AND y',0
ts3 byte '2:x OR y',0
ts4 byte '3:x XOR y',0
ts5 byte '4:NOT x',0
ts6 byte 'input x hex:',0
ts7 byte 'input y hex:',0
ts8 byte 'result: ',0
select byte 0
xVal dword	0
yVal dword 0
result dword 0
.code
main proc

	lea edx,ts1
	call WriteString
	call crlf
	lea edx,ts2
	call WriteString
	call crlf
	lea edx,ts3
	call WriteString
	call crlf
	lea edx,ts4
	call WriteString
	call crlf
	lea edx,ts5
	call WriteString
	call crlf
	call ReadChar
	mov select,al
	call WriteChar
	call crlf
	lea edx,ts6
	call WriteString
	call ReadHex
	mov xVal,eax
	call crlf
	mov al,select
	.if (al == '1')||(al == '2')||(al == '3')
		lea edx,ts7
		call WriteString
		call ReadHex
		mov yVal,eax
		call crlf
	.endif
	mov al,select
	mov ebx,yVal
	.if al == '1'
		mov eax,xVal
		and eax,ebx
	.elseif al == '2'
		mov eax,xVal
		or eax,ebx
	.elseif al == '3'
		mov eax,xVal
		xor eax,ebx
	.elseif al == '4'
		mov eax,xVal
		not eax
	.endif
	call WriteHex

over:	
	exit	
main endp
end main