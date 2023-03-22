TITLE	ADD and SUB Project 
;include	irvine32.inc
.686P
.model	flat,stdcall
.stack	4096
extern	DumpRegs@0:proc
ExitProcess proto,dwExitCode:DWORD	
.code	
main proc	
	mov		eax,10000h
	add		eax,10000h
	sub		eax,10000h
;	call	DumpRegs
	call	DumpRegs@0			;该过程在irvine32.asm中，调用的宏声明和定义都在macros.inc
	;exit						;该伪指令在irvine32.inc中包含的smallwin.inc中
	push 0
	call ExitProcess
main endp
end main
	