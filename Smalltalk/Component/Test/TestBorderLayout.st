CLASS TestCase subclass: 'TestBorderLayout' variables: '' classVariables: ''
	"Unit tests for BorderLayout.
	 Run with: TestBorderLayout run"
METHODS
testConstraints
	self assert: BorderLayout center = 'Center'.
	self assert: BorderLayout north = 'North'.
	self assert: BorderLayout south = 'South'.
	self assert: BorderLayout east = 'East'.
	self assert: BorderLayout west = 'West'.
!
testEmptyBorder
	| border insets |
	border := BorderLayout emptyBorder: ( Insets top: 1 left: 2 bottom: 3 right: 4 ).
	insets := < 38 JavaObject border 'getBorderInsets' >.
	self assert: < 40 SmallInt insets 'left' > = 2.
!
testGap
	| layout |
	layout := BorderLayout gap: 4 @ 2.
	self assert: < 38 SmallInt layout 'getHgap' > = 4.
	self assert: < 38 SmallInt layout 'getVgap' > = 2.
	self assert: < 38 SmallInt ( BorderLayout new ) 'getHgap' > = 0.
!
