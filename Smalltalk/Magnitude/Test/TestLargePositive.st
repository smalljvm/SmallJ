CLASS TestCase subclass: 'TestLargePositive' variables: '' classVariables: ''
	"Unit tests for LargePositive, positive integers of any size.
	 They are created by SmallInt arithmetic that overflows 32 bits.
	 Run with: TestLargePositive run"
METHODS
big
	"Return 10000000000, a LargePositive."
	^ 100000 * 100000.
!
testAddSubtract
	self assert: ( self big + self big ) printString = '20000000000'.
	self assert: ( self big + 1 ) printString = '10000000001'.
	self assert: ( self big - 1 ) printString = '9999999999'.
	self assert: ( ( self big + self big ) - self big ) = self big.
!
testAsLargeInteger
	self assert: ( 12345 asLargeInteger isKindOf: LargePositive ).
	self assert: 12345 asLargeInteger printString = '12345'.
	self assert: 12345 asLargeInteger = 12345 asLargeInteger.
!
testComparing
	self assert: self big = self big.
	self assert: self big < ( self big + 1 ).
	self assert: ( ( self big + 1 ) < self big ) not.
	self assert: 5 < self big.
!
testMultiply
	self assert: ( self big * 3 ) printString = '30000000000'.
	self assert: ( self big * self big ) printString = '100000000000000000000'.
!
testNegated
	self assert: ( self big negated isKindOf: LargeNegative ).
	self assert: self big negated printString = '-10000000000'.
!
testPrintString
	self assert: self big printString = '10000000000'.
	self assert: ( 1000 * 1000 * 1000 * 10 ) printString = '10000000000'.
!
