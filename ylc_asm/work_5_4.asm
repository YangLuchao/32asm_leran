title	
;дһ���������������Ļ���ѹ�궨λ����Ļ���м�λ�ã�Ȼ����ʾ��������������������������Ӳ���ʾ�͡�
INCLUDE Irvine32.inc

.686p
.data
tx1 byte 'place input number!',0
tx2 byte 'length max 10!',0
buff1 byte 10 dup(0);�ֻ������10λ����
buff2 byte 10 dup(0);�ֻ������10λ����
bufInfo CONSOLE_SCREEN_BUFFER_INFO <>
consoleOutHandle DWORD ?
intVal1 SDWORD ?
intVal2 SDWORD ?
.code
main proc

	mov ecx,3

next:
	push ecx
	call Clrscr	;����
	xor			edx,edx
	call		GetMaxXY
	shr			dh,1
	shr			dl,1
	call		Gotoxy				;��λ���
	push		dx
	call		ReadInt
	mov			intVal1,eax
	call		Crlf
	pop			dx
	add			dh,1
	call		Gotoxy
	push		dx
	call		ReadInt
	call		Crlf
	pop			dx
	add			dh,1
	call		Gotoxy
	add			eax,intVal1
	call		writeInt
	call		Crlf
	call		WaitMsg
	pop			ecx
	loop		next

	exit	
main endp
end main