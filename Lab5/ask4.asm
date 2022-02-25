INCLUDE macros.asm

DATA SEGMENT
	CHARS DB 20 DUP(?)			;Ο πίνακας των χαρακτήρων
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA
	
	MAIN PROC FAR
			MOV AX,DATA
			MOV DS,AX
			
			MOV CL,0			;Μετρητής ψηφίων
		START:
			MOV DI,0			;Δείκτης πίνακα χαρακτήρων
		NEXTCHAR:		;Εισαγωγή και έλεγχος χαρακτήρα
			READCH
			CMP AL,61			;= ?
			JE FINISH
			CMP AL,13			;ENTER ?
			JE CAPSLINE
			CMP AL,48			;<0 ?
			JB NEXTCHAR
			CMP AL,122			;>z ?
			JA NEXTCHAR
			CMP AL,57			;<=9 ?
			JBE SAVECHAR
			CMP AL,97			;<a ?
			JB NEXTCHAR
		SAVECHAR:
			PRINTCH AL
			MOV CHARS[DI],AL	;Αποθήκευση χαρακτήρα στον πίνακα
			INC DI
			INC CL
			CMP CL,20			;20 χαρακτήρες ?
			JB NEXTCHAR
		CAPSLINE:
			PRINTLN
			
			CMP CL,0			;Έλεγχος κενού πίνακα
			JE NEXTCHAR			;
			
			MOV DI,0	;Μετατροπή και εμφάνιση χαρακτήρων
		NEXTCAP:
			MOV AL,CHARS[DI]
			CMP AL,97			;<a ?
			JB SHOWCAPS
			CMP AL,122			;>z ?
			JA SHOWCAPS
			SUB AL,32			;Μικρό -> κεφαλαίο
		SHOWCAPS:	
			PRINTCH AL
			INC DI
			LOOP NEXTCAP
			
			PRINTLN
			PRINTLN
			JMP START
			
		FINISH:
			EXIT
	MAIN ENDP
CODE ENDS
END MAIN
