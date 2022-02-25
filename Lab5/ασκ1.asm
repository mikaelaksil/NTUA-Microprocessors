INCLUDE macros.asm

DATA SEGMENT
	TABLE DB 128 DUP(?)			
	TWO DB DUP(2)				;elegxos isotimias
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA

	MAIN PROC FAR
			MOV AX,DATA
			MOV DS,AX
						;apothikefsi sth mnimi
			MOV DI,0			
			MOV CX,128			;plhthos arithmwn
		STORE:
			MOV TABLE[DI],CL
			INC DI
			LOOP STORE
						
			MOV DH,0			;prosthesi AX+DL
			MOV AX,0			;athroisma perittwn
			MOV BX,0			;plhthos perittwn
			MOV DI,0
			MOV CX,128
		FINDADDODD:
			PUSH AX
			MOV AH,0			; AX/2
			MOV AL,TABLE[DI]	;elegxos isotimias
			DIV TWO				
			CMP AH,0			
			POP AX
			JE SKIPEVEN			;AX div 2 = 0 ?
			MOV DL,TABLE[DI]	;apothikevw proswrinna
			ADD AX,DX			;athroish
			INC BX				;perittos
		SKIPEVEN:				;artios
			INC DI
			LOOP FINDADDODD
						;vriskw meso oro
			MOV DX,0			; AX/BX
			DIV BX				;athroisma/plhthos
						
			CALL PRINT_NUM8_DEC	;ektypwsh mesou oroy se dekadikh morfh
			PRINTLN
						;gia max,min
			MOV AL,TABLE[0]		;max arxika
			MOV BL,TABLE[127]	;min arxika
			MOV DI,0
			MOV CX,128
		MAXMIN:
			CMP AL,TABLE[DI]	;elegxos gia max
			JC NEWMAX
			JMP TOMIN
		NEWMAX:					;neo max
			MOV AL,TABLE[DI]
			JMP NEXTNUM
		TOMIN:					;elegxos gia min
			CMP TABLE[DI],BL
			JC NEWMIN
			JMP NEXTNUM
		NEWMIN:					;neo min
			MOV BL,TABLE[DI]
		NEXTNUM:
			INC DI
			LOOP MAXMIN
						
			CALL PRINT_NUM8_HEX	;ektypwsh max se 16adikh morfh
			PRINTCH ' '
			MOV AL,BL
			CALL PRINT_NUM8_HEX	;ektypwsh min se 16adikh morfh
			
			EXIT
	MAIN ENDP
						
	PRINT_NUM8_HEX PROC NEAR
			MOV DL,AL
			AND DL,0F0H			;1o 16adiko pshfio
			MOV CL,4
			ROR DL,CL
			CMP DL,0			;agnow arxiko mhdeniko
			JE SKIPZERO
			CALL PRINT_HEX
		SKIPZERO:
			MOV DL,AL
			AND DL,0FH			;2o 16adiko pshfio
			CALL PRINT_HEX
			RET
	PRINT_NUM8_HEX ENDP
						
	PRINT_HEX PROC NEAR	
			CMP DL,9			;0...9
			JG LETTER
			ADD DL,48
			JMP SHOW
		LETTER:
			ADD DL,55			;A...F
		SHOW:
			PRINTCH DL
			RET
	PRINT_HEX ENDP
CODE ENDS
END MAIN
