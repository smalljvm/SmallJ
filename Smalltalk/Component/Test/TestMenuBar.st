CLASS TestCase subclass: 'TestMenuBar' variables: '' classVariables: ''
	"Unit tests for MenuBar.
	 Run with: TestMenuBar run"
METHODS
testAdd
	| menuBar |
	menuBar := MenuBar new.
	menuBar add: ( Menu text: 'File' ).
	menuBar add: ( Menu text: 'Edit' ).
	self assert: < 38 SmallInt menuBar 'getMenuCount' > = 2.
!
