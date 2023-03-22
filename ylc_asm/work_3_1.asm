title	work_3_1
;写一个程序，使用循环来计算斐波那契数列的前12个值（1，1，2，3，5，8，13，…）。
;在循环中把计算得到的数字送EAX寄存器并调用call DumpRegs语句以显示寄存器
;F(0)=0，F(1)=1, F(n)=F(n - 1)+F(n - 2)（n ≥ 2，n ∈ N*）
.686P
.model	flat,stdcall
extern	DumpRegs@0:proc	
ExitProcess proto,dwExitCode:dword	
.data
tmp byte 0
.code
main proc
	mov dl,0
	mov dh,1

	mov esi,-1
next:
	inc esi
	cmp esi,2
	jb  next
	cmp esi,12
	jz  over
	mov tmp,dh
	add dh,dl
	movzx eax,dh
	call DumpRegs@0
	mov dl,tmp
	jmp next

over:
	push 0
	CALL ExitProcess
main endp
end main