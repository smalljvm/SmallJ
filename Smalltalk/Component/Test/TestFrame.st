CLASS TestCase subclass: 'TestFrame' variables: '' classVariables: ''
	"Unit tests for Frame.
	 The frame is never made visible, and disposed of afterwards.
	 Needs a display: Java cannot create frames when it runs headless.
	 Run with: TestFrame run"
METHODS
testFrame
	| frame |
	frame := Frame new title: 'Test'.
	frame setSize: 300 @ 200.
	frame add: Panel new.
	frame menuBar: MenuBar new.
	self assert: < 38 String frame 'getTitle' > = 'Test'.
	self assert: < 38 SmallInt frame 'getWidth' > = 300.
	self assert: < 38 SmallInt ( frame contentPane ) 'getComponentCount' > = 1.
	self assert: < 38 JavaObject frame 'getJMenuBar' > notNil.
	frame close.
	self assert: < 38 Boolean frame 'isVisible' > not.
	< 38 nil frame 'dispose' >.
!
