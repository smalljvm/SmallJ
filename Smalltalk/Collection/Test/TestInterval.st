CLASS TestCase subclass: 'TestInterval' variables: '' classVariables: ''
	"Unit tests for Interval.
	 Run with: TestInterval run"
METHODS
testDo
	| sum |
	sum := 0.
	( Interval from: 1 to: 10 by: 3 ) do: [ :each | sum := sum + each ].
	self assert: sum = 22.
!
testReverseDo
	| sum |
	sum := 0.
	( Interval from: 1 to: 3 by: 1 ) reverseDo: [ :each | sum := sum * 10 + each ].
	self assert: sum = 321.
!
testSize
	self assert: ( Interval from: 1 to: 10 by: 3 ) size = 4.
	self assert: ( Interval from: 2 to: 1 by: 1 ) isEmpty.
!
testToDo
	| sum |
	sum := 0.
	( 1 to: 4 ) do: [ :each | sum := sum + each ].
	self assert: sum = 10.
!
