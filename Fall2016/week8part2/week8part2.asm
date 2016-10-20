; Author: Group 1
; Program Name: 
; Program Description:
; Date:

INCLUDE Irvine32.inc  

.data
menu   BYTE "1. Add",10				;The ten at the end makes the string skip a line.
	   BYTE "2. Subtract",10
	   BYTE "3. Multiply",10
	   BYTE "4. Divide",10
	   BYTE "5. Settings",10
       BYTE "6. Exit program",10
	   BYTE "Choose an operation",0

currentValueText BYTE "Current Value:",10
operandText BYTE "Enter an Operand:",10
enterPrecisionText BYTE "Enter a new byte precision",10

invalid BYTE "Invalid integer, try again",0



currentValue BYTE 0 ; operands here
op2 BYTE 0
bytePrecision DWORD 8 ; set the default precision to 64 bits

.code

; DESCRIPTION	- program entry point
; AUTHOR		- Alex Joslin
main PROC

menuLoop:

	mov edx, offset currentValueText;print the current value description
	call WriteString
	call crlf

	; print the current value as hex here
	call printCurrentValueAsHex
	
	mov edx, OFFSET menu ; print the menu
	call WriteString
	call crlf

	call ReadInt ; get user choice

	.IF eax == 1
		; need to read a value into op2
		call addProc				
	.ELSEIF eax == 2
		; need to read a value into op2
		call subProc				
	.ELSEIF eax == 3
		; need to read a value into op2
		call mulProc
	.ELSEIF eax == 4
		; need to read a value into op2
		call divProc
	.ELSEIF eax == 5
		; need to read a value into op2
		call setProc
		
	.ELSEIF eax == 6
		call exitProc; quit
	.ELSE ; error 
		mov edx, OFFSET invalid ; print error message
		call WriteString
		call crlf
	.ENDIF

	jmp menuLoop ; loop the menu 

	exit  
main ENDP

; DESCRIPTION	- adds a value to the current value
; AUTHOR		- JVB
; COMMENT		- modified version of extendedadd from week 8
addProc PROC
	; Function prolog
		push	ebp
		mov		ebp, esp
		push	ebx
		push	esi
		push	edi

		; Copy the parameter values into some registers
		mov		esi, offset currentValue		; Pointer to a array
		mov		edi, offset op2					; Pointer to b array
		mov		ebx, offset currentValue		; Pointer to result array
		mov		ecx, bytePrecision		; Size

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
addProc ENDP

; DESCRIPTION	- subtracts a value from the current value
; AUTHOR		- JVB
; COMMENT		-  modified version of extendedsub from week 8
subProc PROC
	; Function prolog
	push	ebp
	mov		ebp, esp
	push	ebx
	push	esi
	push	edi

	; Copy the parameter values into some registers
	mov		esi, offset currentValue		; Pointer to a array
	mov		edi, offset op2					; Pointer to b array
	mov		ebx, offset currentValue		; Pointer to result array
	mov		ecx, bytePrecision				; Size

	; Do the subtraction
	clc							; clear the carry bit
L1:
	mov		al, [esi]
	sbb		al, [edi]
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
subProc ENDP

; DESCRIPTION	- multiplies a value with the current value
; AUTHOR		- 
mulProc PROC

mulProc ENDP

; DESCRIPTION	- divides a value from the current value
; AUTHOR		- 
divProc PROC

divProc ENDP

; DESCRIPTION	- Sets the calculator's precision in bytes
; AUTHOR		- 
setProc PROC
	push	ebp
	mov		ebp, esp

	setPrecision:

		mov edx, offset enterPrecisionText
		call WriteString
		call crlf
		call ReadInt
		cmp eax, 0
		ja goodInput

		badInput:
			mov edx, offset invalid
			call WriteString
			call crlf
			jmp setPrecision

		goodInput:
			mov eax, bytePrecision
			mov		esp, ebp
			pop		ebp
			ret
setProc ENDP



; DESCRIPTION	- shuts the program down 
; AUTHOR		- JVB
exitProc PROC
	call ExitProcess
exitProc ENDP


; DESCRIPTION	-  prints the a byte array as hex 
; AUTHOR		- JVB
; REQUIREMES	- pointer to an array and the current precision in bytes ( the size of the array, as defined by precision variable) 
; COMMENT		- JVB:I think I got this right as of 10/17 but if someone wants to check that would be awesome. need to modify his write hex to use the irvine libraries, not printf becasue otherwise we are gonna have problems
printCurrentValueAsHex PROC
	; Function prolog
	push	ebp
	mov		ebp, esp
	push	esi

	; Copy the parameter values into some registers
	mov		esi, OFFSET currentValue 		; Pointer to array
	mov		ecx, OFFSET currentPrecision		; Size

	; Have to print in reverse order since little endian
	add		esi, ecx
	dec		esi

	; Print the array values as hex 

	;-----DANGER BELOW, UNTESTED-----
L1:
	push	ecx					 ; have to save ECX before calling printf
	movzx	eax, BYTE PTR [esi]	 ; zero extend the byte being pointed at
	call	WriteHex
	add		esp, 2 * TYPE DWORD
	pop		ecx					; restore ecx
	dec		esi
	loop	L1

	; Function epilog
	pop		esi
	mov		esp, ebp
	pop		ebp
	ret
printCurrentValueAsHex ENDP


END main