
	EXPORT delayxms

	AREA Delay, CODE, READONLY
	CODE32

delayxms				;��ʱ���ɺ�����ӳ���
	STMFD SP!, {R11};	;����R11
	SUB R0, R0, #1		;R0=R0-1
	LDR R11, =1000		;����R11��ʼֵ

loop
	SUB R11, R11, #1	;R11=R11-1

	CMP R11, #0x0		;��R11��0�Ƚ�
	BNE loop			;�ȽϵĽ����Ϊ0�����������loop

	CMP R0, #0x0		;��R0��0�Ƚ�
	BNE delayxms		;�ȽϵĽ����Ϊ0�����������delayxms

	LDMFD SP!, {R11};	;�ָ�R11
	MOV PC, LR			;����

	END

