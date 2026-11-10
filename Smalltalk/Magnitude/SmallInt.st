CLASS Integer subclass: 'SmallInt' variables: '' classVariables: ''
CLASSMETHODS
new
	"Can't create this way, return zero."
	^ 0.
!
METHODS
* arg
	^ arg multBySmallInt: self.
!
+ arg
	^ arg addToSmallInt: self.
!
- arg
	^ arg subtractFromSmallInt: self.
!
< arg
	^ arg lessThanSmallInt: self.
!
= arg
	^ arg equalToSmallInt: self.
!
addToLP: arg
    ^ arg + self asLargeInteger.
!
addToSmallInt: arg
	"This only gets invoked when overflow occurs."
	^ arg asLargeInteger + self asLargeInteger.
!
asFloat
	^ Float fromSmallInt: self.
!
asLargeInteger
	| newValue n |
	newValue := List new.
	n := self abs.
	[n > 0] whileTrue: [ newValue add: (n rem: 100). n := n quo: 100].
	newValue size = 0 ifTrue: [ newValue add: 0].
	^ self < 0 ifTrue: [ LargeNegative new: newValue asByteArray]
		ifFalse: [ LargePositive new: newValue asByteArray ].
!
compareToLP: arg
	^ self asLargeInteger compareToLP: arg.
!
equalToSmallInt: arg
	^ < 14 self arg >.
!
lessThanSmallInt: arg
	^ < 13 arg self >.
!
multByLP: arg
	^ self * arg.
!
multBySmallInt: arg
	| result |
   "must check for overflow "
   result := < 15 arg self >.
   result isNil ifTrue: [
	   result := arg asLargeInteger * self asLargeInteger ].
   ^ result.
!
printString
	( self < 0 ) ifTrue: [ ^ '-' + self negated printString ].
	( self < 10 ) ifTrue: [ ^ ( Char new: ( self + 48 ) ) asString ].
	^ ( self quo: 10 ) printString + ( self rem: 10 ) printString.
!
quo: arg
	(0 = arg) ifTrue: [ ^ self error: 'division by zero' ].
	^ arg quoWithSmallInt: self

!
quoWithSmallInt: arg
	^ <11 arg self>
!
rem: arg
	( 0 = arg ) ifTrue: [ ^ self error: 'division by zero' ].
	^ arg remWithSmallInt: self
!
remWithSmallInt: arg
	^ <12 arg self>
!
subtractFromLP: arg
	" private internal method "
	^ arg - self asLargeInteger
!
subtractFromSmallInt: arg
	| r |
	r := < 16 arg self >.
	"Check for overflow."
	r isNil ifTrue: [
		r := arg asLargeInteger - self asLargeInteger ].
	^ r.
!
timesRepeat: aBlock
	| times |
	times := self.
	[ times > 0 ] whileTrue: [
		aBlock value.
		times := times - 1 ].
!
to: limit
	^ Interval from: self to: limit by: 1
!
to: limit by: step
	^ Interval from: self to: limit by: step
!
to: limit do: aBlock
	"Value aBlock repeatedly with integers in range from self upto limit.
	 Is optimized case of Interval."
	| i |
	i := self.
	[ i <= limit ] whileTrue: [
		aBlock value: i.
		i := i + 1 ].
!
