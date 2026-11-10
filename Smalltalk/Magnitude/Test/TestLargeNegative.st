CLASS TestCase subclass: 'TestLargeNegative' variables: '' classVariables: ''
	"Unit tests for LargeNegative, negative integers of any size.
	 Run with: TestLargeNegative run"
METHODS
big
	"Return -10000000000, a LargeNegative."
	^ ( 100000 * 100000 ) negated.
!
testAddSubtract
	self assert: ( self big + self big ) printString = '-20000000000'.
	self assert: ( self big - self big negated ) printString = '-20000000000'.
!
testComparing
	self assert: self big = self big.
	self assert: self big < self big negated.
	self assert: self big < ( self big + 1 asLargeInteger ).
!
testMultiply
	self assert: ( self big * 2 ) printString = '-20000000000'.
	self assert: ( self big * self big ) printString = '100000000000000000000'.
!
testNegated
	self assert: ( self big isKindOf: LargeNegative ).
	self assert: ( self big negated isKindOf: LargePositive ).
	self assert: self big negated negated = self big.
!
testPrintString
	self assert: self big printString = '-10000000000'.
	self assert: -12345 asLargeInteger printString = '-12345'.
!
