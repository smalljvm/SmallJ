CLASS Boolean subclass: 'True' variables: '' classVariables: ''
CLASSMETHODS
new
	" there is only one true value "
	^ true.
!
METHODS
and: aBlock
	^ aBlock value.
!
ifTrue: trueBlock ifFalse: falseBlock
	^ trueBlock value.
!
not
	^ false.
!
printString
	^ 'true'.
!
or: aBlock
	^ true.
!
