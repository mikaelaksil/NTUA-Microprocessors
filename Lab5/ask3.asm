INCLUDE macros.asm

CODE SEGMENT
	ASSUME CS:CODE
	
	MAIN PROC FAR
		START:
			CALL HEX_KEYB		;Εισαγωγή 1ου ψηφίου
			CMP AL,'T'			;Ψηφίο = T ?
			JE FINISH			;Έλεγχος για τερματισμό
			MOV BL,AL			;Αποθήκευση 1ου ψηφίου
			ROL BL,4			;
			CALL HEX_KEYB		;Εισαγωγή 2ου ψηφίου
			CMP AL,'T'
			JE FINISH
			MOV DL,AL		;Αποθήκευση 2ου ψηφίου
			ROL DL,4			;
			CALL HEX_KEYB		;Εισαγωγή 3ου ψηφίου
			CMP AL,'T'
			JE FINISH
			OR BL,AL
			OR DL,AL			;Ένωση ψηφίων
			
			PRINTCH '='
			CALL PRINT__DEC		;Εμφάνιση δεκαδικού
			PRINTCH '='
			CALL PRINT_OCT		;Εμφάνιση οκταδικού
			PRINTCH '='
			CALL PRINT_BIN		;Εμφάνιση δυαδικού
			
			PRINTLN
			JMP START
			
		FINISH:
			EXIT
	MAIN ENDP
						;Εισαγωγή δεκαεξαδικού ψηφίου (στον AL)
	HEX_KEYB PROC NEAR	
		READ:
			READCH
			CMP AL,'T'			;=Τ ?
			JE RETURN
			CMP AL,48			;<0 ?
			JL READ
			CMP AL,57			;>9 ?
			JG LETTER
			PRINTCH AL
			SUB AL,48			;Κωδικός ASCII
			JMP RETURN
		LETTER:					;A...F
			CMP AL,'A'			;<A ?
			JL READ
			CMP AL,'F'			;>F ?
			JG READ
			PRINTCH AL
			SUB AL,55			;Κωδικός ASCII
		RETURN:
			
			RET
	HEX_KEYB ENDP
						;Εμφάνιση δεκαδικού αριθμού (από τον BL)
	PRINT__DEC PROC NEAR;βλ. mP11_80x86_programs.pdf σελ. 26-27
			PUSH BX
			
			MOV AL,BL
			MOV BL,10			;Δεκαδικός => διαιρέσεις με 10
			MOV CX,0			;Μετρητής ψηφίων
		GETDEC:			;Εξαγωγή ψηφίων
			MOV AH,0			;Αριθμός mod 10 (υπόλοιπο)
			DIV BL				;Διαίρεση με 10
			PUSH AX				;Προσωρινή αποθήκευση
			INC CL
			CMP AL,0			;Αριθμός div 10 = 0 ? (πηλίκο)
			JNE GETDEC
		PRINTDEC:		;Εμφάνιση ψηφίων
			POP AX
			ADD AH,48			;Κωδικός ASCII
			PRINTCH AH
			LOOP PRINTDEC
			
			POP BX
			RET
	PRINT__DEC ENDP
						;Εμφάνιση οκταδικού αριθμού (από τον BL)
	PRINT_OCT PROC NEAR
			PUSH BX
			
			MOV AL,BL
			MOV BL,8			;Οκταδικός => διαιρέσεις με 8
			MOV CX,0
		GETOCT:
			MOV AH,0
			DIV BL
			PUSH AX
			INC CL
			CMP AL,0
			JNE GETOCT
		PRINTOCT:
			POP AX
			ADD AH,48
			PRINTCH AH
			LOOP PRINTOCT
			
			POP BX
			RET
	PRINT_OCT ENDP
						;Εμφάνιση δυαδικού αριθμού (από τον BL)
	PRINT_BIN PROC NEAR
			MOV AL,BL
			MOV BL,2			;Δυαδικός => διαιρέσεις με 2
			MOV CX,0
		GETBIN:
			MOV AH,0
			DIV BL
			PUSH AX
			INC CL
			CMP AL,0
			JNE GETBIN
		PRINTBIN:
			POP AX
			ADD AH,48
			PRINTCH AH
			LOOP PRINTBIN
			
			RET
	PRINT_BIN ENDP
CODE ENDS
END MAIN