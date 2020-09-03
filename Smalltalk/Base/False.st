CLASS Boolean subclass: 'False' variables: '' classVariables: ''
META new
	" there is only one false value "
	^ false.
!
METHOD and: aBlock
	^ false
!
METHOD ifTrue: trueBlock ifFalse: falseBlock
	^ falseBlock value.
!
METHOD not
	^ true.
!
METHOD or: aBlock
	^ aBlock value.
!
METHOD printString
	^ 'false'.
!
