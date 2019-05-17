
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
	BL	init_stack		;初始化各模式下的堆栈指针
	MSR CPSR_c, #0xD0	;切换至用户模式
	BL main				;调用main函数
	B .

init_stack
	MOV R0, LR			;R0<--LR, 因为各种模式下R0是相同的
	
	;设置管理模式堆栈
	MSR CPSR_c, #0xD3	;110 10011
	LDR SP, stack_svc
	
	;设置中断模式堆栈
	MSR CPSR_c, #0xD2	;110 10010
	LDR SP, stack_irq
	
	;设置快速中断模式堆栈
	MSR CPSR_c, #0xD1	;110 10001
	LDR SP, stack_fiq
	
	;设置中止模式堆栈
	MSR CPSR_c, #0xD7	;110 10111
	LDR SP, stack_abt
	
	;设置未定义模式堆栈
	MSR CPSR_c, #0xDB	;110 11011
	LDR SP, stack_und
	
	;设置系统模式堆栈
	MSR CPSR_c, #0xDF	;110  11111
	LDR SP, stack_usr
	
	;返回
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
