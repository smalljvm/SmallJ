CLASS Component subclass: 'ScrollPane' variables: '' classVariables: ''
	"Implements javax.swing.JScrollPane"
CLASSMETHODS
view: component
	"public JScrollPane​( Component view )"
	^ < 37 ScrollPane 'javax.swing.JScrollPane' component >.
!
METHODS
verticalScrollBar
	"JScrollBar scrollPane.getVerticalScrollBar()"
	^ < 38 ScrollBar self 'getVerticalScrollBar' >.
!
viewport
	"JViewport getViewport()"
	^ < 38 Viewport self 'getViewport' >.
!
