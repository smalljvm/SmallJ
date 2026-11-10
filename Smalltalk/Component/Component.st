CLASS JavaObject subclass: 'Component' variables: '' classVariables: ''
	"Implements: java.awt.Component, java.awt.Container, javax.swing.JComponent.
	 So is a base class for Smalltalk wrappers for Java GUI (J)Components."
CLASSMETHODS
new
	^ self error: 'Component instances should be created with primitive 37 to pair them with Java objects.'.
!
METHODS
add: component
	"Component add( Component comp )"
	component ifNotNil: [
		< 38 nil self 'add' component > ].
!
add: component constraints: constraints
	"public void add( Component comp, Object constraints )"
	component ifNotNil: [
		< 38 nil self 'add' component constraints > ].
!
background: color
	"void setBackground( Color color )"
	< 38 nil self 'setBackground' color >.
!
border: border
	"void setBorder( Border border )"
	< 38 nil self 'setBorder' border >.
!
font
	"Font getFont()"
	^ < 38 Font self 'getFont' >.
!
font: font
	"void setFont( Font font )"
	< 38 nil self 'setFont' font >.
!
onMousePressed: block
	< 42 self 4 block MouseEvent >.
!
onMouseClicked: block
	< 42 self 8 block MouseEvent >.
!
onMouseReleased: block
	< 42 self 5 block MouseEvent >.
!
onMouseMoved: block
	< 42 self 6 block MouseEvent >.
!
repaint
	"void repaint()"
	< 38 nil self 'repaint' >.
!
requestFocus
	"void requestFocus()"
	< 38 nil self 'requestFocus' >.
!
