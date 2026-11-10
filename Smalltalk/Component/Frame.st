CLASS Component subclass: 'Frame' variables: '' classVariables: ''
	"Implements Java javax.swing.JFrame class."
CLASSMETHODS
new
	^ < 37 self 'javax.swing.JFrame' > setDefaultIcon center
!
METHODS
menuBar: menuBar
	"void setJMenuBar( JMenuBar menuBar )"
	< 38 nil self 'setJMenuBar' menuBar >.
!
center
	"void setLocationRelativeTo( null )"
	< 38 nil self 'setLocationRelativeTo' nil >.
!
close
	self visible: false.
!
visible: aBoolean
	"public void setVisible( boolean b )"
	< 38 nil self 'setVisible' aBoolean >.
!
onClosing: block
	"void addWindowListener( WindowListener l )
	 WindowAdapter.windowClosing( WindowEvent e )"
	< 42 self 1 block WindowEvent >.
!
add: component
	"Component.add( Component child )"
	< 38 nil ( self contentPane ) 'add' component >.
!
contentPane
	"public Container getContentPane()"
	^ < 38 JavaObject self 'getContentPane' >.
!
show
	self center.
	self visible: true.
!
pack
	"void pack()"
	< 38 nil self 'pack' >.
!
setDefaultCloseOperation: operation
	"public void setDefaultCloseOperation( int operation )
		0 = DO_NOTHING_ON_CLOSE, 1 = HIDE_ON_CLOSE, 2 = DISPOSE_ON_CLOSE, 3 = EXIT_ON_CLOSE"
	< 38 nil self 'setDefaultCloseOperation' operation >.
!
setSize: size
	"public void setSize( int width, int height )"
	< 38 nil self 'setSize' ( size x ) ( size y ) >.
!
title: title
	"public void setTitle( String title )"
	< 38 nil self 'setTitle' title >.
!
setDefaultIcon
	"Set frame icon to default icon from resources."
	| file image |
	file := File name: 'smallj.png'.
	file exists ifTrue: [
		image := < 39 Image 'javax.imageio.ImageIO' 'read' file >.
		< 38 nil self 'setIconImage' image > ].
!
