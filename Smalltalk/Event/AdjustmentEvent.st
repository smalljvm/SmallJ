CLASS JavaEvent subclass: 'AdjustmentEvent' variables: '' classVariables: ''
	"Implements java.awt.event.AdjustmentEvent.
	 To receive this event add this code: < 42 aScrollBar 3 aBlock AdjustmentEvent >"
META new
	"Note: Events are usually created using event handler primitive 42."
	^ < 37 self 'java.awt.event.AdjustmentEvent' >.
!
METHOD value
	"int getValue()"
	^ < 38 SmallInt self 'getValue' >.
!
