title tmp
.386P
.model flat,stdcall
.data
	val1 byte	'abcdefg'
.code
main proc
	xor eax,eax
	mov al,'f'
	cld
	lea edi,val1
	mov ecx,lengthof val1
	repnz scasb
	mov bl,'a'
main endp
end main