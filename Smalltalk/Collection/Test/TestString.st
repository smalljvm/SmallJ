CLASS TestCase subclass: 'TestString' variables: '' classVariables: ''
	"Unit tests for String.
	 Run with: TestString run"
METHODS
testAt
	self assert: ( 'abc' at: 2 ) = $b.
	self assert: ( 'abc' at: 4 ifAbsent: [ nil ] ) isNil.
!
testAtPut
	| string |
	string := String new: 2.
	string at: 1 put: $o.
	string at: 2 put: $k.
	self assert: string = 'ok'.
!
testCompare
	self assert: 'abc' = 'abc'.
	self assert: ( 'abc' = 'abd' ) not.
	self assert: 'abc' < 'abd'.
	self assert: 'ab' < 'abc'.
	self assert: ( 'abc' < 'abc' ) not.
!
testConcatenate
	self assert: 'ab' + 'cd' = 'abcd'.
	self assert: 'a' + 1 = 'a1'.
!
testCopy
	| string |
	string := 'abc'.
	self assert: string copy = string.
	self assert: ( string copy == string ) not.
!
testDoIt
	self assert: '3 + 4' doIt = 7.
!
testFind
	self assert: ( 'hello world' find: 'world' ) = 7.
	self assert: ( 'hello' find: 'x' ) isNil.
!
testLast
	self assert: ( 'hello' last: 3 ) = 'llo'.
	self assert: ( 'hi' last: 5 ) = 'hi'.
!
testLowerCase
	self assert: 'HeLLo 1' asLowerCase = 'hello 1'.
!
testPrintString
	self assert: 'abc' printString = 'abc'.
!
testTrim
	self assert: '  ab c  ' trim = 'ab c'.
	self assert: 'abc' trim = 'abc'.
	self assert: '   ' trim isEmpty.
!
testWords
	| words |
	words := ' one  two three ' asWords.
	self assert: words size = 3.
	self assert: words first = 'one'.
	self assert: words last = 'three'.
	self assert: ( 'a,b;c' asWords: ',;' ) size = 3.
!
