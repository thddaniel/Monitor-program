		AREA	vectors, CODE, READWRITE
		EXPORT	INITVECTORS
		EXTERN	My_Monitor_Handler
		EXTERN	My_SWI_Handler

		;install the exception handlers at reset
		;by copying a precompiled block from RAM to adress 0
	
INITVECTORS
    MOV        r8, #0
    ADR        r9, Vector_Init_Block
    LDMIA      r9!,{r0-r7}           ;Copy the vectors (8 words)
    STMIA      r8!,{r0-r7}
    LDMIA      r9!,{r0-r7}           ;Copy the DCDed addresses
    STMIA      r8!,{r0-r7}           ;(8 words again)
    MOV		pc, r14
    
    
    
Vector_Init_Block
	LDR    PC, Reset_Addr
	LDR    PC, Undefined_Addr
	LDR    PC, SWI_Addr
	LDR    PC, Prefetch_Addr
	LDR    PC, Abort_Addr
	NOP                     ;Reserved vector
	LDR    PC, IRQ_Addr
	LDR    PC, FIQ_Addr


Reset_Addr      DCD    Default_Start_Boot	;Useless when using the debugger
Undefined_Addr  DCD    My_Monitor_Handler
SWI_Addr        DCD    My_SWI_Handler
Prefetch_Addr   DCD    Default_Prefetch_Handler
Abort_Addr      DCD    Default_Abort_Handler
                DCD    0                ;Reserved vector
IRQ_Addr        DCD    Default_IRQ_Handler
FIQ_Addr        DCD    Default_FIQ_Handler


Default_Start_Boot
Default_Undefined_Handler
Default_SWI_Handler
	MOVS	pc, lr

Default_Prefetch_Handler
Default_IRQ_Handler
Default_FIQ_Handler
	SUBS	pc, lr, #4

Default_Abort_Handler
	SUBS	pc, lr, #8


	END
