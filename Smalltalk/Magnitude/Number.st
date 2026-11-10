CLASS Magnitude subclass: 'Number' variables: '' classVariables: ''
METHODS
abs
	^ self negative ifTrue: [ self negated ] ifFalse: [ self ]
!
addToFloat: arg
	^ arg + self asFloat
!
addToFraction: arg
	^ arg asFloat + self asFloat
!
addToSmallInt: arg
	^ arg asFloat + self
!
divideByFloat: arg
	^ arg / self asFloat
!
divideBySmallInt: arg
	^ arg asFloat / self
!
equalToFloat: arg
	^ arg = self asFloat
!
lessThanFloat: arg
	^ arg < self asFloat
!
multByFloat: arg
	^ arg * self asFloat
!
multBySmallInt: arg
	^ arg asFloat * self
!
negated
	^ 0 - self
!
negative
	^ self < 0
!
subtractFromFloat: arg
	^ arg - self asFloat
!
subtractFromSmallInt: arg
	^ arg asFloat - self
!
