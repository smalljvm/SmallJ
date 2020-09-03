CLASS Number subclass: 'Float' variables: '' classVariables: ''
	"Smalltalk floats are implemented as Java type double."
META fromSmallInt: int
	^ < 50 self int >
!
META new
	^ self error: 'Floats cannot be created with new.'.
!
META random
	"static double random()"
	^ < 39 Float 'java.lang.Math' 'random' >.
!
METHOD * arg
	^ arg multByFloat: self.
!
METHOD + arg
	^ arg addToFloat: self.
!
METHOD - arg
	^ arg subtractFromFloat: self.
!
METHOD / arg
	^ arg divideByFloat: self.
!
METHOD < arg
	^ arg asFloat lessThanFloat: self.
!
METHOD = arg
	^ arg asFloat equalToFloat: self.
!
METHOD @ y
	"Return new point with self as x and arg as y"
	^ Point x: self y: y
!
METHOD addToFloat: arg
	^ < 51 arg self >.
!
METHOD asFloat
	^ self.
!
METHOD asInteger
	^ < 57 self >.
!
METHOD divideByFloat: arg
	^ < 54 arg self >.
!
METHOD equalToFloat: arg
	^ < 56 arg self >.
!
METHOD lessThanFloat: arg
	^ < 55 arg self >.
!
METHOD lessThanSmallInt: arg
  ^ arg asFloat < self.
!
METHOD multByFloat: arg
	^ < 53 arg self >.
!
METHOD sqrt
	"double java.lang.Math.sqrt( double num )"
	^ < 39 Float 'java.lang.Math' 'sqrt' self >.
!
METHOD printString
	"String toString()"
	^ < 39 String 'java.lang.Double' 'toString' self >.
!
METHOD subtractFromFloat: arg
	^ < 52 arg self >.
!
