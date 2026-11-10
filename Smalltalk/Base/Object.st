CLASS Object
	"The Object class cannot be created as a subclass:
	 	nil subclass: 'Object' variables: '' classVariables: ''"
CLASSMETHODS
test
	^ 'This is a test'.
!
halt
	"Primitive thread death.
	 Called after self error:."
	< 34 >.
!
in: object add: newValue
	"Add new data value to object."
	^ < 32 object newValue >
!
in: object at: index
	"Get index-th data member from object."
	^ < 30 object index >
!
in: object at: index put: value
	"Set index-th data member of object to value.
	 Dangerous, use carefully."
	^ < 18 object index value >.
!
in: object initialize: variable with: value
	"Set variable in object to value."
	| index |
	index := object class variables indexOf: variable ifAbsent: [
		self error: 'Variable not found: ' + variable ].
	^ self in: object at: index put: value.
!
METHODS
= arg
	"Return true if object has the same value as arg.
	 The default is the object identity test (same object).
	 Value holding objects can overload this."
	^ self == arg.
!
== arg
	"Return true if self points to the same object as arg."
	^ < 1 self arg >.
!
~= arg
	"Return true if object does *not* have the same value as arg."
	^ ( self = arg ) not.
!
class
	"Return class of self."
	^ < 2 self >.
!
error: message
	"Show message in the debugger and halt the thread.
	 Before that, the error block of the nearest Block>>onError: on the call stack is evaluated with message."
	| errorBlock |
	errorBlock := Context current previousContext errorBlock.
	errorBlock notNil ifTrue: [ errorBlock value: message ].
	Debugger new show: message.
	Object halt.
!
ifNil: block
	"Evaluate block if receiver is nil."
	^ self isNil ifTrue: block.
!
ifNotNil: block
	"Evaluate block if receiver is *not* nil."
	^ self notNil ifTrue: block.
!
inspect
	Inspector show: self.
!
isKindOf: aClass
	"Return true if self is an instance of aClass or one of its parents."
	| class |
	class := self class.
	[ class notNil ] whileTrue: [
		class == aClass ifTrue: [ ^ true ].
		class := class superclass ].
	^ false.
!
isNil
	^ false.
!
notNil
	^ true.
!
printString
	^ 'a ' + self class printString.
!
respondsTo: aMessage
	^ self class allMethods includesTest: [ :m | m name = aMessage ]
!
