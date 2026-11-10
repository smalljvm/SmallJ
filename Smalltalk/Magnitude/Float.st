CLASS Number subclass: 'Float' variables: '' classVariables: ''
	"Smalltalk floats are implemented as Java type double."
CLASSMETHODS
fromSmallInt: int
	^ < 50 self int >
!
new
	^ self error: 'Floats cannot be created with new.'.
!
random
	"static double random()"
	^ < 39 Float 'java.lang.Math' 'random' >.
!
METHODS
* arg
	^ arg multByFloat: self.
!
+ arg
	^ arg addToFloat: self.
!
- arg
	^ arg subtractFromFloat: self.
!
/ arg
	^ arg divideByFloat: self.
!
< arg
	^ arg asFloat lessThanFloat: self.
!
= arg
	^ arg asFloat equalToFloat: self.
!
@ y
	"Return new point with self as x and arg as y"
	^ Point x: self y: y
!
addToFloat: arg
	^ < 51 arg self >.
!
asFloat
	^ self.
!
asInteger
	^ < 57 self >.
!
divideByFloat: arg
	^ < 54 arg self >.
!
equalToFloat: arg
	^ < 56 arg self >.
!
lessThanFloat: arg
	^ < 55 arg self >.
!
lessThanSmallInt: arg
  ^ arg asFloat < self.
!
multByFloat: arg
	^ < 53 arg self >.
!
sqrt
	"double java.lang.Math.sqrt( double num )"
	^ < 39 Float 'java.lang.Math' 'sqrt' self >.
!
printString
	"String toString()"
	^ < 39 String 'java.lang.Double' 'toString' self >.
!
subtractFromFloat: arg
	^ < 52 arg self >.
!
