title ��Ȩ����
INCLUDE Irvine32.inc
tmp1 proto val1:byte
.686p
.data
.code
;дһ������Ҫ���û�����һ��0~100֮��ĸ���ֵ������ǰ��Ĺ���30�Σ�ÿ�ε���ʱ����̴����û�����ĸ���ֵ���ڹ��̷��غ���ʾ���־��ֵ
main proc
	mov ecx,30

next:
	call crlf
	call Randomize
	mov eax,100
	call randomrange
	invoke	tmp1,al
	jz over
	call writeint
	loop next
over:
	exit
main endp
; дһ�����̽���0~100֮���һ������N���ڸù��̱����õ�ʱ��Ӧ����N/100�ĸ���������־
tmp1 proc uses eax, val1:byte
	xor eax,eax	;cf��1
	call Randomize
	mov eax,100
	call randomrange
	.if val1 > al	;N/100�ĸ��ʽ�cf���
		add eax,1
	.endif
	ret
tmp1 endp
end main