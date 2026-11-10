CLASS TestCase subclass: 'TestOrdered' variables: '' classVariables: ''
	"Unit tests for Ordered, a list that keeps its elements sorted.
	 Run with: TestOrdered run"
METHODS
testAdd
	| ordered |
	ordered := Ordered new.
	#( 5 1 4 2 3 ) do: [ :each | ordered add: each ].
	self assert: ordered asArray printString = #( 1 2 3 4 5 ) printString.
!
testSortBlock
	| ordered |
	ordered := Ordered new: [ :a :b | a > b ].
	#( 2 3 1 ) do: [ :each | ordered add: each ].
	self assert: ordered asArray printString = #( 3 2 1 ) printString.
!
testStrings
	| ordered |
	ordered := Ordered new.
	#( 'pear' 'apple' 'fig' ) do: [ :each | ordered add: each ].
	self assert: ordered first = 'apple'.
	self assert: ordered last = 'pear'.
!
