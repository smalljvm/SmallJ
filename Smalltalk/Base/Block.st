CLASS Context subclass: 'Block' variables: 'argumentLocation creatingContext oldBytePointer' classVariables: ''
METHOD fork
   "Block must not have arguments.."
   < 19 self >.
!
METHOD value
	"Execute block."
	< 8 self >.
!
METHOD value: a
	"Execute block with 1 argument."
	< 8 a self >.
!
METHOD value: a value: b
	"Execute block with 2 arguments."
	< 8 a b self >.
!
METHOD whileFalse: aBlock
	self value ifFalse: [
		aBlock value.
		^ self whileFalse: aBlock ].
!
METHOD whileTrue: aBlock
	self value ifTrue: [
		aBlock value.
		^ self whileTrue: aBlock ].
!
