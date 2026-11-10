CLASS TestCase subclass: 'TestTextField' variables: '' classVariables: ''
	"Unit tests for TextField. See also TestTextComponent.
	 Run with: TestTextField run"
METHODS
testNew
	| field |
	field := TextField new.
	self assert: ( field isKindOf: TextField ).
	self assert: ( field isKindOf: TextComponent ).
	field text: 'abc'.
	self assert: field text = 'abc'.
!
