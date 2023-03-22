;程序的描述：数据定义，要求列出所有数据类型的定义，用合适的值初始化每个变量。
;作者：
;创建日期：
;修改：
;日期：
;修改者：
INCLUDE Irvine32.inc
.data;
;整数常量
val1	byte 1h
val2	byte 1
val3	byte 0001b
;字符串常量
val4	byte 'a'
val5	byte "a"
;无符号数
val6	byte	1
val7	word	2
val8	dword	2
;有符号数
val9	sbyte	-2
val10	sword	-2
val11	sdword	-2
.code
main PROC

exit
main ENDP

END main