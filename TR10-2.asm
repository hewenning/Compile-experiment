INT21	MACRO X
		MOV AH,02
		MOV	DL,X
		INT 21H
		ENDM
CRLF	MACRO
		INT21 0DH
		INT21 0AH
		ENDM
STACK	SEGMENT
STA		DB 512 DUP (?)
TOP		EQU	LENGTH STA
STACK	ENDS
DATA	SEGMENT
BUF		DB 6
		DB ?
		DB 6 DUP (?)
MES1	DB 'INPUT DECIMALIST NUMBER:','$'
MES2	DB 'OUTPUT:','$'
MES3	DB 'INPUTERROR!','$'
DATA	ENDS
CODE	SEGMENT
		ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK
START:	MOV AX,DATA
		MOV DS,AX
		MOV	ES,AX
		MOV	AX,STACK
		MOV	SS,AX
		MOV	SP,TOP
		MOV	DX,OFFSET MES1
		MOV	AH,09H
		INT 21H
		MOV DX,OFFSET BUF
		MOV AH,0AH
		INT 21H
		CRLF
		CRLF
		MOV	SI,OFFSET BUF
		MOV CL,[SI+1]
		XOR CH,CH
		XOR AX,AX
		CLC
SFE1:	MOV	BX,10
		MUL	BX
		CMP	DX,0
		JNE	ERRO
		MOV DL,[SI+2]
		CMP	DL,30H
		JB	ERRO
		AND	DL,0FH
		XOR	DH,DH
		ADD	AX,DX
		JC	ERRO
		INC	SI
		LOOP SFE1
		PUSH AX
		MOV DX,OFFSET MES2
		MOV	AH,09H
		INT	21H
		POP	AX
		CALL DISUP
		JMP	SFE2
		CRLF
ERRO:	MOV DX,OFFSET MES3
		MOV AH,09H
		INT	21H
SFE2:	MOV	AH,4CH
		INT 21H
DISUP:	MOV CH,02H
		MOV BX,AX
DISUP1:	MOV AL,BH
		MOV	CL,04
		SHR AL,CL
		CMP	AL,09
		JA	DISUP4
		ADD AL,30H
DISUP2:	MOV DL,AL
		MOV AH,02
		INT 21H
		MOV AL,BH
		AND AL,0FH
		CMP	AL,09
		JA	DISUP5
		ADD AL,30H
DISUP3:	INT21 AL
		DEC	CH
		JNZ	DISUP6
		INT21 48H
		RET
DISUP4:	ADD AL,37H
		JMP	DISUP2
DISUP5:	ADD AL,37H
		JMP DISUP2
DISUP6: MOV BH,BL
		JMP	DISUP1
CODE	ENDS
		END START	
