;����������������������������16λ���������ֻ��Ҫʹ�üĴ������ɣ�����DumpRegs������䣬��ʾ�Ĵ�����ֵ��
;���ߣ�
;�������ڣ�
;�޸ģ�
;���ڣ�
;�޸��ߣ�
INCLUDE Irvine32.inc
.code
main PROC
	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx

	mov ax,100
	mov bx,10
	mov cx,10

	sub ax,bx
	sub ax,cx

	call DumpRegs
	exit
	main ENDP
	
END main