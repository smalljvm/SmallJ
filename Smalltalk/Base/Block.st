CLASS Context subclass: 'Block' variables: 'argumentLocation creatingContext oldBytePointer' classVariables: ''
METHODS
fork
   "Block must not have arguments."
   < 19 self >.
!
onError: errorBlock
	"Evaluate self and return its value.
	 If an error is raised while evaluating self, errorBlock is evaluated with the error message
	 (see Object>>error:). The thread is still halted after that, so this method then does not return."
	^ self value.
!
value
	"Execute block."
	< 8 self >.
!
value: a
	"Execute block with 1 argument."
	< 8 a self >.
!
value: a value: b
	"Execute block with 2 arguments."
	< 8 a b self >.
!
whileFalse: aBlock
	self value ifFalse: [
		aBlock value.
		^ self whileFalse: aBlock ].
!
whileTrue: aBlock
	self value ifTrue: [
		aBlock value.
		^ self whileTrue: aBlock ].
!
