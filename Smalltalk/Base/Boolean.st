CLASS Object subclass: 'Boolean' variables: '' classVariables: ''
METHODS
and: aBlock
	^ self
		ifTrue: [ aBlock value ]
		ifFalse: [ false ]
!
ifFalse: aBlock
	^ self
		ifTrue: [ nil ]
		ifFalse: [ aBlock value ]
!
ifFalse: falseBlock ifTrue: trueBlock
	^ self
		ifTrue: [ trueBlock  value ]
		ifFalse: [ falseBlock value ]
!
ifTrue: aBlock
	^ self
		ifTrue: [ aBlock value ]
		ifFalse: [ nil ]
!
not
	^ self
		ifTrue: [ false ]
		ifFalse: [ true ]
!
or: aBlock
	^ self
		ifTrue: [ true ]
		ifFalse: [ aBlock value ]
!
