CLASS TestCase subclass: 'TestJPoint' variables: '' classVariables: ''
	"Unit tests for JPoint, a java.awt.Point.
	 Run with: TestJPoint run"
METHODS
testXY
	| point |
	point := JPoint x: 3 y: 4.
	self assert: point x = 3.
	self assert: point y = 4.
	self assert: point printString = '3 @ 4'.
!
