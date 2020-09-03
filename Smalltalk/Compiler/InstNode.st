CLASS ParserNode subclass: 'InstNode' variables: 'position' classVariables: ''
METHOD position: aPosition
	position <- aPosition.
!
METHOD compile: encoder block: inBlock
	encoder genHigh: 1 low: position - 1.
!
METHOD assign: encoder
	encoder genHigh: 6 low: position - 1.
!
METHOD assignable
	^ true.
!
