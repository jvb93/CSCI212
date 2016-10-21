; File Name:   Group1_Week8_subroutines.asm
; Description: The module contains addPROC, subPROC, mulPROC, divPROC
; Author: Adam Deaton, Justin van Bibber, Devon Sherrell, Kent Nguyen, Alex Joslin
; Date: 10/16/2016

INCLUDE Group1_Week8_subroutines.inc

ExitProcess PROTO, dwExitCode:DWORD

.code

;-----------------------------------------------------
; Description: Adds two hex values together
; Receives: esp: first and second number to be added, ecx: length of array
; Returns: Added number as the first number
;-----------------------------------------------------
addPROC PROC
	; Function Prolog
	push ebp
	mov	ebp, esp
	push esi
	push edi
	mov esi, [ebp + 12]		; first operator
	mov edi, [ebp + 8]		; second operator
	push ecx

; loop to add each element in first integer array to the second integer array
ADL:
	mov	al, [esi]
	adc	al, [edi]
	mov	[esi], al
	inc	esi		
	inc	edi
	loop ADL
; Function epilog
	pop ecx
	mov	esp, ebp
	pop	ebp
	ret 16			;clean stack
addPROC ENDP

;-----------------------------------------------------
; Description: Subtracts two hex values together
; Receives: esp: first and second number to be subtracted, ecx: length of array
; Returns:  Result as first number
;-----------------------------------------------------
subPROC PROC
	; Function Prolog
	push ebp
	mov	ebp, esp
	push esi
	push edi
	mov esi, [ebp + 12]		; first operator
	mov edi, [ebp + 8]		; second operator
	push ecx

; loop to sub each element in first integer array by the second integer array
SL:
	mov	al, [esi]
	sbb	al, [edi]
	mov	[esi], al
	inc	esi		
	inc	edi
	loop SL
; Function epilog
	pop ecx
	mov	esp, ebp
	pop	ebp
	ret 16			;clean stack
subPROC ENDP

mulPROC PROC
	ret
mulPROC ENDP
;-----------------------------------------------------
; Description: Divides two hex values (does not work)
; Receives: esp: first and second number to be divided, ecx: length of array
; Returns:  Result as first number, remainder lost
;-----------------------------------------------------
.data
quotArray BYTE 100 DUP(0)	;Hold quotient value
addtoQuot BYTE 1
indCount DWORD 0			;Counter for esi and edi
.code
divPROC PROC
; Function Prolog
	push ebp
	mov	ebp, esp
	push esi
	push edi
	mov esi, [ebp + 12]		; first operator
	mov edi, [ebp + 8]		; second operator
	push edx
	mov edx, ecx
	add esi, ecx
	add edi, ecx
	push ecx
;Jump to divide
DVL:
	dec esi
	dec edi
	inc indCount
	mov	al, [esi]
	mov	bl, [edi]
	cmp al, bl	
	jz DVL					;Creates infinite loop, fix it
	jg PS
	jl ED1
PS:							;Pre-substraction to reset esi and edi location
	add esi, indCount
	add edi, indCount
	sub esi, edx
	sub edi, edx
;Loop sub each element in first integer array by the second integer array
SL1:
	mov	al, [esi]
	sbb	al, [edi]
	mov	[esi], al
	inc	esi		
	inc	edi
	loop SL1
	mov ecx, edx
	sub esi, edx
	sub edi, edx
	inc esi
	inc edi
	;push OFFSET quotArray
	;push OFFSET addtoQuot
	;call addPROC
	jmp DVL

ED1:					;Exit divide process
; Function epilog
	pop ecx
	pop edx
	mov	esp, ebp
	pop	ebp
	ret 32			;clean stack
divPROC ENDP
;-----------------------------------------------------
; Description: Prints to consol BYTE array in HEX
; Receives: esp: BYTE array, ecx: length of array
; Returns: none
;-----------------------------------------------------
WriteHexArr PROC
; Function Prolog
	push ebp
	mov	ebp, esp
	mov esi, [ebp + 8]
; Loop to print array on stack
	xor eax, eax
	mov edx, ecx			; store ecx
	add esi, ecx			;ESI = length of array
	dec esi					;decrement to reach final index in array
	mov ebx, 1				;Move 1 into ebx to write only AL to consol
WL1:
	mov al, [esi]
	call WriteHexB
	dec esi
	loop WL1

; Function epilog
	mov ecx, edx			;recover ecx
	mov	esp, ebp
	pop	ebp
	ret 8					;Clean stack
WriteHexArr ENDP
.data
strNum BYTE "Enter a number in hexidecimal: ",0

.code
ReadExtended PROC
; Function Prolog
	push ebp
	mov	ebp, esp
	mov esi, [ebp + 8]
	push ecx					;store byte array length
	;dec ecx						;array length - 1 for loop

RE1:
	mov edx, OFFSET strNum		; promote user for number to add to current value
	call WriteString
	call ReadHex
	mov [esi], al
	inc esi
	xor eax, eax
	loop RE1
; Function epilog
	pop ecx					;recover ecx
	mov	esp, ebp
	pop	ebp
	ret 12					;Clean stack
ReadExtended ENDP
END