CLASS Component subclass: 'SplitPane' variables: '' classVariables: ''
	"Implements javax.swing.JSplitPane."
META new
	"JSplitPane()"
	^ < 37 self 'javax.swing.JSplitPane' >.
!
META vertical
	"JSplitPane.VERTICAL_SPLIT"
	^ 0.
!
META horizontal
	"JSplitPane.HORIZONTAL_SPLIT"
	^ 1.
!
METHOD orientation: orientation
	"void setOrientation​( int orientation )"
	< 38 nil self 'setOrientation' orientation >.
!
METHOD leftComponent: component
	"void setLeftComponent( Component component )"
	< 38 nil self 'setLeftComponent' component >.
!
METHOD rightComponent: component
	"void setRightComponent( Component component )"
	< 38 nil self 'setRightComponent' component >.
!
