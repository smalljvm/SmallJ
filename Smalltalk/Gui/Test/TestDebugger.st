CLASS TestCase subclass: 'TestDebugger' variables: '' classVariables: ''
	"Unit tests for Debugger, without showing its window.
	 The context tab is created without the frame, then loaded with the current call stack.
	 Run with: TestDebugger run"
METHODS
testLoadContexts
	| debugger contexts arguments |
	debugger := Debugger new.
	debugger createContextTab.
	Object in: debugger initialize: 'startContext' with: Context current.
	debugger loadContexts.

	contexts := self valueOf: 'contexts' in: debugger.
	self assert: contexts size > 1.
	"The start context is the one of method Context class>>current, called by this test method."
	self assert: ( contexts at: 1 ) method name = 'current'.
	self assert: ( contexts at: 2 ) method name = 'testLoadContexts'.

	"The arguments of the selected first context are loaded: its receiver is the Context class."
	arguments := self valueOf: 'arguments' in: debugger.
	self assert: arguments first == Context.
!
