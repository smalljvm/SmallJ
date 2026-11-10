CLASS TestCase subclass: 'TestGridBagLayout' variables: '' classVariables: ''
	"Unit tests for GridBagLayout.
	 Run with: TestGridBagLayout run"
METHODS
testLayout
	| panel |
	panel := Panel new.
	panel layout: GridBagLayout new.
	panel add: Label new constraints: GridBagConstraints new.
	self assert: ( GridBagLayout new isKindOf: GridBagLayout ).
	self assert: < 38 SmallInt panel 'getComponentCount' > = 1.
!
