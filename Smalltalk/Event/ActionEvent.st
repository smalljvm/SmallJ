CLASS JavaEvent subclass: 'ActionEvent' variables: '' classVariables: ''
	"Implements java.awt.event.ActionEvent.
	 This event is send for button a click and a menu select.
	 To receive this event add this code: < 42 aButtonOrMenu 2 aBlock ActionEvent >"
META new
	"Note: Events are usually created with event handler primitive 42."
	^ < 37 self 'java.awt.event.ActionEvent' >.
!
