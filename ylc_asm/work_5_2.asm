title	
;�Ե�4�±����ϰ6��Ϊ��㣬дһ����������쳲��������е�ǰ47��ֵ��
;����47��ֵ�洢��һ��˫�������У�����˫������д��һ�������ļ���
;���ڻ�û������������˲��ؽ����κ��ļ�I/O����ļ�顣
;����ÿ��˫����4���ֽڣ��������ļ�Ӧ����188�ֽڳ���
;ʹ��debug.exe��visual studio���ļ�������ļ������ݣ�Ӧ��������ʾ����ʮ����������
INCLUDE Irvine32.inc
.686P
len = 47
.data
hand DWORD ?
filename BYTE "file.dat",0
tmp_buff dword len dup(0)
BUFFER_SIZE = ($ - tmp_buff)
tmp byte 0
.code
main proc
;�����ļ�
	lea 	edx,filename
	call 	CreateOutputFile
	cmp 	eax,INVALID_HANDLE_VALUE	
	je		over		;��ʾ������Ϣ
	mov 	hand,eax

	mov dl,0
	mov dh,1

	mov esi,-1
next:
	inc esi
	cmp esi,2
	movzx eax,dh
	;mov ebx,ds
	mov tmp_buff[size dword * esi],eax
	jb  next
	cmp esi,len
	jz  next2
	mov tmp,dh
	add dh,dl
	movzx eax,dh
	mov tmp_buff[size dword * esi],eax
	mov dl,tmp
	jmp next

next2:
	mov eax,hand
	lea edx,tmp_buff
	mov ecx,BUFFER_SIZE
	call WriteToFile
over:
	exit
main endp
end main