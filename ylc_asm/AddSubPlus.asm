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
	call	DumpRegs@0			;�ù�����irvine32.asm�У����õĺ������Ͷ��嶼��macros.inc
	;exit						;��αָ����irvine32.inc�а�����smallwin.inc��
	push 0
	call ExitProcess
main endp
end main
	