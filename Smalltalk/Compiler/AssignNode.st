CLASS ParserNode subclass: 'AssignNode' variables: 'target expression' classVariables: ''
METHOD target: t expression: e
	target <- t.
	expression <- e.
!
METHOD compile: encoder block: inBlock
	expression compile: encoder block: inBlock.
	target assign: encoder
!
