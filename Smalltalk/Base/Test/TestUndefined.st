CLASS TestCase subclass: 'TestUndefined' variables: '' classVariables: ''
	"Unit tests for Undefined, the class of nil.
	 Run with: TestUndefined run"
METHODS
testClass
	self assert: nil class == Undefined.
!
testIsNil
	self assert: nil isNil.
	self assert: nil notNil not.
!
testNew
	"There is only one nil."
	self assert: Undefined new == nil.
!
testPrintString
	self assert: nil printString = 'nil'.
!
