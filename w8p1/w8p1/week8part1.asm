; Module Name: week8part1.asm
; Description: does some extended arithmetic on arrays at various lengths
; Date: 10/16/2016
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
op4 BYTE 30h, 30h, 30h, 30h, 30h, 30h, 5h       ; 5303030303030h

result BYTE 0


;----------------------
.code
main PROC

; PEMDAS, let's multiply op1 by 4 first
; left shift twice to achieve this effect
mov ecx, 2; loop twice to shift twice

L1:
	
	mov edx, LENGTHOF op1; start at the end
	dec edx; second from the end
	shl [op1 + edx], 1; shift that byte one place, there is something in the carry 

	L2:
		dec edx; move to the next byte
		cmp edx, -1; if we've fallen off the end, we'll quit
		je endL2

		RCL [op1+edx], 1 ; rotate carry left the rest of the bytes
		
			
		jmp	L2
	endL2:
	

	LOOP L1

;do the addition
push LENGTHOF op1
push OFFSET result
push OFFSET op2
push OFFSET op1

call extendedAdd

mov ecx, 1

; to divide by two we'll right shift the entire array one space - this follows the same logic as before just using right shifts instead of left. 
; for the sake of brevity, refer to the comments above 
L3:
	
	mov edx, LENGTHOF op1
	shr [result + edx], 1

	L4:
		dec edx
		rcr [result+edx], 1
		cmp edx, 0
		je endL4	
		jmp	L4
	endL4:
	

	LOOP L3


; it works on op1 and op2, let's try it on op3 and op4
; the following is a copy/paste of the previous section but references op3 and op4 instead of op1 and op2
mov ecx, 2

L5:
	
	mov edx, LENGTHOF op3
	dec edx
	shl [op3 + edx], 1

	L6:
		dec edx
		cmp edx, -1
		je endL6

		RCL [op3+edx], 1
		
			
		jmp	L6
	endL6:
	

	LOOP L5

;do the addition
push LENGTHOF op3
push OFFSET result
push OFFSET op4
push OFFSET op3

call extendedAdd

mov ecx, 1

L7:
	
	mov edx, LENGTHOF op3
	shr [result + edx], 1

	L8:
		dec edx
		rcr [result+edx], 1
		cmp edx, 0
		je endL8	
		jmp	L8
	endL8:
	

	LOOP L8

	
	


	call exit
main ENDP


extendedAdd PROC
	; Function prolog
	push	ebp
	mov		ebp, esp
	push	ebx
	push	esi
	push	edi

	; Copy the parameter values into some registers
	mov		esi, [ebp+8]		; Pointer to a array
	mov		edi, [ebp+12]		; Pointer to b array
	mov		ebx, [ebp+16]		; Pointer to result array
	mov		ecx, [ebp+20]		; Size

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