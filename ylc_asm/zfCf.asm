title	zf cf 
;дһ��ʹ�üӷ��ͼ���ָ�������ú�������־�ͷ��ű�־�ĳ���
;��ÿ��ָ������call DumpRegs�������ʾ�Ĵ����ͱ�־��ֵ��
;ʹ��ע�ͽ���ÿ��ָ�������Ӱ���־�ġ�
.686P
.model	flat,stdcall
.stack	4096
extern	DumpRegs@0:proc
ExitProcess proto,dwExitCode:DWORD	
.code
main proc
	mov eax,1		;eax��1
	sub eax,1		;eax-1,zf=1

	call DumpRegs@0

	add eax,1		;eax+1,zf=0
	call DumpRegs@0

	xor eax,eax		;eax����
	sub eax,1		;eax-1,sf=1
	call DumpRegs@0

	add eax,1		;eax+1,sf=0
	call DumpRegs@0

	push 0
	call ExitProcess
main endp
end main