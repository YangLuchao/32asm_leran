title	
;写一个程序，生成并显示50个-20~+20之间的随机整数
INCLUDE Irvine32.inc
.686p
.data
.code
main proc

	mov ecx,50
	call Randomize
	
next:
	mov eax,40
	call RandomRange
	sub eax,20
	call writeInt
	call crlf
	loop next

	exit	
main endp
end main