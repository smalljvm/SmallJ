CLASS JavaEvent subclass: 'MouseEvent' variables: '' classVariables: ''
	"Implements java.awt.event.MouseEvent.
	 To receive this event add this code: < 42 aComponent 8 aBlock MouseEvent >"
META new
	"Note: Events are usually created using event handler primitive 42."
	^ < 37 self 'java.awt.event.MouseEvent' >.
!
METHOD x
	"int getX()"
	^ < 38 SmallInt self 'getX' >.
!
METHOD y
	"int getY()"
	^ < 38 SmallInt self 'getY' >.
!
METHOD clickCount
	"int getClickCount()"
	^ < 38 SmallInt self 'getClickCount' >.
!
