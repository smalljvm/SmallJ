CLASS ParserNode subclass: 'BlockNode' variables: 'statements temporaryLocation' classVariables: ''
METHOD statements: s temporaryLocation: t
	statements <- s.
	temporaryLocation <- t
!
METHOD compileInLine: encoder block: inBlock
	statements do: [ :stmt |
		stmt compile: encoder block: inBlock.
		encoder genHigh: 15 low: 5 " pop top " ].
	encoder backUp
!
METHOD isBlock
	^ true
!
METHOD compile: encoder block: inBlock
	| patchLocation |
	encoder genHigh: 12 low: temporaryLocation.
	patchLocation <- encoder genCode: 0.
	self compileInLine: encoder block: true.
	encoder genHigh: 15 low: 2. " return top of stack "
	encoder patch: patchLocation.
!
