CLASS TestCase subclass: 'TestMethod' variables: '' classVariables: ''
	"Unit tests for Method.
	 Run with: TestMethod run"
METHODS
testCompiledMethod
	| method |
	method := Object parseMethod: 'answer ^ 42'.
	self assert: method name = 'answer'.
	self assert: method printString = 'answer'.
	self assert: method byteCodes size > 0.
	"parseMethod: does not add the method to the class."
	self assert: ( Object new respondsTo: 'answer' ) not.
!
testMethodInClass
	| method |
	method := Boolean methods find: [ :each | each name = 'not' ] ifAbsent: [ nil ].
	self assert: method notNil.
	self assert: method name = 'not'.
	self assert: method lineNum > 1.
	self assert: method stackSize > 0.
!
