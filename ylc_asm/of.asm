title	of
;дһ��ʹ�üӷ��ͼ���ָ�����ú���������־�ĳ���
;��ÿ��ָ������call DumpRegs�������ʾ�Ĵ����ͱ�־��ֵ��
;ʹ��ע�ͽ���ÿ��ָ�������Ӱ���־�ġ�
;����Ҫ����һ��ͬʱ���ý�λ��־�������־�ļӷ�ָ�
.686P
.model	flat,stdcall
.stack 4096
extern	DumpRegs@0:proc	
ExitProcess proto,dwExitCode:DWORD	
.code
main proc
	mov		eax,0FFFFFFFFh			;��eaxΪ���ֵ
	mov		ebx,2
	mul		ebx						;eax*2, cf=1 of=1
	call	DumpRegs@0

	add eax,1
	call DumpRegs@0		;eax+1,cf=0 of=0

	push 0
	call ExitProcess
main endp
end main