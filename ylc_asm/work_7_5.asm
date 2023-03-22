TITLE Extended Addition Example           (ch07_07.asm)

; 功能：写一个过程IsPrime，如果通过EAX传递进来的32位整数是素数，则设置零标志（素数是只能被自身和1整除的数）。
; 优化循环，以使过程尽可能高效地运行。写一个测试程序，提示用户输入一个数字然后显示一条消息表明该数字是否是素数，
; 然后程序继续要求用户输入并调用IsPrime过程，以该种方式循环直到用户输入了-1退出为止。
; 说明：算法：先判断是否能是偶数，然后再判断3~N/2之间的奇数是否可以整除，还有更高效的算法可以实现。
; Last update: 07/14/2019

INCLUDE Irvine32.inc

.data
prompt  byte 'Please input 32-bit integer：',0
result1 byte 'It is a Prime Number？YES',0
result2 byte 'It is a Prime Number？NO',0
number  dword ?
.code
main PROC
        
NEXT:   ;显示提示输入信息
        mov edx,offset prompt
        call writestring

        call readint
        .if eax == -1           ;输入-1退出
            jmp OVER
        .endif
        mov number,eax
        ;判断是否是素数
        call IsPrime
        call CRLF
        jmp NEXT
OVER:
	exit
main endp
;===========================================================
;---------------------------------------------------------
IsPrime proc
;子程序名：IsPrime
;功能：判断素数
;入口参数：eax
;出口参数：无
        cdq
        mov ecx,2       ;除以2，判断是不是偶数
        div ecx
        .if (edx==0)    ;被整除
                mov edx,offset result2
                call writestring        ;提示不是素数
                jmp L3                  ;继续下一次循环
        .endif

;是奇数

        mov ebx,1
 L1:    mov eax,number
        cdq
        div ecx                         ;还是除以2
        add ebx,2
        ;商 > 3 ?
        .if (ebx < eax)                 
                mov eax,number          
                cdq
                div ebx                 ;再除以ebx+2
                cmp edx,0
                jz L2                   ;能除尽，是素数
                jmp L1                  ;不能除尽，再除以ebx+2
        .endif
        ;商<=3? 只有：1,3,5
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

