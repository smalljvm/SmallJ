CLASS TestCase subclass: 'TestCollection' variables: '' classVariables: ''
	"Unit tests for Collection, the abstract base class of all collections.
	 It is tested through its subclasses Array and List.
	 Arrays have no value equality, so they are compared by printString.
	 Run with: TestCollection run"
METHODS
testAddAll
	| list |
	list := List new.
	list addAll: #( 1 2 3 ).
	self assert: list size = 3.
	self assert: list last = 3.
!
testConversions
	self assert: ( #( 3 1 2 ) asList isKindOf: List ).
	self assert: #( 3 1 2 ) asList size = 3.
	self assert: #( 3 1 2 ) asOrdered asArray printString = #( 1 2 3 ) printString.
	self assert: ( #( 1 2 3 ) asOrdered: [ :a :b | a > b ] ) first = 3.
	self assert: ( #( 1 2 ) asList asArray isKindOf: Array ).
!
testCollect
	self assert: ( #( 1 2 3 ) collect: [ :each | each * 2 ] ) asArray printString = #( 2 4 6 ) printString.
!
testFind
	self assert: ( #( 1 2 3 ) find: [ :each | each > 1 ] ifAbsent: [ 0 ] ) = 2.
	self assert: ( #( 1 2 3 ) find: [ :each | each > 5 ] ifAbsent: [ 0 ] ) = 0.
!
testIncludes
	self assert: ( #( 1 2 3 ) includes: 2 ).
	self assert: ( #( 1 2 3 ) includes: 4 ) not.
	self assert: ( #( 1 2 3 ) includesTest: [ :each | each > 2 ] ).
	self assert: ( #( 1 2 3 ) includesTest: [ :each | each > 3 ] ) not.
!
testInject
	self assert: ( #( 1 2 3 ) inject: 0 into: [ :sum :each | sum + each ] ) = 6.
!
testIsEmpty
	self assert: ( Array new: 0 ) isEmpty.
	self assert: List new isEmpty.
	self assert: #( 1 ) isEmpty not.
!
testSelectReject
	self assert: ( #( 1 2 3 4 ) select: [ :each | each > 2 ] ) asArray printString = #( 3 4 ) printString.
	self assert: ( #( 1 2 3 4 ) reject: [ :each | each > 2 ] ) asArray printString = #( 1 2 ) printString.
!
