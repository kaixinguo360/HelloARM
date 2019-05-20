
	IMPORT main

	AREA Init, CODE, READONLY
	ENTRY
	CODE32

; *********** Setup interrupt/exception vectors *************************

start				B	Reset_Handler
Undefined_Handler	B	Undefined_Handler
Swi_Handler			B	Swi_Handler
Prefetch_Handler	B	Prefetch_Handler
Abort_Handler		B	Abort_Handler
Reserved_Vector		NOP	;Reserved_Vector
Irq_Handler			B	Irq_Handler
Fiq_Handler			B	Fiq_Handler

Reset_Handler
	BL	init_stack		;��ʼ����ģʽ�µĶ�ջָ��
	MSR CPSR_c, #0xD0	;�л����û�ģʽ
	BL main				;����main����
	B .

init_stack
	MOV R0, LR			;R0<--LR, ��Ϊ����ģʽ��R0����ͬ��
	
	;���ù���ģʽ��ջ
	MSR CPSR_c, #0xD3	;110 10011
	LDR SP, stack_svc
	
	;�����ж�ģʽ��ջ
	MSR CPSR_c, #0xD2	;110 10010
	LDR SP, stack_irq
	
	;���ÿ����ж�ģʽ��ջ
	MSR CPSR_c, #0xD1	;110 10001
	LDR SP, stack_fiq
	
	;������ֹģʽ��ջ
	MSR CPSR_c, #0xD7	;110 10111
	LDR SP, stack_abt
	
	;����δ����ģʽ��ջ
	MSR CPSR_c, #0xDB	;110 11011
	LDR SP, stack_und
	
	;����ϵͳģʽ��ջ
	MSR CPSR_c, #0xDF	;110  11111
	LDR SP, stack_usr
	
	;����
	MOV PC, R0

	LTORG

stack_usr DCD usr_stack_space + 128
stack_svc DCD svc_stack_space + 128
stack_irq DCD irq_stack_space + 128
stack_fiq DCD fiq_stack_space + 128
stack_abt DCD abt_stack_space + 128
stack_und DCD und_stack_space + 128

	AREA Interrupt, DATA, READWRITE

usr_stack_space SPACE 128
svc_stack_space SPACE 128
irq_stack_space SPACE 128
fiq_stack_space SPACE 128
abt_stack_space SPACE 128
und_stack_space SPACE 128

	END
