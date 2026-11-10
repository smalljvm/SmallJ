CLASS TestCase subclass: 'TestMagnitude' variables: '' classVariables: ''
	"Unit tests for Magnitude, the abstract base class of things that can be compared.
	 It is tested through its subclasses SmallInt and Char.
	 Run with: TestMagnitude run"
METHODS
testBetween
	self assert: ( 2 between: 1 and: 3 ).
	self assert: ( 1 between: 1 and: 3 ).
	self assert: ( 4 between: 1 and: 3 ) not.
	self assert: ( $b between: $a and: $c ).
!
testComparisons
	self assert: 2 > 1.
	self assert: ( 1 > 2 ) not.
	self assert: 2 >= 2.
	self assert: 2 <= 2.
	self assert: ( 3 <= 2 ) not.
	self assert: $b > $a.
!
testMaxMin
	self assert: ( 3 max: 5 ) = 5.
	self assert: ( 3 min: 5 ) = 3.
	self assert: ( $a max: $b ) = $b.
!
