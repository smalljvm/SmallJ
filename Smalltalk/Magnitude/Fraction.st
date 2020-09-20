CLASS Number subclass: 'Fraction' variables: 'top bottom' classVariables: ''
META top: t
	^ self in: (self in: super new at: 1 put: t) at: 2 put: 1
!
META top: t bottom: b  | r |
	b = 0 ifTrue: [ ^ self error: ' division by zero in fraction'].
	r := t gcd: b.
	^ self in: (self in: super new at: 1 put: (t quo: r)) at: 2 put: (b quo: r)
!
METHOD * arg
	^ arg multByFraction: self
!
METHOD + arg
	^ arg addToFraction: self
!
METHOD - arg
	^ arg subtractFromFraction: self
!
METHOD / arg
	^ arg divideByFraction: self
!
METHOD addToFraction: arg
	^ Fraction top: top * arg bottom + (bottom * arg top) bottom: bottom * arg bottom
!
METHOD addToSmallInt: arg
	^ (Fraction top: arg) + self
!
METHOD asFloat
	^ top asFloat / bottom asFloat
!
METHOD bottom
	^ bottom
!
METHOD divideByFraction: arg
	^ Fraction top: arg top * bottom bottom: arg bottom * top
!
METHOD divideBySmallInt: arg
	^ (Fraction top: arg) / self
!
METHOD multByFraction: arg
	^ Fraction top: top * arg top bottom: bottom * arg bottom
!
METHOD multBySmallInt: arg
	^ (Fraction top: arg) * self
!
METHOD printString
	^ '(' + top printString + '/' + bottom printString + ')'
!
METHOD subtractFromFraction: arg
	^ Fraction top: arg top * bottom - (top * arg bottom) bottom: bottom * arg bottom
!
METHOD subtractFromSmallInt: arg
	^ (Fraction top: arg) - self
!
METHOD top
	^ top
!
