title ���ٳ˷�
;дһ������FastMultiply����һ�������32λ�޷���������EAX��ˣ�Ҫ��ֻʹ����λ�ͼӷ�ָ�
;ʹ��EBX�Ĵ�������̴�����������EAX�Ĵ����з��س˻���
;дһ��С���Գ��򣬵��øù��̲���ʾ�˻�������˻���Զ���ᳬ��32λ����
INCLUDE Irvine32.inc
.686p
.data

.code
main proc
        mov eax,10
        mov ebx,12345678h
        call FastMultiply
        call writedec
over:
	exit
main endp

FastMultiply proc
    mov eax,ebx
    shl ebx,3
    shl eax,1
    add eax,ebx
	
	ret
FastMultiply endp
end main