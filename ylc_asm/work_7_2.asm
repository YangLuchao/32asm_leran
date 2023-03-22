title 多个双字的移位
;写一个过程，使用SHRD指令对5个32位整数进行整体移位操作，写一个程序测试你的过程，并对数组进行显示
INCLUDE Irvine32.inc
.686p
.data
array dword 12345678h,87654321h,11223344h,22334455h,33445566h
.code
main proc
	mov esi,0
	shr array[esi+16],1
	mov eax,array[esi+16]
	shrd array[esi+12],eax,1
	mov eax,array[esi+12]
	shrd array[esi+8],eax,1
	mov eax,array[esi+8]
	shrd array[esi+4],eax,1
	mov eax,array[esi+4]
	shrd array[esi],eax,1
over:
	exit
main endp
end main