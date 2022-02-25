INCLUDE macros.asm

DATA SEGMENT
    MSGZ DB "Z=$"
    MSGW DB "W=$"
    MSGSUM DB "Z+W=$"
    MSGSUB DB "Z-W=$"
    MSGMINUS DB "Z-W=-$"
    Z DB 0
    W DB 0
	TEN DB DUP(10)				;Για τις δεκάδες
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA
	
	MAIN PROC FAR
			MOV AX,DATA
			MOV DS,AX
			
		START:			;Κατασκευή, εμφάνιση, αποθήκευση του Z
			PRINTSTR MSGZ
			CALL READ_DEC_DIGIT	;1ο ψηφίο (δεκάδες)
			MUL TEN				
			LEA DI,Z			;Αποθήκευση 1ου ψηφίου
			MOV [DI],AL			
			CALL READ_DEC_DIGIT	;2ο ψηφίο (μονάδες)
			ADD [DI],AL			;Αποθήκευση 2ου ψηφίου
			
			PRINTCH ' '
						;Κατασκευή, εμφάνιση, αποθήκευση του W
			PRINTSTR MSGW
			CALL READ_DEC_DIGIT	;1ο ψηφίο (δεκάδες)
			MUL TEN
			LEA DI,W			;Αποθήκευση 1ου ψηφίου
			MOV [DI],AL
			CALL READ_DEC_DIGIT	;2ο ψηφίο (μονάδες)
			ADD [DI],AL			;Αποθήκευση 2ου ψηφίου
			
			PRINTLN
						;Άθροισμα
			MOV AL,[DI]			;W
			LEA DI,Z			;Z
			ADD AL,[DI]			;Πρόσθεση
			PRINTSTR MSGSUM
			CALL PRINT_NUM8_HEX	;Εμφάνιση του αθροίσματος
			
			PRINTCH ' '
						;Διαφορά
			MOV AL,[DI]			;Z
			LEA DI,W			;W
			MOV BL,[DI]
			
			CMP AL,BL			;Z>W ή W>Z ?
			JB MINUS
			SUB AL,BL			;Αφαίρεση για Z>W
			PRINTSTR MSGSUB
			JMP SHOWSUB
		MINUS:
			SUB BL,AL			;Αφαίρεση για Z<W
			MOV AL,BL
			PRINTSTR MSGMINUS
		SHOWSUB:
			CALL PRINT_NUM8_HEX	;Εμφάνιση της διαφοράς
			PRINTLN
			PRINTLN
			JMP START
	MAIN ENDP
						;Εισαγωγή και εμφάνιση δεκαδικού ψηφίου (στον AL)
	READ_DEC_DIGIT PROC NEAR
		READ:
			READCH
			CMP AL,48			;<0 ?
			JB READ
			CMP AL,57			;>9 ?
			JA READ
			PRINTCH AL
			SUB AL,48			;Κωδικός ASCII
			RET
	READ_DEC_DIGIT ENDP
						;Εκτύπωση 8-bit αριθμού σε δεκαεξαδική μορφή (από τον AL)
	PRINT_NUM8_HEX PROC NEAR;βλ. mP11_80x86_programs.pdf σελ. 17
			MOV DL,AL
			AND DL,0F0H			;1ο δεκαεξαδικό ψηφίο
			MOV CL,4
			ROR DL,CL
			CMP DL,0			;Αγνόηση αρχικού μηδενικού
			JE SKIPZERO
			CALL PRINT_HEX
		SKIPZERO:
			MOV DL,AL
			AND DL,0FH			;2ο δεκαεξαδικό ψηφίο
			CALL PRINT_HEX
			RET
	PRINT_NUM8_HEX ENDP
						;Εκτύπωση δεκαεξαδικού ψηφίου (από τον DL)
	PRINT_HEX PROC NEAR	;βλ. mP11_80x86_programs.pdf σελ. 18
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
