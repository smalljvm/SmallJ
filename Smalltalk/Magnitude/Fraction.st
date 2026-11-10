CLASS Number subclass: 'Fraction' variables: 'top bottom' classVariables: ''
CLASSMETHODS
top: t
	^ self in: (self in: super new at: 1 put: t) at: 2 put: 1
!
top: t bottom: b  | r |
	b = 0 ifTrue: [ ^ self error: ' division by zero in fraction'].
	r := t gcd: b.
	^ self in: (self in: super new at: 1 put: (t quo: r)) at: 2 put: (b quo: r)
!
METHODS
* arg
	^ arg multByFraction: self
!
+ arg
	^ arg addToFraction: self
!
- arg
	^ arg subtractFromFraction: self
!
/ arg
	^ arg divideByFraction: self
!
addToFraction: arg
	^ Fraction top: top * arg bottom + (bottom * arg top) bottom: bottom * arg bottom
!
addToSmallInt: arg
	^ (Fraction top: arg) + self
!
asFloat
	^ top asFloat / bottom asFloat
!
bottom
	^ bottom
!
divideByFraction: arg
	^ Fraction top: arg top * bottom bottom: arg bottom * top
!
divideBySmallInt: arg
	^ (Fraction top: arg) / self
!
multByFraction: arg
	^ Fraction top: top * arg top bottom: bottom * arg bottom
!
multBySmallInt: arg
	^ (Fraction top: arg) * self
!
printString
	^ '(' + top printString + '/' + bottom printString + ')'
!
subtractFromFraction: arg
	^ Fraction top: arg top * bottom - (top * arg bottom) bottom: bottom * arg bottom
!
subtractFromSmallInt: arg
	^ (Fraction top: arg) - self
!
top
	^ top
!
