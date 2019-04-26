	AREA Init, CODE, READONLY
	ENTRY
	CODE32
	
START
	MOV SP, #0x400
	LDR R0, =Src
	LDR R1, =Dst
	MOV R3, #0
	
strcopy 
	LDRB R2, [R0], #1	; ��R0��ָ���ڴ����ݼ�����R2, Ȼ��R0=R0+1
	CMP R2, #0			; ��������
	BEQ endcopy			; ���Ϊ����������ת��endcopy, ��������
	STRB R2, [R1], #1	; ��R2�е����ݸ��Ƶ�R1��ָ���ڴ���, Ȼ��R1=R1+1
	ADD R3, R3, #1		; �ַ�����������+1
	B strcopy
	
endcopy
	LDR R0, =ByteNum	; ���ַ���������R3
	STR R3, [R0]
	B .
	
	AREA Datapool, DATA, READWRITE
Src DCB "string ", 0
Dst DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
ByteNum DCD 0

	END
