	AREA Init, CODE, READONLY
	ENTRY
	CODE32

stack_bottom EQU 0x800
loop_time EQU 0x08

START
	LDR R0, =reg_init
	LDMIA R0!, {R4-R11}
	MOV SP, #stack_bottom
	MOV R0, #loop_time

LOOP
	ADD R4, R4, #1
	ADD R5, R5, #2
	ADD R6, R6, #3
	ADD R7, R7, #4
	ADD R8, R8, #5
	ADD R9, R9, #6
	ADD R10, R10, #7
	ADD R11, R11, #8
	STMEA SP!, {R4-R11}
	SUBS R0, R0, #1
	BNE LOOP

LOOP_OUT
	LDR R0, =reg_fini
	LDMFD R0!, {R4-R11}
	B .

reg_init
	DCD 1, 2, 3, 4, 5, 6, 7, 8
	
reg_fini
	DCD 0, 0, 0, 0, 0, 0, 0, 0

	END