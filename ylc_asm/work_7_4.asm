title 最大公约数
;int GCD(int x, int y)
;{
;	x = abs(x) ;       // absolute value
;    y = abs(y) ;
;    do {
;        int n = x % y;
;        x = y;
;        y = n;
;    } while (y > 0);
;    return x;
;}
INCLUDE Irvine32.inc
gcd proto, x:sdword,y:sdword
.686p
.data
.code
main proc

	invoke gcd  ,100,20
	call writedec
	call crlf

	invoke gcd  ,1230,24
	call writedec
	call crlf

	invoke gcd  ,142340,253
	call writedec
	call crlf

	invoke gcd  ,12342230,243
	call writedec
	call crlf

	exit
main endp

gcd proc uses ebx, x:sdword,y:sdword	
	LOCAL	x_local:DWORD	,y_local:DWORD
	mov eax,x
	test eax,90000000h
	jz x1			;zf置0，符号位为正，不用处理
	sub eax,1		;eax-1
	not eax			;得到正数
x1:
	mov x_local,eax
	mov eax,y
	test eax,90000000h
	jz y1
	sub eax,1
	not eax
y1:
	mov y_local,eax

.REPEAT	
	xor edx,edx
	cdq	
	mov eax,x_local
	mov ebx,y_local
	div ebx
	mov ebx,y_local
	xchg	x_local,ebx
	mov y_local,eax
.UNTIL	(y_local > 0)
	mov eax,x_local
	ret
gcd endp
end main