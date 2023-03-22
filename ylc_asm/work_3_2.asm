title	work_3_2
; µœ÷EAX = -VAl2 + 7 - VAl3 + VAl1
.686P
.model	flat,stdcall
extern	DumpRegs@0:proc
ExitProcess proto,dwExitCode:dword	
.data
VAl1 SDWORD		8
VAl2 SDWORD		-15
VAl3 SDWORD		20
.code
main proc
	mov eax,val2
	call DumpRegs@0
	neg eax			;eax»°≤π
	call DumpRegs@0
	add eax,7
	call DumpRegs@0
	sub eax,val3
	call DumpRegs@0
	add eax,val1
	call DumpRegs@0

	push 0
	call ExitProcess

main endp
end main