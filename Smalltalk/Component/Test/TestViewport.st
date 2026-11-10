CLASS TestCase subclass: 'TestViewport' variables: '' classVariables: ''
	"Unit tests for Viewport, a javax.swing.JViewport.
	 Run with: TestViewport run"
METHODS
testViewPosition
	| label scrollPane viewport position |
	label := Label new text: 'Text'.
	< 38 nil label 'setPreferredSize' ( < 37 JavaObject 'java.awt.Dimension' 500 500 > ) >.
	scrollPane := ScrollPane view: label.
	< 38 nil scrollPane 'setSize' 100 100 >.
	viewport := scrollPane viewport.
	viewport viewPosition: ( JPoint x: 10 y: 20 ).
	position := < 38 JPoint viewport 'getViewPosition' >.
	self assert: position x = 10.
	self assert: position y = 20.
!
