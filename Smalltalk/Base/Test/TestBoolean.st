CLASS TestCase subclass: 'TestBoolean' variables: '' classVariables: ''
	"Unit tests for Boolean and its subclasses True and False.
	 Run with: TestBoolean run"
METHODS
testAnd
	self assert: ( true and: [ true ] ).
	self assert: ( true and: [ false ] ) not.
	self assert: ( false and: [ true ] ) not.
	self assert: ( false and: [ false ] ) not.
!
testAndShortCircuit
	"The block argument of and: is evaluated only if the receiver is true."
	| evaluated |
	evaluated := false.
	false and: [ evaluated := true ].
	self assert: evaluated not.
	true and: [ evaluated := true ].
	self assert: evaluated.
!
testIfFalse
	self assert: ( false ifFalse: [ 1 ] ) = 1.
	self assert: ( true ifFalse: [ 1 ] ) isNil.
!
testIfTrue
	self assert: ( true ifTrue: [ 1 ] ) = 1.
	self assert: ( false ifTrue: [ 1 ] ) isNil.
!
testIfTrueIfFalse
	self assert: ( true ifTrue: [ 1 ] ifFalse: [ 2 ] ) = 1.
	self assert: ( false ifTrue: [ 1 ] ifFalse: [ 2 ] ) = 2.
	self assert: ( true ifFalse: [ 1 ] ifTrue: [ 2 ] ) = 2.
	self assert: ( false ifFalse: [ 1 ] ifTrue: [ 2 ] ) = 1.
!
testNew
	"There is only one true and one false."
	self assert: True new == true.
	self assert: False new == false.
!
testNot
	self assert: true not == false.
	self assert: false not == true.
	self assert: true not not == true.
!
testOr
	self assert: ( true or: [ true ] ).
	self assert: ( true or: [ false ] ).
	self assert: ( false or: [ true ] ).
	self assert: ( false or: [ false ] ) not.
!
testOrShortCircuit
	"The block argument of or: is evaluated only if the receiver is false."
	| evaluated |
	evaluated := false.
	true or: [ evaluated := true ].
	self assert: evaluated not.
	false or: [ evaluated := true ].
	self assert: evaluated.
!
testPrintString
	self assert: true printString = 'true'.
	self assert: false printString = 'false'.
!
