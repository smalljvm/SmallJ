CLASS Magnitude subclass: 'Number' variables: '' classVariables: ''
METHOD abs
	^ self negative ifTrue: [ self negated ] ifFalse: [ self ]
!
METHOD addToFloat: arg
	^ arg + self asFloat
!
METHOD addToFraction: arg
	^ arg asFloat + self asFloat
!
METHOD addToSmallInt: arg
	^ arg asFloat + self
!
METHOD divideByFloat: arg
	^ arg / self asFloat
!
METHOD divideBySmallInt: arg
	^ arg asFloat / self
!
METHOD equalToFloat: arg
	^ arg = self asFloat
!
METHOD lessThanFloat: arg
	^ arg < self asFloat
!
METHOD multByFloat: arg
	^ arg * self asFloat
!
METHOD multBySmallInt: arg
	^ arg asFloat * self
!
METHOD negated
	^ 0 - self
!
METHOD negative
	^ self < 0
!
METHOD subtractFromFloat: arg
	^ arg - self asFloat
!
METHOD subtractFromSmallInt: arg
	^ arg asFloat - self
!
