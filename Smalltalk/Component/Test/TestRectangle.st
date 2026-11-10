CLASS TestCase subclass: 'TestRectangle' variables: '' classVariables: ''
	"Unit tests for Rectangle, a java.awt.Rectangle.
	 Run with: TestRectangle run"
METHODS
testAccessors
	| rectangle |
	rectangle := Rectangle x: 1 y: 2 width: 3 height: 4.
	self assert: rectangle x = 1.
	self assert: rectangle y = 2.
	self assert: rectangle width = 3.
	self assert: rectangle height = 4.
	self assert: rectangle location x = 1.
	self assert: rectangle location y = 2.
!
testPrintString
	self assert: ( Rectangle x: 1 y: 2 width: 3 height: 4 ) printString = 'Rectangle( loc: 1 @ 2, size: 3 @ 4 )'.
!
