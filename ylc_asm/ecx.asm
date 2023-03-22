TITLE	ecx project;工程标题
.686P	;向下兼容.686
.model	flat,stdcall;内存平坦模式和标准调用约定
.stack	4096;堆栈段4096长
extern	DumpRegs@0:proc	;声明所需的函数
ExitProcess proto	,dwExitCode:DWORD	;声明所需的函数
.code	;代码段
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

