		.386
		.MODEL flat, stdcall
		OPTION CASEMAP:NONE
		
		Include kernel32.inc
		Include masm32.inc
		IncludeLib kernel32.lib
		includeLib masm32.lib
		
		.CONST
		MsgExit DB 13,10,"Press Enter to Exit",13,10,0
		ZapytX DB 13,10,'Input X',13,10,0
		ZapytY DB 13,10,'Input Y',13,10,0
		ZapytZ DB 13,10,'Input Z',13,10,0
		Result DB 13,10,'Result(F)=',0
		
		.DATA?
		Z DW ?
		X DW ?
		Y DW ?
		F DW ?
		
		BufferVd DB 100 DUP (?)
		ResStr DB 16 DUP (?)
		
		.CODE
		Start2:
		Invoke StdOut,ADDR ZapytZ
		Invoke StdIn,ADDR BufferVd,LengthOf BufferVd 
		Invoke StripLF,ADDR BufferVd
		Invoke atol,ADDR BufferVd 
		mov DWORD PTR Z,EAX
		
		Invoke StdOut,ADDR ZapytX
		Invoke StdIn,ADDR BufferVd,LengthOf BufferVd 
		Invoke StripLF,ADDR BufferVd
		Invoke atol,ADDR BufferVd
		mov DWORD PTR X,EAX
		
		Invoke StdOut,ADDR ZapytY
		Invoke StdIn,ADDR BufferVd,LengthOf BufferVd 
		Invoke StripLF,ADDR BufferVd
		Invoke atol,ADDR BufferVd 
		mov DWORD PTR Y,EAX
		
		CMP Z,-5
		JLE M1
		
		CMP Z, 6
		JGE M
		
		;X*Y-10, IF -5<Z<6
		MOV AX, X
		IMUL AX, Y ; A*B=>AX
		SUB AX, 10 ; A*B-10
		MOV F, AX
		JMP FINISH
		
		;(X-Y)/(Y+1), IF Z<= -5
	M1: MOV AX,X
		SUB AX,Y ; (X-Y)
		MOV BX, AX ; (X-Y)=>BX
		MOV AX, Y
		ADD AX, 1 ; Y+1
		MOV CX,AX ; (Y+1) =>CX
		MOV AX, BX
		CWD
		IDIV CX ; (X-Y)/(Y+1)=>AX
		MOV F, AX
		JMP FINISH
		
		;Y^2+(8/X), IF Z>=6
	M: 	MOV AX,Y
		IMUL Y ; B^2
		MOV BX, AX ; (B^2)=>CX
		MOV AX, 8
		CWD
		IDIV X ; (8/X)=>AX
		ADD BX, AX ; (B^2) + (8/A)=>BX
		MOV F, BX
		JMP FINISH


FINISH: movsx ECX,F
		
		Invoke dwtoa,ECX,ADDR ResStr
		Invoke StdOut,ADDR Result
		Invoke StdOut,ADDR ResStr
		XOR EAX,EAX
		Invoke StdOut,ADDR MsgExit
		Invoke StdIn,ADDR BufferVd,LengthOf BufferVd
		Invoke ExitProcess,0
		End Start2