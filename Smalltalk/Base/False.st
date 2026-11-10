CLASS Boolean subclass: 'False' variables: '' classVariables: ''
CLASSMETHODS
new
	" there is only one false value "
	^ false.
!
METHODS
and: aBlock
	^ false
!
ifTrue: trueBlock ifFalse: falseBlock
	^ falseBlock value.
!
not
	^ true.
!
or: aBlock
	^ aBlock value.
!
printString
	^ 'false'.
!
