title ��Ȩ����
;дһ�������������ɫ�����ѡ��һ�ֲ�����Ļ���Ը���ɫ��ʾ�ı���
;ʹ��ѭ����ʾ20���ı���ÿ���ı�����ɫ�������ѡ��ġ�ѡ��ÿ����ɫ�ĸ�������:��ɫ=30%����ɫ=10%����ɫ=60%
;��ʾ����������һ��0-9֮���������������������0~2��Χ�ڣ�ѡ���ɫ�������������3��ѡ����ɫ�����������4~9��Χ�ڣ���ѡ����ɫ��
INCLUDE Irvine32.inc
.686p
.data
strVal byte 'abcdefghijklmnopqrstuvwxyz',0
.code
main proc

	mov ecx,20
	call Randomize

next:
	call crlf
	mov eax,9
	call RandomRange
	.if (eax >= 0) && (eax <= 2)
		mov eax,white
	.elseif eax == 3
		mov eax,blue
	.elseif (eax >= 4) && (eax <= 9)
		mov eax,green
	.endif
	call SetTextColor
	lea edx,strVal
	call writeString

	loop next
	
over:	
	exit	
main endp
end main