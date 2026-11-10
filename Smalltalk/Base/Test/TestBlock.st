CLASS TestCase subclass: 'TestBlock' variables: '' classVariables: ''
	"Unit tests for Block.
	 Run with: TestBlock run
	 Not tested: fork (see TestSemaphore) and the error path of onError:, which halts the thread."
METHODS
testOnError
	self assert: ( [ 3 + 4 ] onError: [ :message | 0 ] ) = 7.
!
testValue
	self assert: [ 3 + 4 ] value = 7.
	self assert: ( [ :a | a * 2 ] value: 4 ) = 8.
	self assert: ( [ :a :b | a - b ] value: 5 value: 3 ) = 2.
!
testWhileFalse
	| count condition |
	count := 0.
	condition := [ count >= 3 ].
	condition whileFalse: [ count := count + 1 ].
	self assert: count = 3.
!
testWhileTrue
	| count condition |
	count := 0.
	condition := [ count < 3 ].
	condition whileTrue: [ count := count + 1 ].
	self assert: count = 3.
	"Inlined by the compiler, because both receiver and argument are literal blocks."
	[ count < 5 ] whileTrue: [ count := count + 1 ].
	self assert: count = 5.
!
