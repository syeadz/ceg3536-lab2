;----------------------------------------------------------------------
; File: Keypad.asm
; Author:

; Description:
;  This contains the code for reading the
;  16-key keypad attached to Port A
;  See the schematic of the connection in the
;  design document.
;
;  The following subroutines are provided by the module
;
; char pollReadKey(): to poll keypad for a keypress
;                 Checks keypad for 2 ms for a keypress, and
;                 returns NOKEY if no keypress is found, otherwise
;                 the value returned will correspond to the
;                 ASCII code for the key, i.e. 0-9, *, # and A-D
; void initkey(): Initialises Port A for the keypad
;
; char readKey(): to read the key on the keypad
;                 The value returned will correspond to the
;                 ASCII code for the key, i.e. 0-9, *, # and A-D
;---------------------------------------------------------------------

; Include header files
 include "sections.inc"
 include "reg9s12.inc"  ; Defines EQU's for Peripheral Ports

**************EQUATES**********


;-----Conversion table
NUMKEYS	EQU	16	; Number of keys on the keypad
BADCODE 	EQU	$FF 	; returned of translation is unsuccessful
NOKEY		EQU 	$00   ; No key pressed during poll period
POLLCOUNT	EQU	1     ; Number of loops to create 1 ms poll time

KEY1 		EQU	%00011110
KEY2 		EQU	%00011101
KEY3 		EQU	%00011011
KEYA 		EQU	%00010111
KEY4 		EQU	%00101110
KEY5 		EQU	%00101101
KEY6 		EQU	%00101011
KEYB 		EQU	%00100111
KEY7 		EQU	%01001110
KEY8 		EQU	%01001101
KEY9 		EQU	%01001011
KEYC 		EQU	%01000111
KEYSTAR 	EQU	%01101110
KEY0 		EQU	%01101101
KEYPOUND 	EQU	%01101011
KEYD 		EQU	%01100111

 SWITCH globalConst  ; Constant data



 SWITCH code_section  ; place in code section
;-----------------------------------------------------------	
; Subroutine: initKeyPad
;
; Description: 
; 	Initiliases PORT A
;-----------------------------------------------------------	
initKeyPad:
	movb #$0f, porta
	movb #$f0, ddra
	rts

;-----------------------------------------------------------    
; Subroutine: ch <- pollReadKey
; Parameters: none
; Local variable:
; Returns
;       ch: NOKEY when no key pressed,
;       otherwise, ASCII Code in accumulator B

; Description:
;  Loops for a period of 2ms, checking to see if
;  key is pressed. Calls readKey to read key if keypress 
;  detected (and debounced) on Port A and get ASCII code for
;  key pressed.
;-----------------------------------------------------------
; Stack Usage
	OFFSET 0  ; to setup offset into stack

pollReadKey: 
	ldab #NOKEY	; ch = NOKEY
	ldaa #POLLCOUNT ; loop for pollcount
	movb #$0f, porta 

pollLoop:
	cmpa #0 ; check if loop done
	beq done ; goto done
	deca ; decrement loop counter
	ldaa porta ; read port A
	cmpa #$0f ; check if key pressed
	beq pollLoop ; if not, loop
	pshd ; save d
	ldd #1 ; delay 1 ms
	jsr delayms ; delay 1 ms
	puld ; restore d
	ldaa porta ; read port A
	cmpa #$0f ; check if key still pressed
	beq pollLoop ; if not, loop
	jsr readKey ; if yes, read key

done:
   rts ; return (ch)

;-----------------------------------------------------------	
; Subroutine: ch <- readKey
; Arguments: none
; Local variable: 
;	ch - ASCII Code in accumulator B

; Description:
;  Main subroutine that reads a code from the
;  keyboard using the subroutine readKeybrd.  The
;  code is then translated with the subroutine
;  translate to get the corresponding ASCII code.
;-----------------------------------------------------------	
; Stack Usage
	OFFSET 0  ; to setup offset into stack

readKey:
	ldd #10 ; 10 ms delay
	jsr delayms ; delay 10 ms for debounce
	ldaa porta ; read port A
	cmpa #KEY1 ; check if key 1
	beq ascii_key1 ; if yes, goto key1
	cmpa #KEY2 ; check if key 2
	beq ascii_key2 ; if yes, goto key2
	cmpa #KEY3 ; check if key 3
	beq ascii_key3 ; if yes, goto key3
	cmpa #KEYA ; check if key A
	beq ascii_keya ; if yes, goto keyA
	cmpa #KEY4 ; check if key 4
	beq ascii_key4 ; if yes, goto key4
	cmpa #KEY5 ; check if key 5
	beq ascii_key5 ; if yes, goto key5
	cmpa #KEY6 ; check if key 6
	beq ascii_key6 ; if yes, goto key6
	cmpa #KEYB ; check if key B
	beq ascii_keyb ; if yes, goto keyB
	cmpa #KEY7 ; check if key 7
	beq ascii_key7 ; if yes, goto key7
	cmpa #KEY8 ; check if key 8
	beq ascii_key8 ; if yes, goto key8
	cmpa #KEY9 ; check if key 9
	beq ascii_key9 ; if yes, goto key9
	cmpa #KEYC ; check if key C
	beq ascii_keyc ; if yes, goto keyC
	cmpa #KEYSTAR ; check if key *
	beq ascii_keystar ; if yes, goto key*
	cmpa #KEY0 ; check if key 0
	beq ascii_key0 ; if yes, goto key0
	cmpa #KEYPOUND ; check if key #
	beq ascii_keypound ; if yes, goto key#
	cmpa #KEYD ; check if key D

ascii_key1:
	ldab #'1' ; ASCII code for 1

ascii_key2:
	ldab #'2' ; ASCII code for 2

ascii_key3:
	ldab #'3' ; ASCII code for 3

ascii_keya:
	ldab #'a' ; ASCII code for a

ascii_key4:
	ldab #'4' ; ASCII code for 4

ascii_key5:
	ldab #'5' ; ASCII code for 5

ascii_key6:
	ldab #'6' ; ASCII code for 6

ascii_keyb:
	ldab #'b' ; ASCII code for b

ascii_key7:
	ldab #'7' ; ASCII code for 7

ascii_key8:
	ldab #'8' ; ASCII code for 8

ascii_key9:
	ldab #'9' ; ASCII code for 9

ascii_keyc:
	ldab #'c' ; ASCII code for c

ascii_keystar:
	ldab #'*' ; ASCII code for *

ascii_key0:
	ldab #'0' ; ASCII code for 0

ascii_keypound:
	ldab #'#' ; ASCII code for #

ascii_keyd:
	ldab #'d' ; ASCII code for d

    rts		           ;  return(ch); 