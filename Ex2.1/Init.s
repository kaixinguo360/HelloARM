	AREA Init, CODE, READONLY
	ENTRY
	CODE32
	
START
	MOV SP, #0x400
	LDR R0, =Src
	LDR R1, =Dst
	MOV R3, #0
	
strcopy 
	LDRB R2, [R0], #1	; 将R0所指的内存内容加载至R2, 然后R0=R0+1
	CMP R2, #0			; 检测结束符
	BEQ endcopy			; 如果为结束符则跳转至endcopy, 结束拷贝
	STRB R2, [R1], #1	; 将R2中的内容复制到R1所指的内存中, 然后R1=R1+1
	ADD R3, R3, #1		; 字符个数计数器+1
	B strcopy
	
endcopy
	LDR R0, =ByteNum	; 将字符个数赋给R3
	STR R3, [R0]
	B .
	
	AREA Datapool, DATA, READWRITE
Src DCB "string ", 0
Dst DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
ByteNum DCD 0

	END
