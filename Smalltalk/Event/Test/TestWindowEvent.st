CLASS TestCase subclass: 'TestWindowEvent' variables: '' classVariables: ''
	"Unit tests for WindowEvent.
	 The event is created directly with the Java constructor WindowEvent( Window source, int id ). Id 201 is WINDOW_CLOSING.
	 The frame is never made visible. Needs a display: Java cannot create frames when it runs headless.
	 Run with: TestWindowEvent run"
METHODS
testEvent
	| frame event |
	frame := Frame new.
	event := < 37 WindowEvent 'java.awt.event.WindowEvent' frame 201 >.
	self assert: ( event isKindOf: WindowEvent ).
	self assert: < 38 SmallInt event 'getID' > = 201.
	< 38 nil frame 'dispose' >.
!
