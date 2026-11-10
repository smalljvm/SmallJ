CLASS TestCase subclass: 'TestObject' variables: '' classVariables: ''
	"Unit tests for Object.
	 Run with: TestObject run"
METHODS
testClass
	self assert: Object new class == Object.
	self assert: 3 class == SmallInt.
	self assert: 'abc' class == String.
!
testEquality
	| object |
	object := Object new.
	self assert: object = object.
	self assert: object == object.
	self assert: ( object = Object new ) not.
	self assert: object ~= Object new.
!
testIfNil
	self assert: ( nil ifNil: [ 1 ] ) = 1.
	self assert: ( Object new ifNil: [ 1 ] ) isNil.
	self assert: ( Object new ifNotNil: [ 1 ] ) = 1.
	self assert: ( nil ifNotNil: [ 1 ] ) isNil.
!
testIsKindOf
	self assert: ( 3 isKindOf: Integer ).
	self assert: ( 3 isKindOf: Object ).
	self assert: ( 'abc' isKindOf: Array ).
	self assert: ( 'abc' isKindOf: Integer ) not.
!
testIsNil
	self assert: Object new isNil not.
	self assert: Object new notNil.
!
testPrintString
	self assert: Object new printString = 'a Object'.
!
testRespondsTo
	self assert: ( Object new respondsTo: 'isNil' ).
	self assert: ( 3 respondsTo: 'printString' ).
	self assert: ( Object new respondsTo: 'noSuchMessage' ) not.
!
