CLASS Component subclass: 'TextComponent' variables: '' classVariables: ''
	"Implements javax.swing.JTextComponent"
METHODS
caretPosition: position
	"void setCaretPosition( int position )"
	< 38 nil self 'setCaretPosition' position >.
!
editable: bool
	"void setEditable( boolean bool )"
	< 38 nil self 'setEditable' bool >.
!
selectedText
	"public String getSelectedText()"
	^ < 38 String self 'getSelectedText' >.
!
text
	"public String getText()"
	^ < 38 String self 'getText' >.
!
text: string
	"public void setText( String text )"
	^ < 38 nil self 'setText' string >.
!
modelToView: position
	"Rectangle modelToView( int position )"
	^ < 38 Rectangle self 'modelToView' position >.
!
