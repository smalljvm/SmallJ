CLASS TestCase subclass: 'TestTextArea' variables: '' classVariables: ''
	"Unit tests for TextArea. Line numbers start at 1.
	 Run with: TestTextArea run"
METHODS
text
	"Return a text of 3 lines."
	| newline |
	newline := Char newline asString.
	^ 'one' + newline + 'two' + newline + 'three'.
!
testCaretLinePosition
	| area |
	area := TextArea new.
	area text: self text.
	area caretLinePosition: 2.
	self assert: < 38 SmallInt area 'getCaretPosition' > = 4.
!
testEditable
	| area |
	area := TextArea new.
	area editable: false.
	self assert: < 38 Boolean area 'isEditable' > not.
!
testLines
	| area |
	area := TextArea new.
	area text: self text.
	self assert: area lineCount = 3.
	self assert: ( area lineStartOffset: 1 ) = 0.
	self assert: ( area lineStartOffset: 3 ) = 8.
!
testTabSize
	| area |
	area := TextArea new.
	area tabSize: 2.
	self assert: < 38 SmallInt area 'getTabSize' > = 2.
!
