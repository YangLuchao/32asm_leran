title ShowFileTime
;����һ���ļ�Ŀ¼ʹ��λ0~4��������Ŀ������Ŀ����2SΪ��λ�ģ�λ5~10������ӣ�λ11~15����Сʱ��24Сʱ�ƣ���
;������Ķ�����ֵ��hh:mm:ss��ʽ��ʾ����02:16:14
;00010 010000 00111
;дһ������ShowFileTime��ͨ��AX���ն������ļ�ʱ��ֵ����hh:mm:ss��ʽ��ʾ
INCLUDE Irvine32.inc
.686p
.data
.code
main proc
	xor eax,eax
	mov ax,0001001000000111b
	call showFileTime	
over:
	exit
main endp

showFileTime proc
	mov edx,eax
	xor eax,eax
	shld ax,dx,5
	call writeDec
	mov ax,':'
	call writechar
	xor ax,ax
	shld ax,dx,11
	and ax,1111111b
	call writeDec
	mov ax,':'
	call writechar
	mov eax,edx
	and ax,11111b
	imul ax,2
	call writeDec
	
	ret
showFileTime endp
end main