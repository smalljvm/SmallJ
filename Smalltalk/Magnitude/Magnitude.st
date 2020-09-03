CLASS Object subclass: 'Magnitude' variables: '' classVariables: ''
METHOD <= arg
	^ self < arg or: [ self = arg ]
!
METHOD > arg
	^ arg < self
!
METHOD >= arg
	^ self > arg or: [ self = arg ]
!
METHOD between: low and: high
	^ low <= self and: [ self <= high ]
!
METHOD max: arg
	^ self < arg ifTrue: [ arg ] ifFalse: [ self ]
!
METHOD min: arg
	^ self < arg ifTrue: [ self ] ifFalse: [ arg ]
!
