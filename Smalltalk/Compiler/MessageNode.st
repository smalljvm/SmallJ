CLASS ParserNode subclass: 'MessageNode' variables: 'receiver name arguments lineNum' classVariables: ''
METHOD receiver: r name: n arguments: a
	receiver <- r.
	name <- n.
	arguments <- a
!
METHOD compile: encoder block: inBlock
	receiver isNil
		ifTrue: [ ^ self cascade: encoder block: inBlock ].
	((receiver isBlock and: [ self argumentsAreBlock ])
		and: [name = 'whileTrue:' or: [ name = 'whileFalse:' ] ] )
		ifTrue: [ ^ self optimizeWhile: encoder block: inBlock ].
	receiver compile: encoder block: inBlock.
	receiver isSuper
		ifTrue: [ ^ self sendToSuper: encoder block: inBlock ].
	name = 'isNil' ifTrue: [ ^ encoder genHigh: 10 low: 0 ].
	name = 'notNil' ifTrue: [ ^ encoder genHigh: 10 low: 1 ].
	self compile2: encoder block: inBlock
!
METHOD compile2: encoder block: inBlock
	self argumentsAreBlock ifTrue: [
		name = 'ifTrue:' ifTrue: [ ^ self compile: encoder
				test: 8 constant: 10 block: inBlock ].
		name = 'ifFalse:' ifTrue: [ ^ self compile: encoder
				test: 7 constant: 10 block: inBlock ].
		name = 'and:' ifTrue: [ ^ self compile: encoder
				test: 8 constant: 12 block: inBlock ].
		name = 'or:' ifTrue: [ ^ self compile: encoder
				test: 7 constant: 11 block: inBlock ].
		name = 'ifTrue:ifFalse:'
			ifTrue: [ ^ self optimizeIf: encoder block: inBlock ].
		].
	self evaluateArguments: encoder block: inBlock.
	name = '<' ifTrue: [ ^ encoder genHigh: 11 low: 0].
	name = '<=' ifTrue: [ ^ encoder genHigh: 11 low: 1].
	name = '+' ifTrue: [ ^ encoder genHigh: 11 low: 2].
	self sendMessage: encoder block: inBlock
!
METHOD sendToSuper: encoder block: inBlock
	self evaluateArguments: encoder block: inBlock.
	encoder genHigh: 8 low: 1 + arguments size.
	encoder genHigh: 15 low: 11.
	encoder genCode: ( encoder genLiteral: name )
!
METHOD cascade: encoder block: inBlock
	self evaluateArguments: encoder block: inBlock.
	self sendMessage: encoder block: inBlock
!
METHOD evaluateArguments: encoder block: inBlock
	encoder pushArgs: 1 + arguments size.
	arguments do: [ :arg |
		arg compile: encoder block: inBlock ]
!
METHOD sendMessage: encoder block: inBlock
	encoder popArgs: arguments size.
		" mark arguments, then send message "
	encoder genHigh: 8 low: 1 + arguments size.
	encoder genHigh: 9 low: (encoder genLiteral: name)
!
METHOD argumentsAreBlock
	arguments do: [ :arg | arg isBlock ifFalse: [ ^ false ] ].
	^ true
!
METHOD optimizeWhile: encoder block: inBlock
	| start save |
	start <- encoder currentLocation.
	receiver compileInLine: encoder block: inBlock.
	name = 'whileTrue:'	" branch if false/true "
		ifTrue: [ encoder genHigh: 15 low: 8 ]
		ifFalse: [ encoder genHigh: 15 low: 7 ].
	save <- encoder genCode: 0.
	(arguments at: 1) compileInLine: encoder block: inBlock.
	encoder genHigh: 15 low: 5. " pop from stack "
	encoder genHigh: 15 low: 6. " branch "
	encoder genCode: start. " branch target "
	encoder patch: save.
	encoder genHigh: 5 low: 10  " push nil "
!
METHOD compile: encoder test: t constant: c block: inBlock
	| save ssave |
	encoder genHigh: 15 low: t.  " branch test "
	save <- encoder genCode: 0.
	(arguments at: 1) compileInLine: encoder block: inBlock.
	encoder genHigh: 15 low: 6.  " branch "
	ssave <- encoder genCode: 0.
	encoder patch: save.
	encoder genHigh: 5 low: c.  " push constant "
	encoder patch: ssave
!
METHOD optimizeIf: encoder block: inBlock
	| save ssave |
	encoder genHigh: 15 low: 8.  " branch if false test "
	save <- encoder genCode: 0.
	(arguments at: 1) compileInLine: encoder block: inBlock.
	encoder genHigh: 15 low: 6.  " branch "
	ssave <- encoder genCode: 0.
	encoder patch: save.
	(arguments at: 2) compileInLine: encoder block: inBlock.
	encoder patch: ssave
!
