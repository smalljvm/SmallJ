CLASS Integer subclass: 'SmallLong' variables: '' classVariables: ''
	"Implements Java.lang.Long and long type.
	 For now, does not automatically convert to other integer types (Small and Large).
	 The main use of this class is to use it in the FFI."
META new
	"Can't create this way, return zero."
	^ self new: 0.
!
META new: aSmallInt
	^ < 99 self aSmallInt >.
!
METHOD * arg
	^ < 97 self arg >.
!
METHOD + arg
	^ < 92 self arg >.
!
METHOD - arg
	^ < 98 self arg >.
!
METHOD < arg
	^ < 95 self arg >.
!
METHOD = arg
	^ < 96 self arg >.
!
METHOD printString
	"String toString()"
	^ < 39 String 'java.lang.Long' 'toString' self >.
!
METHOD quo: arg
	( 0 = arg ) ifTrue: [ ^ self error: 'Division by zero.' ].
	^ < 93 self arg >.
!
METHOD rem: arg
	( 0 = arg ) ifTrue: [ ^ self error: 'Division by zero.' ].
	^ < 94 self arg >.
!
