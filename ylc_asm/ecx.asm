TITLE	ecx project;���̱���
.686P	;���¼���.686
.model	flat,stdcall;�ڴ�ƽ̹ģʽ�ͱ�׼����Լ��
.stack	4096;��ջ��4096��
extern	DumpRegs@0:proc	;��������ĺ���
ExitProcess proto	,dwExitCode:DWORD	;��������ĺ���
.code	;�����
main proc	
		mov eax,0								
      	mov ecx,10     ; outer loop counter	
L1:    	mov eax,3 
        push ecx
        mov ecx,5      ; inner loop counter	
L2:    	add eax,5							
       	loop L2        ; repeat innerloop\
        pop ecx
       	loop L1        ; repeat outer loop

        call DumpRegs@0

        push 0
        call ExitProcess
main    endp
end     main

