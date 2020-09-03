CLASS Component subclass: 'ScrollBar' variables: '' classVariables: ''
	"Implements javax.swing.JScrollBar"
META orientation: orientation value: value extent: extent min: min max: max
	"JScrollBar( int orientation, int value, int extent, int min, int max )
		Orientation: 0 = horizontal, 1 = vertical.
		Extent: Horizontal or vertical size of the viewable area (visible amount)."
	^ < 37 ScrollBar 'javax.swing.JScrollBar' orientation value extent min max >.
!
METHOD onAdjust: block
	< 42 self 3 block AdjustmentEvent >.
!
METHOD maximum
	"public int getMaximum()"
	^ < 38 SmallInt self 'getMaximum' >.
!
METHOD value
	"public int getValue()"
	^ < 38 SmallInt self 'getValue' >.
!
METHOD value: value
	"public int setValue()"
	^ < 38 nil self 'setValue' value >.
!
