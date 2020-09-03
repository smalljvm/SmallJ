CLASS Number subclass: 'Integer' variables: '' classVariables: ''
METHOD / arg
	^ arg divideByInteger: self
!
METHOD @ y
  ^ Point x: self y: y
!
METHOD addToFraction: arg
	^ arg + (Fraction top: self)
!
METHOD addToSmallInt: arg
	" private internal method "
	^ arg asLargeInteger + self
!
METHOD asHex
	"Return hexadecimal sting version of self.
	 Negative numbers give zero."
	| hex |
	hex <- ''
	^ self
!
METHOD asInteger
  ^ self
!
METHOD divideByFraction: arg
	^ arg / (Fraction top: self)
!
METHOD divideByInteger: arg
	^ Fraction top: arg bottom: self
!
METHOD equalToSmallInt: arg
	^ arg asLargeInteger = self
!
METHOD gcd: x  | n  m |
	" euclids gcd algorithm "
	n <- self. m <- x.
	(n <= 0 or: [m <= 0]) ifTrue: [ ^ 1].
	[ n = m ] whileFalse: [ n < m ifTrue: [ m <- m - n ] ifFalse: [ n <- n - m ]].
	^ n
!
METHOD lessThanSmallInt: arg
	" private internal method "
	^ arg asLargeInteger < self
!
METHOD multByFraction: arg
	^ arg * ( Fraction top: self )
!
METHOD random
  ^ ( Float random * self ) asInteger
!
METHOD subtractFromFraction: arg
	^ arg - (Fraction top: self)
!
METHOD subtractFromSmallInt: arg
	" private method, used internally "
	^ arg asLargeInteger - self
!
