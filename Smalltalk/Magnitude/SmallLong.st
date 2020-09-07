CLASS Integer subclass: 'SmallLong' variables: '' classVariables: ''
	"Implements Java.lang.Long and long type.
	 For now, does not automatically convert to other integer types (Small and Large).
	 The main use of this class is to use it in the FFI."
META new
	"Can't create this way, return zero."
	^ self new: 0.
!
META new: aSmallInt
	^ < 65 self aSmallInt >.
!
METHOD = arg
	^ < 62 self arg >.
!
METHOD < arg
	^ < 61 self arg >.
!
METHOD * arg
	^ < 63 self arg >.
!
METHOD + arg
	^ < 58 self arg >.
!
METHOD - arg
	^ < 64 self arg >.
!
METHOD quo: arg
	^ < 59 self arg >.
!
METHOD rem: arg
	^ < 60 self arg >.
!
METHOD printString
	"String toString()"
	^ < 39 String 'java.lang.Long' 'toString' self >.
!
