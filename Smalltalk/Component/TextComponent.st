CLASS Component subclass: 'TextComponent' variables: '' classVariables: ''
	"Implements javax.swing.JTextComponent"
METHOD caretPosition: position
	"void setCaretPosition( int position )"
	< 38 nil self 'setCaretPosition' position >.
!
METHOD editable: bool
	"void setEditable( boolean bool )"
	< 38 nil self 'setEditable' bool >.
!
METHOD selectedText
	"public String getSelectedText()"
	^ < 38 String self 'getSelectedText' >.
!
METHOD text
	"public String getText()"
	^ < 38 String self 'getText' >.
!
METHOD text: string
	"public void setText( String text )"
	^ < 38 nil self 'setText' string >.
!
METHOD modelToView: position
	"Rectangle modelToView( int position )"
	^ < 38 Rectangle self 'modelToView' position >.
!
