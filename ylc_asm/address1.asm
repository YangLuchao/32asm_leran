title	address1
;д����ָ�ʹ��ֱ��ƫ��Ѱַ��Uarray�е�4��ֵ�ֱ��͵�EAX,EBX,ECX,EDX�Ĵ�����
;����Щָ��֮����call DumpRegs�������ʾ�Ĵ���ʱ����Щ�Ĵ�����ֵӦ��������ʾ��
;EAX=FFFFFFFF EBX=FFFFFFFE  ECX=FFFFFFFD   EDX=FFFFFFFC
INCLUDE Irvine32.inc	
.data
Uarray word 1000h,2000h,3000h,4000h
Sarray sword -1,-2,-3,-4
.code
main proc
	mov ax,Sarray[0 * type sword]
	movsx eax,ax

	mov bx,Sarray[1 * type sword]
	movsx ebx,bx

	mov cx,Sarray[2 * type sword]
	movsx ecx,cx

	mov dx,Sarray[3 * type sword]
	movsx edx,dx

	call 	DumpRegs			;�ù�����irvine32.asm�У����õĺ������Ͷ��嶼��macros.inc
	exit						;��αָ����irvine32.inc�а�����smallwin.inc��
main endp
end main

