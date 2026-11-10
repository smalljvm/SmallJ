CLASS TestCase subclass: 'TestContext' variables: '' classVariables: ''
	"Unit tests for Context, the activation record of a method.
	 Run with: TestContext run"
METHODS
testCurrent
	"Context current is the context of the method current itself, so its sender is this test method."
	| context |
	context := Context current.
	self assert: context method name = 'current'.
	self assert: context previousContext method name = 'testCurrent'.
	self assert: ( context previousContext arguments at: 1 ) == self.
!
testBacktrace
	self assert: ( Context current backtrace find: 'testBacktrace' ) notNil.
!
testPerformWithArguments
	| method arguments |
	method := Object parseMethod: 'plus: a ^ a + 1'.
	arguments := Array new: 2.
	arguments at: 1 put: nil.
	arguments at: 2 put: 41.
	self assert: ( Context new perform: method withArguments: arguments ) = 42.
!
