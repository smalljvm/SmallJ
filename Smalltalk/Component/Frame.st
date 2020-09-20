CLASS Component subclass: 'Frame' variables: '' classVariables: ''
	"Implements Java javax.swing.JFrame class."
META new
	^ < 37 self 'javax.swing.JFrame' > setDefaultIcon center
!
METHOD menuBar: menuBar
	"void setJMenuBar( JMenuBar menuBar )"
	< 38 nil self 'setJMenuBar' menuBar >.
!
METHOD center
	"void setLocationRelativeTo( null )"
	< 38 nil self 'setLocationRelativeTo' nil >.
!
METHOD close
	self visible: false.
!
METHOD visible: aBoolean
	"public void setVisible( boolean b )"
	< 38 nil self 'setVisible' aBoolean >.
!
METHOD onClosing: block
	"void addWindowListener( WindowListener l )
	 WindowAdapter.windowClosing( WindowEvent e )"
	< 42 self 1 block WindowEvent >.
!
METHOD add: component
	"Component.add( Component child )"
	< 38 nil ( self contentPane ) 'add' component >.
!
METHOD contentPane
	"public Container getContentPane()"
	^ < 38 JavaObject self 'getContentPane' >.
!
METHOD show
	self center.
	self visible: true.
!
METHOD pack
	"void pack()"
	< 38 nil self 'pack' >.
!
METHOD setDefaultCloseOperation: operation
	"public void setDefaultCloseOperation( int operation )
		0 = DO_NOTHING_ON_CLOSE, 1 = HIDE_ON_CLOSE, 2 = DISPOSE_ON_CLOSE, 3 = EXIT_ON_CLOSE"
	< 38 nil self 'setDefaultCloseOperation' operation >.
!
METHOD setSize: size
	"public void setSize( int width, int height )"
	< 38 nil self 'setSize' ( size x ) ( size y ) >.
!
METHOD title: title
	"public void setTitle( String title )"
	< 38 nil self 'setTitle' title >.
!
METHOD setDefaultIcon
	"Set frame icon to default icon from resources."
	| file image |
	file := File name: 'SmallJ.png'.
	file exists ifTrue: [
		image := < 39 Image 'javax.imageio.ImageIO' 'read' file >.
		< 38 nil self 'setIconImage' image > ].
!
