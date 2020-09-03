CLASS Boolean subclass: 'True' variables: '' classVariables: ''
META new
	" there is only one true value "
	^ true.
!
METHOD and: aBlock
	^ aBlock value.
!
METHOD ifTrue: trueBlock ifFalse: falseBlock
	^ trueBlock value.
!
METHOD not
	^ false.
!
METHOD printString
	^ 'true'.
!
METHOD or: aBlock
	^ true.
!
