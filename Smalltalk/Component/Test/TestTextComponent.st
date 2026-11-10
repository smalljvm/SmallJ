CLASS TestCase subclass: 'TestTextComponent' variables: '' classVariables: ''
	"Unit tests for TextComponent, the abstract base class of TextField and TextArea.
	 It is tested through its subclass TextField.
	 Run with: TestTextComponent run"
METHODS
testCaretPosition
	| field |
	field := TextField new.
	field text: 'abc'.
	field caretPosition: 2.
	self assert: < 38 SmallInt field 'getCaretPosition' > = 2.
!
testEditable
	| field |
	field := TextField new.
	self assert: < 38 Boolean field 'isEditable' >.
	field editable: false.
	self assert: < 38 Boolean field 'isEditable' > not.
!
testSelectedText
	| field |
	field := TextField new.
	field text: 'hello'.
	self assert: field selectedText isNil.
	< 38 nil field 'select' 1 3 >.
	self assert: field selectedText = 'el'.
!
testText
	| field |
	field := TextField new.
	self assert: field text = ''.
	field text: 'hello'.
	self assert: field text = 'hello'.
!
