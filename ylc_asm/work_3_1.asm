title	work_3_1
;дһ������ʹ��ѭ��������쳲��������е�ǰ12��ֵ��1��1��2��3��5��8��13��������
;��ѭ���аѼ���õ���������EAX�Ĵ���������call DumpRegs�������ʾ�Ĵ���
;F(0)=0��F(1)=1, F(n)=F(n - 1)+F(n - 2)��n �� 2��n �� N*��
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