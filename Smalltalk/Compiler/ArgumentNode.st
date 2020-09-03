CLASS ParserNode subclass: 'ArgumentNode' variables: 'position' classVariables: ''
METHOD position: p
	position <- p
!
METHOD isSuper
	^ position = 0
!
METHOD compile: encoder block: inBlock
	position = 0
		ifTrue: [ encoder genHigh: 2 low: 0 ]
		ifFalse: [ encoder genHigh: 2 low: position - 1 ]
!
