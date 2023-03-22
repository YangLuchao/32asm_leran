title	of
;写一个使用加法和减法指令设置和清除溢出标志的程序，
;在每条指令后插入call DumpRegs语句以显示寄存器和标志的值。
;使用注释解释每条指令是如何影响标志的。
;程序要包含一条同时设置进位标志和溢出标志的加法指令。
.686P
.model	flat,stdcall
.stack 4096
extern	DumpRegs@0:proc	
ExitProcess proto,dwExitCode:DWORD	
.code
main proc
	mov		eax,0FFFFFFFFh			;置eax为最大值
	mov		ebx,2
	mul		ebx						;eax*2, cf=1 of=1
	call	DumpRegs@0

	add eax,1
	call DumpRegs@0		;eax+1,cf=0 of=0

	push 0
	call ExitProcess
main endp
end main