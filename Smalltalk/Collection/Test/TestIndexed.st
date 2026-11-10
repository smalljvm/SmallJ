CLASS TestCase subclass: 'TestIndexed' variables: '' classVariables: ''
	"Unit tests for Indexed, the abstract base class of collections with integer indices starting at 1.
	 It is tested through its subclass Array.
	 Run with: TestIndexed run"
METHODS
testAt
	self assert: ( #( 5 6 7 ) at: 2 ) = 6.
	self assert: ( #( 5 6 7 ) at: 4 ifAbsent: [ 0 ] ) = 0.
	self assert: #( 5 6 7 ) first = 5.
	self assert: #( 5 6 7 ) last = 7.
!
testDo
	| sum |
	sum := 0.
	#( 1 2 3 ) do: [ :each | sum := sum * 10 + each ].
	self assert: sum = 123.
!
testIncludesKey
	self assert: ( #( 5 6 7 ) includesKey: 1 ).
	self assert: ( #( 5 6 7 ) includesKey: 3 ).
	self assert: ( #( 5 6 7 ) includesKey: 0 ) not.
	self assert: ( #( 5 6 7 ) includesKey: 4 ) not.
!
testIndexOf
	self assert: ( #( 5 6 5 ) indexOf: 5 ifAbsent: [ 0 ] ) = 1.
	self assert: ( #( 5 6 5 ) indexOfLast: 5 ifAbsent: [ 0 ] ) = 3.
	self assert: ( #( 5 6 5 ) indexOf: 7 ifAbsent: [ 0 ] ) = 0.
	self assert: ( #( 5 6 7 ) indexOf: 6 match: [ :a :b | a < b ] ifAbsent: [ 0 ] ) = 3.
!
testReverseDo
	| sum |
	sum := 0.
	#( 1 2 3 ) reverseDo: [ :each | sum := sum * 10 + each ].
	self assert: sum = 321.
!
testWithPadDo
	| sum |
	sum := 0.
	#( 1 2 3 ) with: #( 10 20 ) pad: 100 do: [ :a :b | sum := sum + a + b ].
	self assert: sum = 136.
!
