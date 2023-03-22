title	
;写一个程序，在100个随机的屏幕位置显示一个字符，在显示字符时使用100ms的延迟。提示：使用GetMaxXY过程确定当前控制台窗口的大小
INCLUDE Irvine32.inc
.686p
.data
.code
main proc
	
	call Randomize
	mov ecx,100

	call GetMaxXY	;获取长宽
	
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
	call writechar		;显示."A"
	mov 	eax,100	;0.1s
	call 	Delay
	pop dx
	loop next
	
	exit	
main endp
end main