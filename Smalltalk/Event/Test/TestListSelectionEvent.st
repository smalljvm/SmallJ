CLASS TestCase subclass: 'TestListSelectionEvent' variables: '' classVariables: ''
	"Unit tests for ListSelectionEvent.
	 The events are created directly with the Java constructor
	 ListSelectionEvent( Object source, int firstIndex, int lastIndex, boolean isAdjusting ),
	 because the event handler only passes on events of selections made with the mouse.
	 Run with: TestListSelectionEvent run"
METHODS
testValueIsAdjusting
	| list event |
	list := ListComponent new.
	event := < 37 ListSelectionEvent 'javax.swing.event.ListSelectionEvent' list 0 1 true >.
	self assert: event valueIsAdjusting.
	event := < 37 ListSelectionEvent 'javax.swing.event.ListSelectionEvent' list 0 1 false >.
	self assert: event valueIsAdjusting not.
!
