CLASS TestCase subclass: 'TestPoint' variables: '' classVariables: ''
	"Unit tests for Point.
	 Run with: TestPoint run"
METHODS
testAdd
	| point |
	point := ( 1 @ 2 ) + ( 3 @ 4 ).
	self assert: point x = 4.
	self assert: point y = 6.
!
testCreate
	| point |
	point := Point x: 1 y: 2.
	self assert: point x = 1.
	self assert: point y = 2.
	point x: 5.
	point y: 6.
	self assert: point x = 5.
	self assert: point y = 6.
!
testPrintString
	self assert: ( 1 @ 2 ) printString = '1 @ 2'.
!
