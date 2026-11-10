CLASS TestCase subclass: 'TestList' variables: '' classVariables: ''
	"Unit tests for List, a growable indexed collection.
	 Run with: TestList run"
METHODS
testAdd
	| list |
	list := List new.
	1 to: 12 do: [ :each | list add: each ].
	self assert: list size = 12.
	self assert: list first = 1.
	self assert: list last = 12.
!
testAddFirst
	| list |
	list := #( 2 3 ) asList.
	list addFirst: 1.
	self assert: list asArray printString = #( 1 2 3 ) printString.
!
testAt
	| list |
	list := #( 5 6 ) asList.
	self assert: ( list at: 2 ) = 6.
	self assert: ( list at: 3 ifAbsent: [ 0 ] ) = 0.
	self assert: ( list at: 0 ifAbsent: [ 0 ] ) = 0.
	list at: 1 put: 4.
	self assert: list first = 4.
!
testInsert
	| list |
	list := #( 1 3 ) asList.
	list insert: 2 at: 2.
	self assert: list asArray printString = #( 1 2 3 ) printString.
	list insert: 4 at: 4.
	self assert: list last = 4.
!
testPrintString
	self assert: #( 1 ) asList printString = 'List( 1  )'.
!
testRemove
	| list |
	list := #( 1 2 3 2 ) asList.
	list remove: 2.
	self assert: list asArray printString = #( 1 3 2 ) printString.
	list removeAt: 1.
	self assert: list asArray printString = #( 3 2 ) printString.
	self assert: ( list remove: 9 ifAbsent: [ 0 ] ) = 0.
	self assert: list size = 2.
!
