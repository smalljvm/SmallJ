CLASS ParserNode subclass: 'PrimitiveNode' variables: 'number arguments' classVariables: ''
METHOD number: n arguments: a
	number <- n.
	arguments <- a.
!
METHOD compile: encoder block: inBlock
	arguments do: [ :a | a compile: encoder block: inBlock ].
	encoder genHigh: 13 low: arguments size.
	encoder genCode: number.
!
