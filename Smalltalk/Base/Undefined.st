CLASS Object subclass: 'Undefined' variables: '' classVariables: ''
META new
	" there is only one nil object "
	^ nil.
!
METHOD isNil
	" yes, we are nil "
	^ true.
!
METHOD notNil
	" no, we are not not-nil "
	^ false.
!
METHOD printString
	^ 'nil'.
!
