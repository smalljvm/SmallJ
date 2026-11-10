CLASS TestCase subclass: 'TestMouseEvent' variables: '' classVariables: ''
	"Unit tests for MouseEvent.
	 The event is created directly with the Java constructor MouseEvent( Component source, int id, long when,
	 int modifiers, int x, int y, int clickCount, boolean popupTrigger ). Id 500 is MOUSE_CLICKED.
	 Run with: TestMouseEvent run"
METHODS
testAccessors
	| event |
	event := < 37 MouseEvent 'java.awt.event.MouseEvent' ( Label new ) 500 ( SmallLong new: 0 ) 0 3 4 2 false >.
	self assert: event x = 3.
	self assert: event y = 4.
	self assert: event clickCount = 2.
!
