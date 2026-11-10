CLASS TestCase subclass: 'TestSplitPane' variables: '' classVariables: ''
	"Unit tests for SplitPane.
	 Run with: TestSplitPane run"
METHODS
testComponents
	| splitPane left |
	splitPane := SplitPane new.
	left := Label new text: 'Left'.
	splitPane leftComponent: left.
	splitPane rightComponent: ( Label new text: 'Right' ).
	self assert: < 38 Boolean ( < 38 JavaObject splitPane 'getLeftComponent' > ) 'equals' left >.
	self assert: < 38 JavaObject splitPane 'getRightComponent' > notNil.
!
testOrientation
	| splitPane |
	splitPane := SplitPane new.
	splitPane orientation: SplitPane vertical.
	self assert: < 38 SmallInt splitPane 'getOrientation' > = 0.
	splitPane orientation: SplitPane horizontal.
	self assert: < 38 SmallInt splitPane 'getOrientation' > = 1.
!
