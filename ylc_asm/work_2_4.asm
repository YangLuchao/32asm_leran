;程序的描述：文本符号常量，写一个程序为几个字符串（引号括起来的字符）定义符号名。在变量定义中分别使用每个符号
;作者：
;创建日期：
;修改：
;日期：
;修改者：
INCLUDE Irvine32.inc
A	equ	'a'
B	equ	'b'
C	equ	'c'
.data
eng byte A,B,C
.code
main PROC

exit
main ENDP

END main