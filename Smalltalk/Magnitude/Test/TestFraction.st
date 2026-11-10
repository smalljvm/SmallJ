CLASS TestCase subclass: 'TestFraction' variables: '' classVariables: ''
	"Unit tests for Fraction.
	 Fractions have no value equality, so they are compared by printString.
	 Run with: TestFraction run"
METHODS
testArithmetic
	self assert: ( ( 1 / 2 ) + ( 1 / 3 ) ) printString = '(5/6)'.
	self assert: ( ( 1 / 2 ) - ( 1 / 3 ) ) printString = '(1/6)'.
	self assert: ( ( 2 / 3 ) * ( 3 / 4 ) ) printString = '(1/2)'.
	self assert: ( ( 1 / 2 ) / ( 1 / 4 ) ) printString = '(2/1)'.
!
testAsFloat
	self assert: ( 1 / 4 ) asFloat = 0.25.
!
testReduced
	| fraction |
	fraction := Fraction top: 6 bottom: 8.
	self assert: fraction top = 3.
	self assert: fraction bottom = 4.
	self assert: ( Fraction top: 5 ) bottom = 1.
!
testWithInteger
	self assert: ( ( 1 / 2 ) + 1 ) printString = '(3/2)'.
	self assert: ( ( 1 / 2 ) * 4 ) printString = '(2/1)'.
!
