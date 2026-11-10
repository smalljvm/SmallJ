CLASS Object subclass: 'Undefined' variables: '' classVariables: ''
CLASSMETHODS
new
	" there is only one nil object "
	^ nil.
!
METHODS
isNil
	" yes, we are nil "
	^ true.
!
notNil
	" no, we are not not-nil "
	^ false.
!
printString
	^ 'nil'.
!
