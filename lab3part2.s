	.data

	.global prompt
	.global dividend
	.global divisor
	.global quotient
	.global remainder

prompt:		.string "Enter a Dividend: ", 0
dividend: 	.string "Place holder string for your dividend", 0
divisor:  	.string "Place holder string for your divisor", 0
quotient:	.string "Your quotient is stored here", 0
remainder:	.string "Your remainder is stored here", 0
inputdiv:	.string "Enter a Divisor: ", 0
quo: 		.string "The Quotient is: ", 0
rem:		.string "The Remainder is", 0
restart		.string "Would You Like To Run Another Calculation?(y/n): ",0


	.text

	.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register

ptr_to_rem:				.word rem
ptr_to_quo:				.word quo
ptr_to_inputdiv:		.word inputdiv
ptr_to_prompt:			.word prompt
ptr_to_dividend:		.word dividend
ptr_to_divisor:			.word divisor
ptr_to_quotient:		.word quotient
ptr_to_remainder:		.word remainder
ptr_to_restart:			.word restart

lab3:
		PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
								; that are used in your routine.  Include lr if this
								; routine calls another routine.
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_dividend
	ldr r6, ptr_to_divisor
	ldr r7, ptr_to_quotient
	ldr r8, ptr_to_remainder

		; Your code is placed here.  This is your main routine for
		; Lab #3.  This should call your other routines such as
		; uart_init, read_string, output_string, int2string, &
		; string2int
    BL uart_init

    ; Prompt for dividend
LOOP5:
    LDR r0, ptr_to_prompt
    BL output_string
    LDR r0, ptr_to_dividend
    BL read_string

    MOV r0, #0xD
    BL output_character
    MOV r0, #0xA
    BL output_character

    ; Convert dividend string to integer
    MOV r0, r5
    BL string2int
    MOV r4, r0  ; Store the dividend integer in r4

    ; Prompt for divisor
    LDR r0, ptr_to_inputdiv
    BL output_string


    LDR r0, ptr_to_divisor
    BL read_string

	MOV r0, #0xD
    BL output_character
    MOV r0, #0xA
    BL output_character

    ; Convert divisor string to integer
    MOV r0, r6
    BL string2int
    MOV r5, r0  ; Store the divisor integer in r5


    ; Perform division
    MOV r0, r4  ; Load dividend
    MOV r1, r5  ; Load divisor
    BL div_and_mod   ; This would be a function to perform division

    ; Convert quotient to string
    MOV r0, r7  ; Pointer to quotient string
    MOV r1, r2  ; Quotient result from division
    BL int2string

    ; Convert remainder to string
    MOV r0, r8  ; Pointer to remainder string
    MOV r1, r3  ; Remainder result from division
    BL int2string

    ; Output quotient
    LDR r0, ptr_to_quo
    BL output_string

	MOV r0, #0xD
    BL output_character
    MOV r0, #0xA
    BL output_character

    LDR r0, ptr_to_quotient
    BL output_string

	MOV r0, #0xD
    BL output_character
    MOV r0, #0xA
    BL output_character

    ; Output remainder
    LDR r0, ptr_to_rem
    BL output_string

	MOV r0, #0xD
    BL output_character
    MOV r0, #0xA
    BL output_character

    LDR r0, ptr_to_remainder
    BL output_string

    MOV r0, #0xD
    BL output_character
    MOV r0, #0xA
    BL output_character

	LDR r0, ptr_to_restart
    BL output_string
    LDR r0, ptr_to_divisor
    BL read_string
    CMP r4, #'y'
    BEQ LOOP5



    B lab3_end

;______________________________________________________________________________________________________________


lab3_end:

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr

;______________________________________________________________________________________________________________


uart_init:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; Your code for your uart_init routine is placed here
	MOV r0, #0xE618
    MOVT r0, #0x400F
    MOV r1, #0x1
    STR r1, [r0]



    MOV r0, #0xE608
    MOVT r0, #0x400F
    MOV r1, #0x1
    STR r1, [r0]



    MOV r0, #0xC030
    MOVT r0, #0x4000
    MOV r1, #0x0
    STR r1, [r0]



     MOV r0, #0xC024
    MOVT r0, #0x4000
    MOV r1, #8
    STR r1, [r0]



    MOV r0, #0xC028
    MOVT r0, #0x4000
    MOV r1, #44
    STR r1, [r0]



    MOV r0, #0xCFC8
    MOVT r0, #0x4000
    MOV r1, #0x0
    STR r1, [r0]



    MOV r0, #0xC02C
    MOVT r0, #0x4000
    MOV r1, #0x60
    STR r1, [r0]



    MOV r0, #0xC030
    MOVT r0, #0x4000
    MOV r1, #0x301
    STR r1, [r0]



    MOV r0, #0x451C
    MOVT r0, #0x4000
    MOV r1, #0x03
    LDR r2 ,[r0]
    ORR r1 , r1, r2
    STR r1, [r0]


    MOV r0, #0x4420
    MOVT r0, #0x4000
    MOV r1, #0x03
    LDR r2 ,[r0]
    ORR r1 , r1, r2
    STR r1, [r0]


	MOV r0, #0x452C
    MOVT r0, #0x4000
    MOV r1, #0x11
    LDR r2 ,[r0]
    ORR r1 , r1, r2
    STR r1, [r0]

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr

;______________________________________________________________________________________________________________


read_character:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
		; Your code for your read_character routine is placed here
	MOV r1, #0xC000
	MOVT r1, #0x4000
LOOP1:
	LDRB r2, [r1, #U0FR]
	AND r2,r2, #0x10
	CMP r2, #0x10
	BEQ LOOP1

	LDRB r0,[r1]

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
	mov pc, lr

;______________________________________________________________________________________________________________


read_string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; Your code for your read_string routine is placed here
    MOV r4, r0

LOOP_RS:
    BL read_character
    CMP r0, #0xD
    BEQ ENTER
    STRB r0, [r4]
    BL output_character
    ADD r4, r4, #1
    B LOOP_RS

ENTER:
    MOV r0, #0x0
    STRB r0, [r4]

	POP {r4-r12,lr}   		; Restore registers all registers preserved in the
	mov pc, lr

;______________________________________________________________________________________________________________


output_character:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; Your code for your output_character routine is placed here
	MOV r1, #0xC000			;Base address
	MOVT r1, #0x4000
LOOP2:
	LDRB r2, [r1, #U0FR]
	AND r2,r2, #0x20
	CMP r2, #0x20
	BEQ LOOP2
	STRB r0,[r1]

	POP {r4-r12,lr}   		; Restore registers all registers preserved in the
	mov pc, lr

;______________________________________________________________________________________________________________

output_string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
		; Your code for your output_string routine is placed here
    MOV r4, r0

LOOP_OS:
	LDRB r6, [r4]
	ADD r4, r4, #1

	CMP r6, #0x0
	BEQ EXIT
	MOV r0,r6
	BL output_character
	B LOOP_OS



EXIT:
	POP {r4-r12,lr}
	mov pc, lr

;______________________________________________________________________________________________________________

int2string:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.

						; Your code for your int2string routine is placed here
						;handle negatives
    MOV r4, r0
    MOV r5, r1        ; Move int into r5
    MOV r10, #0       ; Initialize accum

    CMP r5, #0
    BGE pos      ; If positive
    MOV r8, #'-'
    STRB r8, [r4], #1
    RSB r5, r5, #0    ; make positive

pos: ; Check if the num is zero
    CMP r5, #0
    BEQ zero_fin ; If zero, go to zero_finalize

conversion:
    ; Extract digits from the number
    MOV r7, #10
    UDIV r8, r5, r7
    MUL r11, r8, r7
    SUB r7, r5, r11
    ADD r7, r7, #'0'
    PUSH {r7}
    ADD r10, r10, #1  ; Increment
    MOV r5, r8
    CMP r5, #0
    BNE conversion ; Loop

r_loop:
    CMP r10, #0
    BEQ f
    POP {r7}
    STRB r7, [r4], #1 ; Store the digit
    SUBS r10, r10, #1 ; Decrement
    B r_loop    ; Repeat until all digits are stored



zero_fin:
    MOV r8, #'0'
    STRB r8, [r4], #1 ; Store and increment
    B f       ; Go to f to null-term and end

f:

    MOV r8, #0
    STRB r8, [r4]

    POP {r4-r12,lr}   ; Restore registers
    mov pc, lr

;______________________________________________________________________________________________________________

string2int:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; Your code for your string2int routine is placed here

    MOV r2, #0
    MOV r3, #10            ; Base val
    MOV r8, #0             ;flag for neg nums
    LDRB r4, [r0]          ; Load
    CMP r4, #'-'           ; Compare ASCII value
    BNE conv_loop
    ADD r0, r0, #1         ; If '-', skip
    MOV r8, #1             ; Set flag

conv_loop:
    LDRB r4, [r0], #1      ; Load a byte, increment r0
    CMP r4, #0
    BEQ conver_d    ; If byte is NULL, done with conversion

    SUB r4, r4, #0x30      ; Convert ASCII digit to int
    MUL r2, r2, r3         ; Multiply result by 10
    ADD r2, r2, r4         ; Add to accumulator

    B conv_loop         ; Loop

conver_d:
    CMP r8, #1             ; Check if the number was neg
    BEQ make_neg      ; If neg adjust
    B move_res          ; move result into r0

make_neg:
    RSB r2, r2, #0             ; Negate

move_res:
    MOV r0, r2
    POP {r4-r12,lr}

	mov pc, lr

;______________________________________________________________________________________________________________

div_and_mod:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
							; that are used in your routine.  Include lr if this
							; routine calls another routine.
	;ldr r0, ptr_to_dividend
	;ldr r1, ptr_to_inputdiv
	ldr r7, ptr_to_quotient
	ldr r8, ptr_to_remainder
							; Your code for your div_and_mod routine is placed here
	CMP r0, #0		; check if inital dividend is zero
	BEQ ZEROS		; if yes branch to ZEROS

	CMP r0,r1
	BEQ SAME



	MOV r2, #0 		; initialize register to 0 will be used as a counter
	MOV r3, r0		; initialize register to 0 will be used to calc remainder
	MOV r4, r1 		; copy of divisor used at end to calc remainder


	CMP r0, #0		;compare with zero
	BLT LZERO		;branch to LZERO if dividend is negative
	BGT GZERO		;branch to GZERO if dividend is positive

GZERO:
	CMP r1, #0 		;check if divisor is negative
	BGT	POSDIVG
	RSB r4, r4, #0
	BLT NEGDIVG

NEGDIVG:
	ADD r3, r3, r1	;subtract dividend copied in r3 by divisor
	CMP r3, #0		;Comparing r3 to 0
	SUB r2, r2, #1	;incrementing counter
	BGT NEGDIVG		;if r3 is greater than zero loop back to NEGDIVG
	ADD r2, r2, #1	;decrement counter since remainder is encountered
	MOV r0, r2		;counter is moved to r0 as quotient
	RSB r1, r3, #0	;remainder is stored in r1
	SUB r1, r4, r1
	B LAST			;branch to end

POSDIVG:
	SUB r3, r3, r1	;subtract dividend copied in r3 by divisor
	CMP r3, #0		;Comparing r3 to 0
	ADD r2, r2, #1	;incrementing counter
	BGT POSDIVG		;if r3 is greater than zero loop back to GZERO
	SUB r2, r2, #1	;decrement counter since remainder is encountered
	MOV r0, r2		;counter is moved to r0 as quotient
	RSB r1, r3, #0	;remainder is flipped from negative to positive and stored in r1
	SUB r1, r4, r1
	B LAST			;branch to end


LZERO:
	CMP r1, #0 		;check if divisor is negative
	BGT	POSDIVL
	RSB r4, r4, #0
	BLT NEGDIVL

POSDIVL:
	ADD r3, r3, r1
	SUB r2,r2, #1
	CMP r3, #0
	BLT POSDIVL
	ADD r2,r2, #1
	MOV r0, r2		;counter is moved to r0 as quotient
	MOV r1, r3		;remainder is stored in r1
	SUB r1, r4, r1
	B LAST			;branch to end

NEGDIVL:
	SUB r3, r3, r1
	ADD r2,r2, #1
	CMP r3, #0
	BLT NEGDIVL
	SUB r2,r2, #1
	MOV r0, r2		;counter is moved to r0 as quotient
	SUB r1, r4, r3		;remainder is stored in r1
	B LAST			;branch to end


ZEROS:
	MOV r0, #0		;assigns zero to quotient
	MOV r1, #0		;assigns zero to remainder
	B LAST

SAME:
	MOV r0, #1
	MOV r1, #0
	B LAST


LAST:
	MOV r7, r0
	MOV r8, r1
	
	POP {r4-r12,lr}   		; Restore registers all registers preserved in the
							; PUSH at the top of this routine from the stack.
	mov pc, lr

	.end
