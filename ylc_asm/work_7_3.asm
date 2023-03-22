title 快速乘法
;写一个过程FastMultiply，将一个任意的32位无符号整数与EAX相乘，要求只使用移位和加法指令。
;使用EBX寄存器向过程传递整数并在EAX寄存器中返回乘积。
;写一个小测试程序，调用该过程并显示乘积（假设乘积永远不会超过32位）。
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