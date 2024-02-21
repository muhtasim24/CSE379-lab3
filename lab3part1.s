	.text

	.global lab3

U0FR: 	.equ 0x18	; UART0 Flag Register

lab3:
	PUSH {r4-r12,lr}  ; Store registers r4 through r12 and lr on the													; stack. It ensures that the software convention
; is preserved, and more importantly, that the return
; address is preserved so that a proper return to the
; C wrapper can be executed.  You may change r4-r12 to
; a comma separated list of registers in the r4 through
; r12 range that are actually used.  If a register in
; this range is not used in the routine, it does not
; need to be included in this list.

		; Your test code starts here.
		; For example, the following two lines read a character from the
		; user and then print it to PuTTy.
		;MOV r0, #0x42
		BL read_character
		;BL output_character

		; Your test code ends here

	; After testing is complete, you can return to your C wrapper
	; using the POP & MOV instructions shown below.

	POP {r4-r12,lr}	; Restore registers r4 through r12 and lr from the
    						; stack. It ensures that the software convention is
    			      	; preserved, and more importantly, that the return
; address is preserved so that a proper return to
; the C wrapper can be executed. If you modified
; the list of registers in the PUSH instruction at
; the top of this routine, you MUST make sure that
; the register list in this POP instruction matches
; that of the PUSH instruction.
	mov pc, lr

output_character:
	PUSH {r4-r12,lr} 	; Store registers r4 through r12 and lr to the
    						; stack to adhere to the software convention, and
; more importantly, ensure that the return address
; is preserved so that a proper return to the caller
; is executed.  LR only needs to be included if this
; routine calls another routine. You may change
; r4-r12 to a comma separated list of registers in
; the r4 through r12 range that are actually used.
; If a register in this range is not used in the
; routine, it does not need to be included in this list.
; A minimal list of registers is best. Each register
; in the list adds a cycle to the runtime of the
; subroutine.

		; Your code to output a character to be displayed in PuTTy
		; is placed here.  The character to be displayed is passed
		; into the routine in r0.
	MOV r1, #0xC000
	MOVT r1, #0x4000

LOOP2:
	LDRB r2, [r1, #U0FR]
	AND r2,r2, #0x20
	CMP r2, #0x20
	BEQ LOOP2

	STRB r0,[r1]


	POP {r4-r12,lr}	; Restore registers r4 through r12 and lr from the
    						; stack to adhere to the software convention, and
; more importantly, ensure that the return address
; is preserved so that a proper return to the caller
; is executed.  If you modified the register list in
; the PUSH instruction at the top of this routine
; the register list must be modified in the POP
; instruction so that it matches.
	mov pc, lr

read_character:
	PUSH {r4-r12,lr} 	; Store registers r4 through r12 and lr to the
    						; stack to adhere to the software convention, and
; more importantly, ensure that the return address
; is preserved so that a proper return to the caller
; is executed.  LR only needs to be included if this
; routine calls another routine. You may change
; r4-r12 to a comma separated list of registers in
; the r4 through r12 range that are actually used.
; If a register in this range is not used in the
; routine, it does not need to be included in this list.
; A minimal list of registers is best. Each register
; in the list adds a cycle to the runtime of the
; subroutine.

		; Your code to receive a character obtained from the keyboard
		; in PuTTy is placed here.  The character is received in r0.
	MOV r1, #0xC000
	MOVT r1, #0x4000
LOOP1:
	LDRB r2, [r1, #U0FR]
	AND r2,r2, #0x10
	CMP r2, #0x10
	BEQ LOOP1

	LDRB r0,[r1]


	POP {r4-r12,lr}	; Restore registers r4 through r12 and lr from the
    						; stack to adhere to the software convention, and
; more importantly, ensure that the return address
; is preserved so that a proper return to the caller
; is executed.  If you modified the register list in
; the PUSH instruction at the top of this routine
; the register list must be modified in the POP
; instruction so that it matches.
	mov pc, lr

	.end
