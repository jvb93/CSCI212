; File Name:   Group1_Week8_subroutines.inc
; Description: Include file, defines prototype for Group1_Week8_subroutines.asm
; Author: Adam Deaton
; Date:   10/16/2016
; STDCALL convention.
INCLUDE Irvine32.inc

EXTERN addPROC@0:PROC
EXTERN subPROC@0:PROC
EXTERN mulPROC@0:PROC
EXTERN divPROC@0:PROC
EXTERN WriteHexArr@0:PROC
EXTERN ReadExtended@0:PROC