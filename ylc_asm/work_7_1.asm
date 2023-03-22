title ShowFileTime
;假设一个文件目录使用位0~4代表秒数目，秒数目是以2S为单位的，位5~10代表分钟，位11~15代表小时（24小时制）。
;如下面的二进制值以hh:mm:ss格式表示就是02:16:14
;00010 010000 00111
;写一个过程ShowFileTime，通过AX接收二进制文件时间值并以hh:mm:ss格式显示
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