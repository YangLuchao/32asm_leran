TITLE Extended Addition Example           (ch07_07.asm)

; ���ܣ�дһ������IsPrime�����ͨ��EAX���ݽ�����32λ���������������������־��������ֻ�ܱ������1������������
; �Ż�ѭ������ʹ���̾����ܸ�Ч�����С�дһ�����Գ�����ʾ�û�����һ������Ȼ����ʾһ����Ϣ�����������Ƿ���������
; Ȼ��������Ҫ���û����벢����IsPrime���̣��Ը��ַ�ʽѭ��ֱ���û�������-1�˳�Ϊֹ��
; ˵�����㷨�����ж��Ƿ�����ż����Ȼ�����ж�3~N/2֮��������Ƿ�������������и���Ч���㷨����ʵ�֡�
; Last update: 07/14/2019

INCLUDE Irvine32.inc

.data
prompt  byte 'Please input 32-bit integer��',0
result1 byte 'It is a Prime Number��YES',0
result2 byte 'It is a Prime Number��NO',0
number  dword ?
.code
main PROC
        
NEXT:   ;��ʾ��ʾ������Ϣ
        mov edx,offset prompt
        call writestring

        call readint
        .if eax == -1           ;����-1�˳�
            jmp OVER
        .endif
        mov number,eax
        ;�ж��Ƿ�������
        call IsPrime
        call CRLF
        jmp NEXT
OVER:
	exit
main endp
;===========================================================
;---------------------------------------------------------
IsPrime proc
;�ӳ�������IsPrime
;���ܣ��ж�����
;��ڲ�����eax
;���ڲ�������
        cdq
        mov ecx,2       ;����2���ж��ǲ���ż��
        div ecx
        .if (edx==0)    ;������
                mov edx,offset result2
                call writestring        ;��ʾ��������
                jmp L3                  ;������һ��ѭ��
        .endif

;������

        mov ebx,1
 L1:    mov eax,number
        cdq
        div ecx                         ;���ǳ���2
        add ebx,2
        ;�� > 3 ?
        .if (ebx < eax)                 
                mov eax,number          
                cdq
                div ebx                 ;�ٳ���ebx+2
                cmp edx,0
                jz L2                   ;�ܳ�����������
                jmp L1                  ;���ܳ������ٳ���ebx+2
        .endif
        ;��<=3? ֻ�У�1,3,5
        mov edx,offset result1          
        call writestring
        jmp L3
L2:     
        mov edx,offset result2
        call writestring        
L3:
        ret
IsPrime endp
end main

