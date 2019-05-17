
	EXPORT delayxms

	AREA Delay, CODE, READONLY
	CODE32

delayxms				;延时若干毫秒的子程序
	STMFD SP!, {R11};	;保护R11
	SUB R0, R0, #1		;R0=R0-1
	LDR R11, =1000		;设置R11初始值

loop
	SUB R11, R11, #1	;R11=R11-1

	CMP R11, #0x0		;将R11与0比较
	BNE loop			;比较的结果不为0，则继续调用loop

	CMP R0, #0x0		;将R0与0比较
	BNE delayxms		;比较的结果不为0，则继续调用delayxms

	LDMFD SP!, {R11};	;恢复R11
	MOV PC, LR			;返回

	END

