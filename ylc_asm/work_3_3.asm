title	work_3_3
;�������ַ���,дһ������ʹ��LOOPָ��ͼ��Ѱַ��ʽ��Դ�ַ������Ƶ�Ŀ���ַ����У�
;�ڸ��ƹ����з�ת�ַ�����˳��ʹ������ı������壺
;INCLUDE Irvine32.inc
.686P
.model	flat,stdcall
extern	DumpMem@0:proc
ExitProcess proto,dwExitCode:dword	
.data	
Source byte "This is the source string",0
Target byte sizeof source dup("#")
.code	
main proc
	Mov edi,offset Target      		;������ƫ��
	Mov ecx,sizeof Target     		;������
	mov esi,-1
	dec edi
next:
	inc esi
	dec edi
	mov al,[edi]
	mov Target[esi],al
	loop next

	call DumpMem@0
	;exit
	push 0
	call ExitProcess
main endp
end main