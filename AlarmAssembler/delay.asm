;------------------------------------------------------
; Alarm System Simulation Assembler Program
; File: delay.asm
; Description: The Delay Module
; Author: Gilbert Arbez
; Date: Fall 2010
;------------------------------------------------------

; Some definitions

	SWITCH code_section

;-------------------------------
; Subroutine delayms
; Parameters: num - number of milliseconds to delay - in D
; Returns: nothing
; Description: Delays for num ms. 
;--------------------------------
delayms: 
   jsr setDelay

   rts

;------------------------------------------------------
; Subroutine setDelay
; Parameters: cnt - accumulator D
; Returns: nothing
; Global Variables: delayCount
; Description: Intialises the delayCount 
;              variable.
;------------------------------------------------------
setDelay: 
   std delayCount ; store D into delayCount
   rts


;------------------------------------------------------
; Subroutine: polldelay
; Parameters:  none
; Returns: TRUE when delay counter reaches 0 - in accumulator A
; Local Variables
;   retval - acc A cntr - X register
; Global Variables:
;      delayCount
; Description: The subroutine delays for 1 ms, decrements delayCount.
;              If delayCount is zero, return TRUE; FALSE otherwise.
;   Core Clock is set to 24 MHz, so 1 cycle is 41 2/3 ns
;   NOP takes up 1 cycle, thus 41 2/3 ns
;   Need 24 cyles to create 1 microsecond delay
;   8 cycles creates a 333 1/3 nano delay
;	DEX - 1 cycle
;	BNE - 3 cyles - when branch is taken
;	Need 4 NOP
;   Run Loop 3000 times to create a 1 ms delay   
;------------------------------------------------------
; Stack Usage:
	OFFSET 0  ; to setup offset into stack
PDLY_VARSIZE:
PDLY_PR_Y   DS.W 1 ; preserve Y
PDLY_PR_X   DS.W 1 ; preserve X
PDLY_PR_B   DS.B 1 ; preserve B
PDLY_RA     DS.W 1 ; return address

polldelay: pshb
   pshx
   pshy

   ldy #3000 ; load 3000 into Y

polldelay_loop:
   nop ; each nop is one cycle
   nop
   nop
   nop
   dey            ; 1 cycle, decrement Y, aka the 3000 loop
   bne polldelay_loop ; this takes 3 cycles, 8 cycles total
                  ; if it is not 0, branch back to delay_loop
   ldx delayCount ; load delayCount into X
   dex            ; decrement X (delayCount)
   beq polldelay_done ; if X is 0, branch to delay_done
   lda #FALSE     ; load FALSE into A, meaning delayCount is not 0
   bra polldelay_return ; move to end of subroutine

polldelay_done:
   lda #TRUE     ; load TRUE into A, meaning counter is 0

polldelay_return:
   stx delayCount ; store X into delayCount

   ; restore registers and stack
   puly
   pulx
   pulb
   rts



;------------------------------------------------------
; Global variables
;------------------------------------------------------
   switch globalVar
delayCount ds.w 1   ; 2 byte delay counter
