CLASS TestCase subclass: 'TestGridBagConstraints' variables: '' classVariables: ''
	"Unit tests for GridBagConstraints.
	 Run with: TestGridBagConstraints run"
METHODS
testConstants
	self assert: GridBagConstraints west = 17.
	self assert: GridBagConstraints horizontal = 2.
	self assert: GridBagConstraints none = 0.
	self assert: GridBagConstraints both = 1.
!
testGrid
	| constraints |
	constraints := GridBagConstraints grid: 1 @ 2 size: 3 @ 4 weight: 0.5 @ 1.0
		anchor: GridBagConstraints west fill: GridBagConstraints both
		insets: ( Insets top: 1 left: 1 bottom: 1 right: 1 ) ipad: 5 @ 6.
	self assert: < 40 SmallInt constraints 'gridx' > = 1.
	self assert: < 40 SmallInt constraints 'gridy' > = 2.
	self assert: < 40 SmallInt constraints 'gridwidth' > = 3.
	self assert: < 40 Float constraints 'weightx' > = 0.5.
	self assert: < 40 SmallInt constraints 'anchor' > = 17.
	self assert: < 40 SmallInt constraints 'ipady' > = 6.
!
testNew
	self assert: < 40 SmallInt ( GridBagConstraints new ) 'gridwidth' > = 1.
!
