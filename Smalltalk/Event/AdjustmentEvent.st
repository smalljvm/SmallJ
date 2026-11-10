CLASS JavaEvent subclass: 'AdjustmentEvent' variables: '' classVariables: ''
	"Implements java.awt.event.AdjustmentEvent.
	 To receive this event add this code: < 42 aScrollBar 3 aBlock AdjustmentEvent >"
METHODS
value
	"int getValue()"
	^ < 38 SmallInt self 'getValue' >.
!
