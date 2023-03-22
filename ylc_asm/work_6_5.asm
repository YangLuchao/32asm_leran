title 
INCLUDE Irvine32.inc
.686p
.data
tmp dword 0
.code
main proc
	mov edx,0
	mov eax,1

	mov esi,-1
next:
	inc esi
	cmp esi,2
	jb  next
	cmp esi,0ffffffffh
	jz  over
	call crlf
	mov tmp,eax
	add eax,edx
	jc	over
	call writeInt
	mov edx,tmp
	jmp next

over:
	exit	
main endp
end main