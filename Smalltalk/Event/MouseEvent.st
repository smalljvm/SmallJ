CLASS JavaEvent subclass: 'MouseEvent' variables: '' classVariables: ''
	"Implements java.awt.event.MouseEvent.
	 To receive this event add this code: < 42 aComponent 8 aBlock MouseEvent >"
METHODS
x
	"int getX()"
	^ < 38 SmallInt self 'getX' >.
!
y
	"int getY()"
	^ < 38 SmallInt self 'getY' >.
!
clickCount
	"int getClickCount()"
	^ < 38 SmallInt self 'getClickCount' >.
!
