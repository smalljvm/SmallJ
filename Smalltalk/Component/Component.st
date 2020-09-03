CLASS JavaObject subclass: 'Component' variables: '' classVariables: ''
	"Implements: java.awt.Component, java.awt.Container, javax.swing.JComponent.
	 So is a base class for Smalltalk wrappers for Java GUI (J)Components."
META new
	^ self error: 'Component instances should be created with primitive 37 to pair them with Java objects.'.
!
METHOD add: component
	"Component add( Component comp )"
	component ifNotNil: [
		< 38 nil self 'add' component > ].
!
METHOD add: component constraints: constraints
	"public void add( Component comp, Object constraints )"
	component ifNotNil: [
		< 38 nil self 'add' component constraints > ].
!
METHOD background: color
	"void setBackground( Color color )"
	< 38 nil self 'setBackground' color >.
!
METHOD border: border
	"void setBorder( Border border )"
	< 38 nil self 'setBorder' border >.
!
METHOD font
	"Font getFont()"
	^ < 38 Font self 'getFont' >.
!
METHOD font: font
	"void setFont( Font font )"
	< 38 nil self 'setFont' font >.
!
METHOD onMousePressed: block
	< 42 self 4 block MouseEvent >.
!
METHOD onMouseClicked: block
	< 42 self 8 block MouseEvent >.
!
METHOD onMouseReleased: block
	< 42 self 5 block MouseEvent >.
!
METHOD onMouseMoved: block
	< 42 self 6 block MouseEvent >.
!
METHOD repaint
	"void repaint()"
	< 38 nil self 'repaint' >.
!
METHOD requestFocus
	"void requestFocus()"
	< 38 nil self 'requestFocus' >.
!
METHOD repaint
	"public void repaint()"
	< 38 nil self 'repaint' >.
!
