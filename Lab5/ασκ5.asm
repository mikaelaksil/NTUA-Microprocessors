INCLUDE macros.asm

DATA SEGMENT
	STARTPROMPT DB "START(Y,N):$";arxiko mhnyma
	ERRORMSG DB "ERROR$"		 ;periptwsh sfalmatos
ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA
	
	MAIN PROC FAR
			MOV AX,DATA
			MOV DS,AX
			
			PRINTSTR STARTPROMPT
		START:			;gia xarakthra ekkinhshs
			READCH
			CMP AL,'N'			;= N ?
			JE FINISH			;termatismos
			CMP AL,'Y'			;= Y ?
			JE CONT				;leitourgia
			JMP START
		CONT:
			PRINTCH AL			
			PRINTLN
			PRINTLN
		NEWTEMP:
			MOV DX,0
			MOV CX,3			;3 16dika pshfia
		READTEMP:		;eisodos
			CALL HEX_KEYB		;eisagvgh pshfioy
			CMP AL,'N'			;elegxos termatismoy
			JE FINISH
						;enwsh pshfiwn ston DX
			PUSH CX
			DEC CL			
			ROL CL,2			
			MOV AH,0
			ROL AX,CL			;olistisi aristera 8, 4, 0 pshfia
			OR DX,AX			;prosthiki chfioy ston arithmo
			POP CX
			LOOP READTEMP
			
			PRINTTAB
			MOV AX,DX
			CMP AX,2047			;V<=2 ?
			JBE BRANCH1
			CMP AX,3071			;V<=3 ?
			JBE BRANCH2
			PRINTSTR ERRORMSG	;V>3
			PRINTLN
			JMP NEWTEMP
			
		BRANCH1:		;1os klados: V<=2, T=(800*V) div 4095
			MOV BX,800
			MUL BX
			MOV BX,4095
			DIV BX
			JMP SHOWTEMP
		BRANCH2:		;2os klados: 2<V<=3, T=((3200*V) div 4095)-1200
			MOV BX,3200
			MUL BX
			MOV BX,4095
			DIV BX
			SUB AX,1200
		SHOWTEMP:
			CALL PRINT_DEC16	;emfanisi akeraiou merous (AX)
						;klasmatiko meros=(ypoloipo*10) div 4095
			MOV AX,DX
			MOV BX,10
			MUL BX
			MOV BX,4095
			DIV BX
			
			PRINTCH ','			;ypodiastoli
			ADD AL,48			;kwdikos ASCII
			PRINTCH AL			;emfanisi klasmatikou merous
			PRINTLN
			JMP NEWTEMP
			
		FINISH:
			PRINTCH AL
			EXIT
	MAIN ENDP
						;eisagwgh 16dikoy pshfioy ston AL
	HEX_KEYB PROC NEAR	
		READ:
			READCH
			CMP AL,'N'			;=N ?
			JE RETURN
			CMP AL,48			;<0 ?
			JL READ
			CMP AL,57			;>9 ?
			JG LETTER
			PRINTCH AL
			SUB AL,48			;kwdikos ASCII
			JMP RETURN
		LETTER:					;A...F
			CMP AL,'A'			;<A ?
			JL READ
			CMP AL,'F'			;>F ?
			JG READ
			PRINTCH AL
			SUB AL,55			
		RETURN:
			
			RET
	HEX_KEYB ENDP
							
	PRINT_DEC16 PROC NEAR	
			PUSH DX
			
			MOV BX,10			;dekadikos=>diairesh me  10
			MOV CX,0			;metrhthw pshfiwn
		GETDEC:			;exagwgi pshfiwn
			MOV DX,0			;aritmos  mod 10 ,ypoloipo
			DIV BX				;diairesh me 10
			PUSH DX				;proswrinh apothikeusi
			INC CL
			CMP AX,0			;arithmos div 10 = 0 ? ,phliko
			JNE GETDEC
		PRINTDEC:		;ektypwsh pshfiwn
			POP DX
			ADD DL,48			;kwd ASCII
			PRINTCH DL
			LOOP PRINTDEC
			
			POP DX
			RET
	PRINT_DEC16 ENDP
CODE ENDS
END MAIN
