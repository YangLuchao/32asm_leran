;程序的描述：三个整数相减，三个16位整数相减，只需要使用寄存器即可，调用DumpRegs函数语句，显示寄存器的值。
;作者：
;创建日期：
;修改：
;日期：
;修改者：
INCLUDE Irvine32.inc
.code
main PROC
	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx

	mov ax,100
	mov bx,10
	mov cx,10

	sub ax,bx
	sub ax,cx

	call DumpRegs
	exit
	main ENDP
	
END main