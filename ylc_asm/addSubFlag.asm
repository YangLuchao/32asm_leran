title	add sub flag
;写一个使用加法和减法指令来设置和清除进位标志的程序，在每条指令后插入call DumpRegs语句以显示寄存器和标志的值。
;使用注释解释每条指令是如何影响标志的
.686P	
.model	flat,stdcall
.stack	4096
extern	DumpRegs@0:proc	
ExitProcess proto	,dwExitCode:DWORD	
.code	
main proc	
	
	mov eax	,0FFFFFFFFh	;置eax为最大值
	mov ebx, 1			;置ebx为1
	mov ecx,1			;置ecx为1

	add eax	,ebx		;相加，进位符置1
	call DumpRegs@0

	add eax	,ecx		;相加，进位符置0
	call DumpRegs@0

	push 0
	call ExitProcess


main endp
end	 main