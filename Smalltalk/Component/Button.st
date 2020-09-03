CLASS Component subclass: 'Button' variables: '' classVariables: ''
	"Implements javax.swing.JButton."
META new
	"JButton()"
	^ < 37 self 'javax.swing.JButton' >.
!
METHOD text: text action: action
	"Convenience method for setting text and action with one call."
	self text: text.
	self action: action.
!
METHOD text: text
	"void setText( String text )"
	< 38 nil self 'setText' text >.

	"Set first character as default shortcut key, for now."
	self setMnemonic: ( text at: 1 ).
!
METHOD action: block
	< 42 self 2 block ActionEvent >.
!
METHOD setMnemonic: char
	"setMnemonic( int mnemonic )"
	< 38 nil self 'setMnemonic' ( char value ) >.
!
