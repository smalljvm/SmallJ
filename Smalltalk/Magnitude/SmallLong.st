CLASS Integer subclass: 'SmallLong' variables: '' classVariables: ''
	"Implements Java.lang.Long and long type.
	 For now, does not automatically convert to other integer types (Small and Large).
	 The main use of this class is to use it in the FFI."
CLASSMETHODS
new
	"Can't create this way, return zero."
	^ self new: 0.
!
new: aSmallInt
	^ < 65 self aSmallInt >.
!
METHODS
= arg
	^ < 62 self arg >.
!
< arg
	^ < 61 self arg >.
!
* arg
	^ < 63 self arg >.
!
+ arg
	^ < 58 self arg >.
!
- arg
	^ < 64 self arg >.
!
quo: arg
	^ < 59 self arg >.
!
rem: arg
	^ < 60 self arg >.
!
printString
	"String toString()"
	^ < 39 String 'java.lang.Long' 'toString' self >.
!
