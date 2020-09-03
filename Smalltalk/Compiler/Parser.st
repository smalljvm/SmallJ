CLASS Object subclass: 'Parser' variables: 'text index tokenType token argNames tempNames instNames maxTemps classVarNames' classVariables: ''
METHOD addArgName: name
	( ( instNames includes: name )
		or: [ argNames includes: name ] )
		ifTrue: [ self error: 'Doubly defined argument name.' ].
	argNames add: name
!
METHOD addTempName: name
	( ( ( argNames includes: name )
		or: [ instNames includes: name ] )
		or: [ tempNames includes: name ] )
		ifTrue: [ self error: 'Doubly defined temp name.' ].
	tempNames add: name.
	maxTemps <- maxTemps max: tempNames size
!
METHOD arrayLiteral
	| node |
	tokenType isAlphabetic
		ifTrue: [ node <- token. self nextLex. ^ node ].
	^ self readLiteral
!
METHOD binaryContinuation: base | receiver name |
	receiver <- self unaryContinuation: base.
	[ self tokenIsBinary ] whileTrue: [
		name <- token.
		self nextLex.
		receiver <- MessageNode new
			receiver: receiver name: name arguments:
					( List new add:
						( self unaryContinuation: self readTerm ) ) ].
	^ receiver.
!
METHOD charIsSyntax: c
	^ ( '.( )[ ]#^$' includes: c ) or: [ c = $' ]
!
METHOD currentChar
	^ text at: index ifAbsent: [ nil ]
!
METHOD findName: name
	name = 'true' ifTrue: [ ^ true ].
	name = 'false' ifTrue: [ ^ false ].
	name = 'nil' ifTrue: [ ^ nil ].
	^ Class at: name ifAbsent: [ 
		self error: 'Unrecognized name: ' + name printString ].
!
METHOD keywordContinuation: base
	| receiver name args |
	receiver <- self binaryContinuation: base.
	self tokenIsKeyword
		ifFalse: [ ^ receiver ].
	name <- ''.
	args <- List new.
	[ self tokenIsKeyword ]
		whileTrue: [
			name <- name + token.
			self nextLex.
			args add: ( self binaryContinuation: self readTerm ) ].
	^ MessageNode new receiver: receiver name: name arguments: args
!
METHOD lexAlphabetic
	| cc start |
	start <- index.
	[ ( cc <- self nextChar ) isAlphanumeric ]
			whileTrue: [ nil ].
		" add any trailing colons "
	cc = $: ifTrue: [ self nextChar ].
	token <- text from: start to: index - 1
!
METHOD lexBinary
	| c d |
	c <- self currentChar.
	token <- c asString.
	d <- self nextChar.
	( self charIsSyntax: c ) ifTrue: [ ^ token ].
	( ( ( d isBlank
		or: [ d isDigit ] )
		or: [ d isAlphabetic ] )
		or: [ self charIsSyntax: d ] )
			ifTrue: [ ^ token ].
	token <- token + d asString.
	self nextChar
!
METHOD lexInteger
	"Also lexes floats."
	| start |
	start <- index.
	[ self nextChar isDigit ] whileTrue: [ nil ].
	( self currentChar = $. and: [ ( text at: index + 1 ifAbsent: [ $  ] ) isDigit ] ) ifTrue: [
		[ self nextChar isDigit ] whileTrue: [ nil ] ].
	token <- text from: start to: index - 1
!
METHOD nameNode: name
	" make a new name node "
	name = 'super'
		ifTrue: [ ^ ArgumentNode new position: 0 ].
	( 1 to: tempNames size ) do: [ :i |
		( name = ( tempNames at: i ) )
			ifTrue: [ ^ TemporaryNode new position: i ] ].
	( 1 to: argNames size ) do: [ :i |
		( name = ( argNames at: i ) )
			ifTrue: [ ^ ArgumentNode new position: i ] ].
	( 1 to: instNames size ) do: [ :i |
		( name = ( instNames at: i ) )
			ifTrue: [ ^ InstNode new position: i ] ].
	( 1 to: classVarNames size ) do: [ :i |
		( name = ( classVarNames at: i ) )
			ifTrue: [ ^ ClassVarNode new position: i ] ].
	^ LiteralNode new value: ( self findName: name )
!
METHOD nextChar
	index <- index + 1.
	^ text at: index ifAbsent: [ $  ].
!
METHOD nextLex
	self skipBlanks.
	tokenType <- self currentChar.
	tokenType isNil ifTrue: [ " end of input "
		tokenType <- $  .
		token <- nil.
		^ nil ].
	tokenType isDigit ifTrue: [ ^ self lexInteger ].
	tokenType isAlphabetic ifTrue: [ ^ self lexAlphabetic ].
	^ self lexBinary
!
METHOD parse: c
	| encoder |
	"Note: Must call text:instanceVars:classVars: first."
	self nextLex.
	encoder <- Encoder new.
	encoder name: self readMethodName.
	self readMethodVariables.
	self readBody compile: encoder block: false.
	^ encoder method: maxTemps class: c
!
METHOD readArray
	| args |
	self currentChar ~= $( ifTrue: [
		self error: self currentChar asString + 'SmallJ does not support symbols.' ].
	self nextChar. self nextLex.
	args <- List new.
	[ tokenType ~= $) ] whileTrue: [
		args add: self readTerm ].
	self nextLex.
	^ PrimitiveNode new number: 36 arguments: args
!
METHOD readBlock
	| stmts saveTemps |
	saveTemps <- tempNames asList. " copy "
	self nextLex.
	tokenType = $:
		ifTrue: [ self readBlockTemporaries ].
	stmts <- self readStatementList.
	"tempNames <- saveTemps."
	( saveTemps size + 1 to: tempNames size ) do: [ :i | tempNames at: i put: ' ' ].
	tokenType = $]
		ifTrue: [ self nextLex.
			^ BlockNode new statements: stmts
				temporaryLocation: saveTemps size ]
		ifFalse: [ self error: 'Unterminated block' ]
!
METHOD readBlockTemporaries
	[ tokenType = $: ]
		whileTrue: [ self currentChar isAlphabetic
			ifFalse: [ self error: 'Ill formed block argument' ].
			self nextLex.
			self tokenIsName
				ifTrue: [ self addTempName: token ]
				ifFalse: [ self error: 'Invalid block argument list' ].
			self nextLex ].
	tokenType = $|
		ifTrue: [ self nextLex ]
		ifFalse: [ self error: 'Invalid block argument list' ].
!
METHOD readBody
	^ BodyNode new statements: self readStatementList.
!
METHOD readExpression
	| node |
	self tokenIsName ifFalse: [ ^ self keywordContinuation: self readTerm ].
	node <- self nameNode: token. self nextLex.
	self tokenIsArrow
		ifTrue: [ node assignable
				ifFalse: [ self error: 'Illegal assignment.' ].
			self nextLex.
			^ AssignNode new target: node expression: self readExpression ].
	^ self keywordContinuation: node
!
METHOD readInteger
	| value divisor |
	tokenType isDigit ifFalse: [ self error: 'integer expected' ].
	value <- 0.
	token do: [ :c |
		c isDigit ifTrue: [ value <- value * 10 + ( c value - 48 ).
			divisor notNil ifTrue: [ divisor <- divisor * 10 ] ].
		c = $. ifTrue: [ divisor <- 1 ] ].
   divisor notNil ifTrue: [ value <- value asFloat / divisor ].
   self nextLex.
   ^ value
!
METHOD readLiteral
	| node |
	tokenType = $$
		ifTrue: [ node <- self currentChar.
			self nextChar. self nextLex. ^ node ].
	tokenType isDigit
		ifTrue: [ ^ self readInteger ].
	tokenType = $-
		ifTrue: [ self nextLex. ^ self readInteger negated ].
	tokenType = $'
		ifTrue: [ ^ self readString ].
	self error: 'invalid literal:' + token
!
METHOD readMethodName
	| name |
	self tokenIsName	" unary method "
		ifTrue: [ name <- token. self nextLex. ^ name ].
	self tokenIsBinary	" binary method "
		ifTrue: [ name <- token. self nextLex.
			self tokenIsName
				ifFalse: [ self error: 'missing argument' ].
				self addArgName: token.
				self nextLex. ^ name ].
	self tokenIsKeyword
		ifFalse: [ self error: 'invalid method header' ].
	name <- ''.
	[ self tokenIsKeyword ]
		whileTrue: [ name <- name + token. self nextLex.
			self tokenIsName
				ifFalse: [ self error: 'missing argument' ].
				self addArgName: token.
				self nextLex ].
	^ name
!
METHOD readMethodVariables
	tokenType = $| ifFalse: [ ^ nil ].
	self nextLex.
	[ self tokenIsName ]
		whileTrue: [ self addTempName: token. self nextLex ].
	tokenType = $|
		ifTrue: [ self nextLex ]
		ifFalse: [ self error: 'illegal method variable declaration' ]
!
METHOD readPrimitive
	| num args |
	self nextLex.
	num <- self readInteger.
	args <- List new.
	[ tokenType ~= $> ]
		whileTrue: [ args add: self readTerm ].
	self nextLex.
	^ PrimitiveNode new number: num arguments: args
!
METHOD readStatement
	tokenType = $^
		ifTrue: [ self nextLex.
			^ ReturnNode new expression: self readExpression ].
	^ self readExpression
!
METHOD readStatementList
	| list |
	list <- List new.
	[ list add: self readStatement.
	  tokenType notNil and: [ tokenType = $. ] ]
		whileTrue: [ self nextLex.
			( token isNil or: [ tokenType = $] ] )
				ifTrue: [ ^ list ] ].
	^ list
!
METHOD readString
	| first last cc |
	first <- index.
	[ cc <- self currentChar.
	  cc isNil ifTrue: [ self error: 'unterminated string constant' ].
	  cc ~= $' ] whileTrue: [ index <- index + 1 ].
	last <- index - 1.
	self nextChar = $'
		ifTrue: [ self nextChar.
			^ ( text from: first to: index - 2 ) + self readString ].
	self nextLex.
	^ text from: first to: last
!
METHOD readTerm
	| node |
	token isNil
		ifTrue: [ self error: 'unexpected end of input' ].
	tokenType = $(
		ifTrue: [ self nextLex. node <- self readExpression.
			tokenType = $)
				ifFalse: [ self error: 'unbalanced parenthesis' ].
			self nextLex. ^ node ].
	tokenType = $[ ifTrue: [ ^ self readBlock ].
	tokenType = $< ifTrue: [ ^ self readPrimitive ].
	tokenType = $# ifTrue: [ ^ self readArray ].
	self tokenIsName
		ifTrue: [ node <- self nameNode: token.
			self nextLex. ^ node ].
	^ LiteralNode new value: self readLiteral
!
METHOD skipBlanks
	| cc |
	[ cc <- self currentChar.
	  cc notNil and: [ cc isBlank ] ]
			whileTrue: [ index <- index + 1 ].
	( cc notNil and: [ cc = $" ] )
		ifTrue: [ self skipComment ]
!
METHOD skipComment
	| cc |
	[ index <- index + 1.
	  cc <- self currentChar.
	  cc isNil
		ifTrue: [ ^ self error: 'unterminated comment' ].
	  cc ~= $" ] whileTrue: [ nil ].
	self nextChar. self skipBlanks
!
METHOD text: aString instanceVars: anArray
	text <- aString.
	index <- 1.
	argNames <- List new.
	argNames add: 'self'.
	instNames <- anArray.
	tempNames <- List new.
	maxTemps <- 0
!
METHOD text: aString instanceVars: anArray classVars: ca
	text <- aString.
	index <- 1.
	argNames <- List new.
	argNames add: 'self'.
	instNames <- anArray.
	tempNames <- List new.
	classVarNames <- ca.
	maxTemps <- 0
!
METHOD tokenIsArrow
	( token isKindOf: String ) ifFalse: [ ^ false ].
	^ token = '<-'
!
METHOD tokenIsBinary
	( ( ( token isNil
		or: [ self tokenIsName ] )
		or: [ self tokenIsKeyword ] )
		or: [ self charIsSyntax: tokenType ] ) ifTrue: [ ^ false ].
	^ true
!
METHOD tokenIsKeyword
	tokenType isAlphabetic ifFalse: [ ^ false ].
	^ ( token at: token size ) = $:
!
METHOD tokenIsName
	tokenType isAlphabetic ifFalse: [ ^ false ].
	^ ( token at: token size ) isAlphanumeric
!
METHOD unaryContinuation: base
	| receiver |
	receiver <- base.
	[ self tokenIsName ]
		whileTrue: [ receiver <- MessageNode new
				receiver: receiver name: token
					arguments: ( List new ).
				self nextLex ].
	^ receiver
!
