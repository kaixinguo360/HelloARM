	AREA Init, CODE, READONLY
	ENTRY
	CODE32

usr_stack_legth EQU 36
svc_stack_legth EQU 12
fiq_stack_legth EQU 12
irq_stack_legth EQU 12
abt_stack_legth EQU 12
und_stack_legth EQU 12

START
	MOV R0, #0
	MOV R1, #1
	MOV R2, #2
	MOV R3, #3
	MOV R4, #4
	MOV R5, #5
	MOV R6, #6
	MOV R7, #7
	MOV R8, #8
	MOV R9, #9
	MOV R10, #10
	MOV R11, #11
	MOV R12, #12
	
	BL INIT_STACK ; 初始化各模式下的堆栈指针
	
	; 打开IRQ中断(将CPSR寄存器的I位清0)			
	MRS R0, CPSR      ; R0<--CPSR
	BIC R0, R0, #0x80 ; 开IRQ中断
	MSR CPSR_cxsf, R0 ; CPSR<--R0
	
	; 切换到用户模式
	MSR CPSR_c, #0xD0 ; 110 10000
	MRS R0, CPSR
	STMEA SP!, {R1-R12}
	
	; 切换到管理模式 (应该失败, 用户模式不能切换到其他模式)
	MSR CPSR_c, #0xD3 ; 110 10011
	MRS R0, CPSR      ; 会发现CPSR_c依旧是0xD0, 即用户模式
	STMEA SP!, {R1-R12}
	
	B .

INIT_STACK
	MOV R0, LR ; R0<--LR, 因为各种模式下R0是相同的而各个模式LR不同

	; 设置管理模式堆栈
	MSR CPSR_c, #0xD3 ; 110 10011 CPSR[4:0]
	LDR SP, stack_svc
	STMEA SP!, {R1-R12}

	; 设置中断模式堆栈
	MSR CPSR_c, #0xD2 ; 110 10010
	LDR SP, stack_irq
	STMEA SP!, {R1-R12}

	; 设置快速中断模式堆栈
	MSR CPSR_c, #0xD1 ; 110 10001
	LDR SP, stack_fiq
	STMEA SP!, {R1-R12}

	; 设置中止模式堆栈
	MSR CPSR_c, #0xD7 ; 110 10111
	LDR SP, stack_abt
	STMEA SP!, {R1-R12}

	; 设置未定义模式堆栈
	MSR CPSR_c, #0xDB ; 110 11011
	LDR SP, stack_und
	STMEA SP!, {R1-R12}

	; 设置系统模式堆栈
	MSR CPSR_c, #0xDF ; 110 11111
	LDR SP, stack_usr
	STMEA SP!, {R1-R12}

	MOV PC, R0 ; 返回R0里保存的LR的地址
	
stack_usr DCD usr_stack_space
stack_svc DCD svc_stack_space
stack_irq DCD irq_stack_space
stack_fiq DCD fiq_stack_space
stack_abt DCD abt_stack_space
stack_und DCD und_stack_space


	AREA Init, DATA, NOINIT, ALIGN=2
	
usr_stack_space SPACE usr_stack_legth * 4
svc_stack_space SPACE svc_stack_legth * 4
irq_stack_space SPACE irq_stack_legth * 4
fiq_stack_space SPACE fiq_stack_legth * 4
abt_stack_space SPACE abt_stack_legth * 4
und_stack_space SPACE und_stack_legth * 4

	END
	