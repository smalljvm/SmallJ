CLASS JavaObject subclass: 'JavaEvent' variables: '' classVariables: ''
	"Abstract base class for JavaEvent objects.
	 These are generally created in response to primitive #42, the event handler,
	 that passes the event object as the block argument.

	 Primitive parameters: < 42 javaObject eventType block eventClass >
	 Event types:
 		1 = windowClosing, 2 = buttonAction, 3 = adjustment (scrollbar),
		4 = mousePressed, 4 = mouseReleased, 5 = mouseMotion (move & drag),
		7 = listSelection, 8 = mouseClicked"
