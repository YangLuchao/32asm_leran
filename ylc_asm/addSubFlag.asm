title	add sub flag
;дһ��ʹ�üӷ��ͼ���ָ�������ú������λ��־�ĳ�����ÿ��ָ������call DumpRegs�������ʾ�Ĵ����ͱ�־��ֵ��
;ʹ��ע�ͽ���ÿ��ָ�������Ӱ���־��
.686P	
.model	flat,stdcall
.stack	4096
extern	DumpRegs@0:proc	
ExitProcess proto	,dwExitCode:DWORD	
.code	
main proc	
	
	mov eax	,0FFFFFFFFh	;��eaxΪ���ֵ
	mov ebx, 1			;��ebxΪ1
	mov ecx,1			;��ecxΪ1

	add eax	,ebx		;��ӣ���λ����1
	call DumpRegs@0

	add eax	,ecx		;��ӣ���λ����0
	call DumpRegs@0

	push 0
	call ExitProcess


main endp
end	 main