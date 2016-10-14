; Module Name: week8part1.asm
; Description: Short description of what the code in this module does
; Date: 10/13/2016
; Author: Justin Van Bibber
; These libraries are needed for the C library functions.
; Could also add them to the linker Additional Dependencies line
INCLUDELIB msvcrtd
INCLUDELIB legacy_stdio_definitions
INCLUDELIB ucrt

; Usual directives
.386
.model flat,C
.stack 4096

; Declare some standard C functions externals
extern printf:PROC
extern putchar:PROC
extern getchar:PROC
extern scanf:PROC
extern exit:PROC

; C calling conventions: 
;       EBP, EBX, ESI, EDI should not be modified in a function call (non-volatile)
;       EAX, ECX, EDX can be modified (volatile)

;---------------------
.data
op1 BYTE 10h, 10h, 10h, 5h ; 5101010h
op2 BYTE 8,8,8,4           ; 4080808h
op3 BYTE 20h, 20h, 20h, 20h, 20h, 20h, 10h     ;10202020202020h
op4 BYTE 30h, 30h, 30h, 30h, 30h, 30h, 5       ; 5303030303030h

result BYTE
size BYTE

;----------------------
.code
main PROC
;result = (4 * op1 + op2) / 2

; do the multiplication
; left-shift op1 twice

;left shift like so:
;shift left, this puts a value in the carry flag
;loop rotate carry left n number of times for the length of the array
;see multishift.asm

;do the addition
push SIZEOF op1
push OFFSET result
push OFFSET op2
push OFFSET op1

call extendedAdd




;do the division
; right shift result once 
; shift r


	
main ENDP

extendedAdd PROC
	; Function prolog
	push	ebp
	mov		ebp, esp
	push	ebx
	push	esi
	push	edi

	; Copy the parameter values into some registers
	mov		esi, parameterA		; Pointer to a array
	mov		edi, parameterB		; Pointer to b array
	mov		ebx, parameterC		; Pointer to result array
	mov		ecx, parameterD		; Size

	; Do the addition
	clc							; clear the carry bit
L1:
	mov		al, [esi]
	adc		al, [edi]
	mov		[ebx], al
	inc		esi					; inc does not affect the carry flag
	inc		edi
	inc		ebx
	loop	L1

	; Function epilog
	pop		edi
	pop		esi
	pop		ebx
	mov		esp, ebp
	pop		ebp
	ret
extendedAdd ENDP




END main