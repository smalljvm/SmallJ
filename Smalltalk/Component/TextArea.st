CLASS TextComponent subclass: 'TextArea' variables: '' classVariables: ''
	"Implements javax.swing.JTextArea"
CLASSMETHODS
new
	^ < 37 self 'javax.swing.JTextArea' >.
!
METHODS
editable: bool
	"void setEditable( boolean bool )"
	< 38 nil self 'setEditable' bool >.
!
lineCount
	"int getLineCount()"
	^ < 38 SmallInt self 'getLineCount' >.
!
lineStartOffset: lineNum
	"int getLineStartOffset( int line )
	 The first line number shall be 1."
	^ < 38 SmallInt self 'getLineStartOffset' ( lineNum - 1 ) >.
!
tabSize: size
	"void setTabSize( int size )"
	< 38 nil self 'setTabSize' size >.
!
caretLinePosition: lineNum
	"Position caret at the start of lineNum in self."
	| offset |
	self caretPosition: (
		 self lineStartOffset: lineNum ).
!
