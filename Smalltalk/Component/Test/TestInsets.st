CLASS TestCase subclass: 'TestInsets' variables: '' classVariables: ''
	"Unit tests for Insets.
	 Run with: TestInsets run"
METHODS
testTopLeftBottomRight
	| insets |
	insets := Insets top: 1 left: 2 bottom: 3 right: 4.
	self assert: < 40 SmallInt insets 'top' > = 1.
	self assert: < 40 SmallInt insets 'left' > = 2.
	self assert: < 40 SmallInt insets 'bottom' > = 3.
	self assert: < 40 SmallInt insets 'right' > = 4.
!
