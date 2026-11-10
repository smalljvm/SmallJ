CLASS TestCase subclass: 'TestArray' variables: '' classVariables: ''
	"Unit tests for Array.
	 Arrays have no value equality, so they are compared by printString.
	 Run with: TestArray run"
METHODS
testAdd
	| array |
	array := #( 1 2 ).
	"add: returns a new array."
	self assert: ( array add: 3 ) printString = #( 1 2 3 ) printString.
	self assert: array size = 2.
!
testAtPut
	| array |
	array := Array new: 2.
	self assert: ( array at: 1 ) isNil.
	array at: 1 put: 5.
	self assert: ( array at: 1 ) = 5.
!
testConcatenate
	self assert: ( #( 1 2 ) + #( 3 ) ) printString = #( 1 2 3 ) printString.
!
testCopy
	| array copy |
	array := #( 1 2 ).
	copy := array copy.
	self assert: ( copy == array ) not.
	self assert: copy printString = array printString.
!
testFromTo
	self assert: ( #( 1 2 3 4 ) from: 2 to: 3 ) printString = #( 2 3 ) printString.
	self assert: ( #( 1 2 3 4 ) from: 2 size: 2 ) printString = #( 2 3 ) printString.
	self assert: ( #( 1 2 3 4 ) from: 3 to: 9 ) printString = #( 3 4 ) printString.
	self assert: ( #( 1 2 3 4 ) from: 0 to: 2 ) printString = #( 1 2 ) printString.
	self assert: ( #( 1 2 3 4 ) from: 3 to: 2 ) isEmpty.
!
testNew
	self assert: ( Array new: 3 ) size = 3.
	self assert: ( Array new: 0 ) isEmpty.
!
testRemoveAt
	self assert: ( #( 1 2 3 ) removeAt: 2 ) printString = #( 1 3 ) printString.
	self assert: ( #( 1 2 3 ) removeAt: 4 ) size = 3.
!
testStrings
	self assert: #( 1 2 ) asStringArray first = '1'.
	self assert: ( #( 1 2 ) asStringArray first isKindOf: String ).
!
