; Author: Alex Joslin, Justin van Bibber, Devon Sherrell, Kent Nguyen, Alex Joslin
; Program Name: Group1_Week8_main.asm
; Program Description: Extended Arithmetic Calculator
; Create a program that functions as a calculator for variable precision integers. It should display the current value and a menu that asks the user to make a selection. The text on your console screen would look like the following (10 is just an example value):
comment !
Current value: 10
1. Add
2. Subtract
3. Multiply
4. Divide
5. Settings
6. Exit program

When the user chooses a math operation, he/she would be asked to enter a number and the calculation would be performed. The value shown as the current value would be updated.

When the user chooses settings, he/she may enter a new value for the precision of the integers in bytes.

When item 6 is chosen, the program is exited.

The arithmetic code has to be written in assembly, but the other code can be written in C (not C++ since some members of the class do not have C++ experience). Example code to clear the screen is in Information->clear_screen_example.c.

The group that submits the best solution will be given extra credit points.
!
; Date: 10/16/2016

INCLUDE Group1_Week8_subroutines.inc

.data
curVal BYTE 100 DUP(0)
num	   BYTE 100 DUP(0)
strCur BYTE "Current value in hexidecimal: ",0 
menu   BYTE "1. Add",10				;The ten at the end makes the string skip a line.
	   BYTE "2. Subtract",10
	   BYTE "3. Multiply",10
	   BYTE "4. Divide",10
	   BYTE "5. Settings",10
       BYTE "6. Exit program",10
	   BYTE "Choose an operation",0
settng BYTE	"Set integer precision. Enter number of bytes up to 100: ",0
invalid BYTE "Invalid integer, try again",0
.code
main PROC
	mov ecx, 4					; default integer precision set to 8 bytes				
TOP:
	call Clrscr					; clear consol window
	mov edx, OFFSET strCur		; current value string
	call WriteString

	push OFFSET curVal
	call WriteHexArr@0
	call Crlf

	mov edx, OFFSET menu
	call WriteString
	call crlf

	call ReadInt

	.IF eax == 1
	push OFFSET num				; push num to stack
	call ReadExtended@0

;Push current value and second operand onto the stack
	push OFFSET curVal
	push OFFSET num
	call addProc@0		
	.ELSEIF eax == 2
	push OFFSET num				; push num to stack
	call ReadExtended@0

;Push current value and second operand onto the stack
	push OFFSET curVal
	push OFFSET num
	call subProc@0				
	.ELSEIF eax == 3
;	call mulProc
	.ELSEIF eax == 4
	push OFFSET num				; push num to stack
	call ReadExtended@0

;Push current value and second operand onto the stack
	push OFFSET curVal
	push OFFSET num
	call divProc@0
	.ELSEIF eax == 5
	mov edx, OFFSET settng
	call WriteString
	call ReadInt
	mov ecx, eax
	.ELSEIF eax == 6
	jmp EX1				;Jump to exit
	.ELSE 
	mov edx, OFFSET invalid
	call WriteString
	call crlf
	.ENDIF
	jmp TOP
EX1:

	exit  
main ENDP
END main