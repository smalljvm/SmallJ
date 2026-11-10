CLASS Object subclass: 'Magnitude' variables: '' classVariables: ''
METHODS
<= arg
	^ self < arg or: [ self = arg ]
!
> arg
	^ arg < self
!
>= arg
	^ self > arg or: [ self = arg ]
!
between: low and: high
	^ low <= self and: [ self <= high ]
!
max: arg
	^ self < arg ifTrue: [ arg ] ifFalse: [ self ]
!
min: arg
	^ self < arg ifTrue: [ self ] ifFalse: [ arg ]
!
