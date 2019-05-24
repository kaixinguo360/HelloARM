;**************************************************************
; File��head.S
; ���ܣ���ʼ���������ж�ģʽ��ϵͳģʽ��ջ�����ú��жϴ�������
;****************************************************************   
   IMPORT  Main            ;�����ⲿ���� 
   IMPORT  port_init 
   IMPORT  eint_init 
   IMPORT  EINT_Handle
   IMPORT  disable_watch_dog  
   AREA head, CODE, READONLY
   ENTRY
   CODE32
start                            ;������ڵ�
;****************************************************************       
; �ж��������������У���Reset��HandleIRQ�⣬�����쳣��û��ʹ��
;****************************************************************       
; 0x00: ��λ�ж�������ַ
    b   Reset
; 0x04: δ����ָ����ֹģʽ��������ַ
HandleUndef
    b   HandleUndef  
; 0x08: ����ģʽ��������ַ��ͨ��SWIָ������ģʽ
HandleSWI
    b   HandleSWI
; 0x0c: ָ��Ԥȡ��ֹ���µ��쳣��������ַ
HandlePrefetchAbort
    b   HandlePrefetchAbort
; 0x10: ���ݷ�����ֹ���µ��쳣��������ַ
HandleDataAbort
    b   HandleDataAbort
; 0x14: ����
HandleNotUsed
    b   HandleNotUsed
; 0x18: �ж�ģʽ��������ַ
    b   HandleIRQ
; 0x1c: ���ж�ģʽ��������ַ
HandleFIQ
    b   HandleFIQ

Reset                       
      ldr sp, =4096     ; ����ջָ�룬���¶���C����������ǰ��Ҫ���ջ
      bl  disable_watch_dog   ; �ر�WATCHDOG������CPU�᲻������

     ;�л����û�ģʽ    
     ; msr cpsr_c,#0xd0    ;110  10000
     
      msr cpsr_c, #0xd2     ; �����ж�ģʽ
      ldr sp, =3072         ; �����ж�ģʽջָ��

      msr cpsr_c, #0xd3     ; �������ģʽ
      ldr sp, =4096        ;  ���ù���ģʽջָ�룬
                           ; ��ʵ��λ֮��CPU�ʹ��ڹ���ģʽ��
                       ; ǰ���"ldr sp, =4096"���ͬ���Ĺ��ܣ��˾��ʡ��
      bl  port_init            ; ��ʼ��LED��GPIO�ܽ�,��main.c��
      bl  eint_init            ; �����жϳ�ʼ����������main.c��     
    
      msr cpsr_c, #0x5f      ; ����I-bit=0����IRQ�ж� 
      
      ldr lr, =halt_loop      ; ���÷��ص�ַ
      ldr pc, =Main           ; ����main����
halt_loop
      b   halt_loop

HandleIRQ
    sub lr, lr, #4                  ; ���㷵�ص�ַ
    stmdb   sp!,    { r0-r12,lr }   ; ����ʹ�õ��ļĴ���
                                    ; ע�⣬��ʱ��sp���ж�ģʽ��sp
                                    ; ��ʼֵ���������õ�3072    
    ldr lr, =int_return       ; ���õ���ISR��EINT_Handle������ķ��ص�ַ  
    ldr pc, =EINT_Handle       ; �����жϷ���������interrupt.c��
int_return
    ldmia   sp!,    { r0-r12,pc }^  ; �жϷ���, ^��ʾ��spsr��ֵ���Ƶ�cpsr
    END