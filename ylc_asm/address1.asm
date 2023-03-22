title	address1
;写几条指令，使用直接偏移寻址将Uarray中的4个值分别送到EAX,EBX,ECX,EDX寄存器中
;在这些指令之后用call DumpRegs语句以显示寄存器时，这些寄存器的值应该如下所示：
;EAX=FFFFFFFF EBX=FFFFFFFE  ECX=FFFFFFFD   EDX=FFFFFFFC
INCLUDE Irvine32.inc	
.data
Uarray word 1000h,2000h,3000h,4000h
Sarray sword -1,-2,-3,-4
.code
main proc
	mov ax,Sarray[0 * type sword]
	movsx eax,ax

	mov bx,Sarray[1 * type sword]
	movsx ebx,bx

	mov cx,Sarray[2 * type sword]
	movsx ecx,cx

	mov dx,Sarray[3 * type sword]
	movsx edx,dx

	call 	DumpRegs			;该过程在irvine32.asm中，调用的宏声明和定义都在macros.inc
	exit						;该伪指令在irvine32.inc中包含的smallwin.inc中
main endp
end main

