CLASS Object subclass: 'Boolean' variables: '' classVariables: ''
METHOD and: aBlock
	^ self
		ifTrue: [ aBlock value ]
		ifFalse: [ false ]
!
METHOD ifFalse: aBlock
	^ self
		ifTrue: [ nil ]
		ifFalse: [ aBlock value ]
!
METHOD ifFalse: falseBlock ifTrue: trueBlock
	^ self
		ifTrue: [ trueBlock  value ]
		ifFalse: [ falseBlock value ]
!
METHOD ifTrue: aBlock
	^ self
		ifTrue: [ aBlock value ]
		ifFalse: [ nil ]
!
METHOD not
	^ self
		ifTrue: [ false ]
		ifFalse: [ true ]
!
METHOD or: aBlock
	^ self
		ifTrue: [ true ]
		ifFalse: [ aBlock value ]
!
