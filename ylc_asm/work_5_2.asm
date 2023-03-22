title	
;以第4章编程练习6作为起点，写一个程序生成斐波那契数列的前47个值，
;把这47个值存储在一个双字数组中，并把双字数组写入一个磁盘文件。
;由于还没讲条件处理，因此不必进行任何文件I/O错误的检查。
;由于每个双字是4个字节，因此输出文件应该是188字节长。
;使用debug.exe或visual studio打开文件并检查文件的内容，应该如下所示：（十六进制数）
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
;创建文件
	lea 	edx,filename
	call 	CreateOutputFile
	cmp 	eax,INVALID_HANDLE_VALUE	
	je		over		;显示错误信息
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