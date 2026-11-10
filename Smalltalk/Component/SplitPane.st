CLASS Component subclass: 'SplitPane' variables: '' classVariables: ''
	"Implements javax.swing.JSplitPane."
CLASSMETHODS
new
	"JSplitPane()"
	^ < 37 self 'javax.swing.JSplitPane' >.
!
vertical
	"JSplitPane.VERTICAL_SPLIT"
	^ 0.
!
horizontal
	"JSplitPane.HORIZONTAL_SPLIT"
	^ 1.
!
METHODS
orientation: orientation
	"void setOrientation​( int orientation )"
	< 38 nil self 'setOrientation' orientation >.
!
leftComponent: component
	"void setLeftComponent( Component component )"
	< 38 nil self 'setLeftComponent' component >.
!
rightComponent: component
	"void setRightComponent( Component component )"
	< 38 nil self 'setRightComponent' component >.
!
