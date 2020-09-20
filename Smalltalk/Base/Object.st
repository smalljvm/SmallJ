CLASS Object
	"The Object class cannot be created as a subclass:
	 	nil subclass: 'Object' variables: '' classVariables: ''"
META halt
	"Primitive thread death.
	 Called after self error:."
	< 34 >.
!
META in: object add: newValue
	"Add new data value to object."
	^ < 32 object newValue >
!
META in: object at: index
	"Get index-th data member from object."
	^ < 30 object index >
!
META in: object at: index put: value
	"Set index-th data member of object to value.
	 Dangerous, use carefully."
	^ < 18 object index value >.
!
META in: object initialize: variable with: value
	"Set variable in object to value."
	| index |
	index := object class variables indexOf: variable ifAbsent: [
		self error: 'Variable not found: ' + variable ].
	^ self in: object at: index put: value.
!
METHOD = arg
	"Return true if object has the same value as arg.
	 The default is the object identity test (same object).
	 Value holding objects can overload this."
	^ self == arg.
!
METHOD == arg
	"Return true if self points to the same object as arg."
	^ < 1 self arg >.
!
METHOD ~= arg
	"Return true if object does *not* have the same value as arg."
	^ ( self = arg ) not.
!
METHOD class
	"Return class of self."
	^ < 2 self >.
!
METHOD error: message
	Debugger new show: message.
	Object halt.
!
METHOD ifNil: block
	"Evaluate block if receiver is nil."
	^ self isNil ifTrue: block.
!
METHOD ifNotNil: block
	"Evaluate block if receiver is *not* nil."
	^ self notNil ifTrue: block.
!
METHOD inspect
	Inspector show: self.
!
METHOD isKindOf: aClass
	"Return true if self is an instance of aClass or one of its parents."
	| class |
	class := self class.
	[ class notNil ] whileTrue: [
		class == aClass ifTrue: [ ^ true ].
		class := class superclass ].
	^ false.
!
METHOD isNil
	^ false.
!
METHOD notNil
	^ true.
!
METHOD printString
	^ 'a ' + self class printString.
!
METHOD respondsTo: aMessage
	^ self class allMethods includesTest: [ :m | m name = aMessage ]
!
