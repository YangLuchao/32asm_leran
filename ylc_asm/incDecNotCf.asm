title	inc dec not cf
;写一个小程序，说明INC和DEC指令不影响进位标志
.686P
.model	flat,stdcall
.stack	4096
extern	DumpRegs@0:proc	
ExitProcess proto	,dwExitCode:DWORD	
.data	
arrayB byte  'abc'
.code
main proc
	
	xor esi,esi

	inc esi
	movzx eax,arrayB[esi]
	call DumpRegs@0

	dec esi
	movzx eax,arrayB[esi]
	call DumpRegs@0

	push 0
	call ExitProcess

main endp
end	main