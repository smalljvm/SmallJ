CLASS TestCase subclass: 'TestGridLayout' variables: '' classVariables: ''
	"Unit tests for GridLayout.
	 Run with: TestGridLayout run"
METHODS
testSize
	"The size point is columns @ rows."
	| layout |
	layout := GridLayout size: 3 @ 2.
	self assert: < 38 SmallInt layout 'getColumns' > = 3.
	self assert: < 38 SmallInt layout 'getRows' > = 2.
!
