title 在汇编语言实现下面的C++代码，要求使用.IF和.WHLIE伪指令。假设所有变量都是32位有符号整数
;int array[] = {10,60,20,33,72,89,45,65,72,18};
;int sample = 50;
;int ArraySize = sizeof array / sizeof sample;
;int index = 0;
;int sum = 0;
;while( index < ArraySize )
;{
;	if( array[index] > sample )
;	{
;		sum += array[index];
;	}
;	index++;
;}
INCLUDE Irvine32.inc
.686p
.data
array SDWORD	10,60,20,33,72,89,45,65,72,18
sample SDWORD	50
index SDWORD	0
sum SDWORD		0
.code
main proc

	.while	index < lengthof array
		mov esi,index
		mov eax,array[sizeof dword * esi]
		.if eax > sample
			add sum,eax
		.endif
		inc index
	.endw

over:	
	exit	
main endp
end main