title	work_5_1
;дһ�����򣬵��ñ������ӿ��е�SetTextColor���̣���4�ֲ�ͬ����ɫ��ʾͬһ���ַ�����Ҫ��ʹ��һ��ѭ��
INCLUDE Irvine32.inc
.686P
.code
main proc
	call Randomize
	mov ecx,4

next:
	xor eax,eax
	xor ebx,ebx
	mov eax,16	;�������Χ
	call RandomRange	;��ȡ�����
	mov ebx,eax	;�����1
	imul ebx,16
	mov eax,16	;�������Χ
	call RandomRange	;��ȡ�����
	add eax,ebx
	call SetTextColor
	mov al,'a'
	call WriteChar

	loop next
	add eax,15
	call SetTextColor
	exit
main endp
end main