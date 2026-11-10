CLASS TestCase subclass: 'TestInteger' variables: '' classVariables: ''
	"Unit tests for Integer, the abstract base class of integers.
	 It is tested through its subclass SmallInt.
	 Run with: TestInteger run"
METHODS
testAsHex
	self assert: 255 asHex = 'FF'.
	self assert: 16 asHex = '10'.
	self assert: 10 asHex = 'A'.
	self assert: 0 asHex = '0'.
!
testAsInteger
	self assert: 7 asInteger = 7.
!
testDivision
	"Dividing integers gives a fraction."
	self assert: ( 1 / 2 ) printString = '(1/2)'.
	self assert: ( 2 / 4 ) printString = '(1/2)'.
!
testGcd
	self assert: ( 12 gcd: 18 ) = 6.
	self assert: ( 7 gcd: 5 ) = 1.
!
testPoint
	| point |
	point := 3 @ 4.
	self assert: ( point isKindOf: Point ).
	self assert: point x = 3.
	self assert: point y = 4.
!
testRandom
	| number |
	number := 10 random.
	self assert: ( number between: 0 and: 9 ).
!
