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

	call Clrscr	;����
	; ��ȡ��׼������
	;INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	; ����ȡ�ľ�����뵽������
	;mov consoleOutHandle,eax
	; ��ȡ����̨��������С������
	;INVOKE	GetConsoleScreenBufferInfo, consoleOutHandle,ADDR bufInfo
	;mov		ax,bufInfo.dwSize.X	; ����̨�Ŀ��
	;shr		ax,1				;����2
	;mov		bx,bufInfo.dwSize.Y	; ����̨�ĸ߶�
	;shr		bx,1				;����2
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

	exit	
main endp
end main