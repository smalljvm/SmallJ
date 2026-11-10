CLASS TestCase subclass: 'TestFloat' variables: '' classVariables: ''
	"Unit tests for Float, implemented as Java double.
	 Run with: TestFloat run"
METHODS
testArithmetic
	self assert: 1.5 + 2.25 = 3.75.
	self assert: 1.5 - 2.0 = -0.5.
	self assert: 1.5 * 2.0 = 3.0.
	self assert: 3.0 / 2.0 = 1.5.
!
testAsInteger
	self assert: 3.7 asInteger = 3.
	self assert: -3.7 asInteger = -3.
	self assert: 3 asFloat = 3.0.
	self assert: ( 3 asFloat isKindOf: Float ).
!
testComparing
	self assert: 1.5 < 2.5.
	self assert: ( 2.5 < 1.5 ) not.
	self assert: 2.0 = 2.
	self assert: 2.5 > 2.
!
testPoint
	self assert: ( 1.5 @ 2 ) x = 1.5.
!
testPrintString
	self assert: 1.5 printString = '1.5'.
	self assert: 2 asFloat printString = '2.0'.
!
testRandom
	| number |
	number := Float random.
	self assert: ( number between: 0.0 and: 1.0 ).
!
testSqrt
	self assert: 16.0 sqrt = 4.0.
	self assert: 2 asFloat sqrt > 1.41.
!
