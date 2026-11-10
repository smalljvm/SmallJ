CLASS TestCase subclass: 'TestInspectorTab' variables: '' classVariables: ''
	"Unit tests for InspectorTab, the pane that shows one object in the Inspector.
	 Run with: TestInspectorTab run"
METHODS
testIndexed
	| tab model |
	tab := InspectorTab new parent: nil show: #( 5 6 7 ).
	model := ( self valueOf: 'variablesTable' in: tab ) model.
	"An indexed collection shows a row per element."
	self assert: < 38 SmallInt model 'getRowCount' > = 3.
	self assert: < 38 String model 'getValueAt' 2 1 > = '7'.
!
testVariables
	| tab model |
	tab := InspectorTab new parent: nil show: 3 @ 4.
	self assert: ( self valueOf: 'stringTextField' in: tab ) text = '3 @ 4'.
	self assert: ( tab panel isKindOf: Panel ).
	model := ( self valueOf: 'variablesTable' in: tab ) model.
	"Other objects show a row per instance variable."
	self assert: < 38 SmallInt model 'getRowCount' > = 2.
	self assert: < 38 String model 'getValueAt' 0 0 > = 'x'.
	self assert: < 38 String model 'getValueAt' 1 1 > = '4'.
!
