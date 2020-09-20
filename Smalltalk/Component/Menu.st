CLASS Component subclass: 'Menu' variables: '' classVariables: ''
	"Implements javax.swing.JMenu and JMenuItem."
META text: text
	"public JMenu( String text )"
	^ < 37 Menu 'javax.swing.JMenu' text >
		setMnemonic: ( text at: 1 ).
!
METHOD setMnemonic: char
	"setMnemonic( int mnemonic )"
	< 38 nil self 'setMnemonic' ( char value ) >.
!
METHOD add: text action: block
	"Add item to menu excuting action block when selected."
	| menuItem |
	"JMenuItem add( String text )"
	menuItem := < 38 Menu self 'add' text >.
	menuItem setMnemonic: ( text at: 1 ).
	menuItem action: block.
	^ menuItem.
!
METHOD action: block
	< 42 self 2 block ActionEvent >.
!
