CLASS JavaEvent subclass: 'WindowEvent' variables: '' classVariables: ''
	"Implements java.awt.event.WindowEvent.
	 To receive this event, add this code: < 42 aWindowComponent 1 aBlock WindowEvent >"
META new
	"Note: Events are usually created using event handler primitive 42."
	^ < 37 self 'java.awt.event.WindowEvent' >.
!
