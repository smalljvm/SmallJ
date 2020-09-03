CLASS ParserNode subclass: 'BodyNode' variables: 'statements' classVariables: ''
METHOD statements: s
	statements <- s.
!
METHOD compile: encoder block: inBlock
	statements do: [ :stmt |
		stmt compile: encoder block: inBlock.
		encoder genHigh: 15 low: 5 " pop "].
	encoder genHigh: 15 low: 1 " return self "
!
