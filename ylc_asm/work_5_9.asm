title	
;дһ�����������п��ܵ�ǰ���ͱ���ɫ��ϣ�16*16=256����ʾĳ���ַ���
;��ɫֵ��ȡֵ��Χ��0~15����˿���ʹ��һ��Ƕ�׵�ѭ�����������п��ܵ���ϡ�
INCLUDE Irvine32.inc
.686p
.data
.code
main proc

	mov esi,-1

next1:
	inc esi
	cmp esi,15
	ja	over
	mov edi,-1
next2:
	inc edi
	cmp edi,15
	ja next1
	imul eax,esi,16
	add eax,edi
	call SetTextColor
	mov al,'A'
	mov al,'A'
	call writechar		;��ʾ."A"
	jmp next2

over:	
	exit	
main endp
end main