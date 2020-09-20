CLASS ParserNode subclass: 'ReturnNode' variables: 'expression' classVariables: ''
METHOD expression: e
	expression := e
!
METHOD compile: encoder block: inBlock
	expression compile: encoder block: inBlock.
	inBlock
		ifTrue: [ encoder genHigh: 15 low: 3 " block return " ]
		ifFalse: [ encoder genHigh: 15 low: 2 " stack return " ].
!
