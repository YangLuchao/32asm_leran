title	
;дһ��������100���������Ļλ����ʾһ���ַ�������ʾ�ַ�ʱʹ��100ms���ӳ١���ʾ��ʹ��GetMaxXY����ȷ����ǰ����̨���ڵĴ�С
INCLUDE Irvine32.inc
.686p
.data
.code
main proc
	
	call Randomize
	mov ecx,100

	call GetMaxXY	;��ȡ����
	
next:
	push dx
	movzx eax,dh
	call RandomRange
	mov dh,al
	movzx eax,dl
	call RandomRange
	mov dl,al
	call Gotoxy
	mov al,'A'
	call writechar		;��ʾ."A"
	mov 	eax,100	;0.1s
	call 	Delay
	pop dx
	loop next
	
	exit	
main endp
end main