	AREA Init, CODE, READONLY
	ENTRY
	CODE32
	
x EQU 45
y EQU 64
stack_top EQU 0x1000; Define the top address for stacks
	
start
	MOV SP, #stack_top
	MOV R0, #x
	STR R0, [SP]
	MOV R0, #y
	LDR R1, [SP]
	ADD R0, R0, R1
	STR R0, [SP, #4]
	B .
	
	END