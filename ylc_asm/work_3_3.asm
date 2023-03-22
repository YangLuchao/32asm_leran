title	work_3_3
;逆向复制字符串,写一个程序，使用LOOP指令和间接寻址方式把源字符串复制到目的字符串中，
;在复制过程中反转字符串的顺序，使用下面的变量定义：
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
	Mov edi,offset Target      		;变量的偏移
	Mov ecx,sizeof Target     		;计数器
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