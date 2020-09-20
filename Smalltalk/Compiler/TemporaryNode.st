CLASS ParserNode subclass: 'TemporaryNode' variables: 'position' classVariables: ''
METHOD position: p
	position := p
!
METHOD compile: encoder block: inBlock
	encoder genHigh: 3 low: position - 1
!
METHOD assignable
	^ true
!
METHOD assign: encoder
	encoder genHigh: 7 low: position - 1
!
