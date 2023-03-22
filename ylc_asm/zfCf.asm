title	zf cf 
;写一个使用加法和减法指令来设置和清除零标志和符号标志的程序，
;在每条指令后插入call DumpRegs语句以显示寄存器和标志的值。
;使用注释解释每条指令是如何影响标志的。
.686P
.model	flat,stdcall
.stack	4096
extern	DumpRegs@0:proc
ExitProcess proto,dwExitCode:DWORD	
.code
main proc
	mov eax,1		;eax置1
	sub eax,1		;eax-1,zf=1

	call DumpRegs@0

	add eax,1		;eax+1,zf=0
	call DumpRegs@0

	xor eax,eax		;eax置零
	sub eax,1		;eax-1,sf=1
	call DumpRegs@0

	add eax,1		;eax+1,sf=0
	call DumpRegs@0

	push 0
	call ExitProcess
main endp
end main