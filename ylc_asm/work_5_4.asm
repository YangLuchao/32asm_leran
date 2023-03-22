title	
;写一个程序，首先清除屏幕并把光标定位在屏幕的中间位置，然后提示用于输入两个整数，把它们相加并显示和。
INCLUDE Irvine32.inc

.686p
.data
tx1 byte 'place input number!',0
tx2 byte 'length max 10!',0
buff1 byte 10 dup(0);最长只能输入10位整数
buff2 byte 10 dup(0);最长只能输入10位整数
bufInfo CONSOLE_SCREEN_BUFFER_INFO <>
consoleOutHandle DWORD ?
intVal1 SDWORD ?
intVal2 SDWORD ?
.code
main proc

	mov ecx,3

next:
	push ecx
	call Clrscr	;清屏
	xor			edx,edx
	call		GetMaxXY
	shr			dh,1
	shr			dl,1
	call		Gotoxy				;定位光标
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