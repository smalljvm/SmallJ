CLASS Number subclass: 'Integer' variables: '' classVariables: ''
METHODS
/ arg
	^ arg divideByInteger: self
!
@ y
  ^ Point x: self y: y
!
addToFraction: arg
	^ arg + (Fraction top: self)
!
addToSmallInt: arg
	" private internal method "
	^ arg asLargeInteger + self
!
asHex
	"Return hexadecimal string version of self, with upper case digits, like 'FF' for 255.
	 Negative numbers give zero."
	| hexDigits hex remaining |
	self <= 0 ifTrue: [ ^ '0' ].
	hexDigits := '0123456789ABCDEF'.
	hex := ''.
	remaining := self.
	[ remaining > 0 ] whileTrue: [
		hex := ( hexDigits at: ( remaining rem: 16 ) + 1 ) asString + hex.
		remaining := remaining quo: 16 ].
	^ hex.
!
asInteger
  ^ self
!
divideByFraction: arg
	^ arg / (Fraction top: self)
!
divideByInteger: arg
	^ Fraction top: arg bottom: self
!
equalToSmallInt: arg
	^ arg asLargeInteger = self
!
gcd: x  | n  m |
	" euclids gcd algorithm "
	n := self. m := x.
	(n <= 0 or: [m <= 0]) ifTrue: [ ^ 1].
	[ n = m ] whileFalse: [ n < m ifTrue: [ m := m - n ] ifFalse: [ n := n - m ]].
	^ n
!
lessThanSmallInt: arg
	" private internal method "
	^ arg asLargeInteger < self
!
multByFraction: arg
	^ arg * ( Fraction top: self )
!
random
  ^ ( Float random * self ) asInteger
!
subtractFromFraction: arg
	^ arg - (Fraction top: self)
!
subtractFromSmallInt: arg
	" private method, used internally "
	^ arg asLargeInteger - self
!
