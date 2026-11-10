CLASS TestCase subclass: 'TestNumber' variables: '' classVariables: ''
	"Unit tests for Number, the abstract base class of numbers.
	 It is tested through its subclasses SmallInt, Float and Fraction, including mixed arithmetic.
	 Run with: TestNumber run"
METHODS
testAbs
	self assert: -5 abs = 5.
	self assert: 5 abs = 5.
	self assert: -2.5 abs = 2.5.
!
testMixedArithmetic
	self assert: 3 + 0.5 = 3.5.
	self assert: 0.5 + 3 = 3.5.
	self assert: 3 - 0.5 = 2.5.
	self assert: 2 * 1.5 = 3.0.
	self assert: 3 < 3.5.
	self assert: ( 4 < 3.5 ) not.
!
testNegated
	self assert: 5 negated = -5.
	self assert: -5 negated = 5.
	self assert: 1.5 negated = -1.5.
!
testNegative
	self assert: -1 negative.
	self assert: 0 negative not.
	self assert: 1.5 negative not.
!
