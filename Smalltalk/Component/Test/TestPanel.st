CLASS TestCase subclass: 'TestPanel' variables: '' classVariables: ''
	"Unit tests for Panel.
	 Run with: TestPanel run"
METHODS
testLayout
	| panel |
	panel := Panel new.
	panel layout: ( GridLayout size: 2 @ 1 ).
	self assert: < 38 SmallInt ( < 38 JavaObject panel 'getLayout' > ) 'getColumns' > = 2.
!
testNew
	self assert: ( Panel new isKindOf: Component ).
	self assert: < 38 SmallInt ( Panel new ) 'getComponentCount' > = 0.
!
