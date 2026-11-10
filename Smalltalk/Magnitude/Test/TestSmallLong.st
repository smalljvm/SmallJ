CLASS TestCase subclass: 'TestSmallLong' variables: '' classVariables: ''
	"Unit tests for SmallLong, the Java 64 bit long integers.
	 Run with: TestSmallLong run"
METHODS
testArithmetic
	| a b |
	a := SmallLong new: 7.
	b := SmallLong new: 2.
	self assert: ( a + b ) = ( SmallLong new: 9 ).
	self assert: ( a - b ) = ( SmallLong new: 5 ).
	self assert: ( a * b ) = ( SmallLong new: 14 ).
	self assert: ( a quo: b ) = ( SmallLong new: 3 ).
	self assert: ( a rem: b ) = ( SmallLong new: 1 ).
!
testComparing
	self assert: ( SmallLong new: 1 ) < ( SmallLong new: 2 ).
	self assert: ( ( SmallLong new: 2 ) < ( SmallLong new: 1 ) ) not.
	self assert: ( SmallLong new: 3 ) = ( SmallLong new: 3 ).
!
testNew
	self assert: SmallLong new = ( SmallLong new: 0 ).
	self assert: ( ( SmallLong new: 5 ) isKindOf: SmallLong ).
!
testPrintString
	self assert: ( SmallLong new: 42 ) printString = '42'.
	self assert: ( SmallLong new: -42 ) printString = '-42'.
!
