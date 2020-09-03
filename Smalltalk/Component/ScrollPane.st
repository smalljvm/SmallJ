CLASS Component subclass: 'ScrollPane' variables: '' classVariables: ''
	"Implements javax.swing.JScrollPane"
META view: component
	"public JScrollPane​( Component view )"
	^ < 37 ScrollPane 'javax.swing.JScrollPane' component >.
!
METHOD verticalScrollBar
	"JScrollBar scrollPane.getVerticalScrollBar()"
	^ < 38 ScrollBar self 'getVerticalScrollBar' >.
!
METHOD viewport
	"JViewport getViewport()"
	^ < 38 Viewport self 'getViewport' >.
!
