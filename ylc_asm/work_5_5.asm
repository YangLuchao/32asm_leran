title	
;дһ���������ɲ���ʾ50��-20~+20֮����������
INCLUDE Irvine32.inc
.686p
.data
.code
main proc

	mov ecx,50
	call Randomize
	
next:
	mov eax,40
	call RandomRange
	sub eax,20
	call writeInt
	call crlf
	loop next

	exit	
main endp
end main