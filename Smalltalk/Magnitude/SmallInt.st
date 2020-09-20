CLASS Integer subclass: 'SmallInt' variables: '' classVariables: ''
META new
	"Can't create this way, return zero."
	^ 0.
!
METHOD * arg
	^ arg multBySmallInt: self.
!
METHOD + arg
	^ arg addToSmallInt: self.
!
METHOD - arg
	^ arg subtractFromSmallInt: self.
!
METHOD < arg
	^ arg lessThanSmallInt: self.
!
METHOD = arg
	^ arg equalToSmallInt: self.
!
METHOD addToLP: arg
    ^ arg + self asLargeInteger.
!
METHOD addToSmallInt: arg
	"This only gets invoked when overflow occurs."
	^ arg asLargeInteger + self asLargeInteger.
!
METHOD asFloat
	^ Float fromSmallInt: self.
!
METHOD asLargeInteger
	| newValue n |
	newValue := List new.
	n := self abs.
	[n > 0] whileTrue: [ newValue add: (n rem: 100). n := n quo: 100].
	newValue size = 0 ifTrue: [ newValue add: 0].
	^ self < 0 ifTrue: [ LargeNegative new: newValue asByteArray]
		ifFalse: [ LargePositive new: newValue asByteArray ].
!
METHOD compareToLP: arg
	^ self asLargeInteger compareToLP: arg.
!
METHOD equalToSmallInt: arg
	^ < 14 self arg >.
!
METHOD lessThanSmallInt: arg
	^ < 13 arg self >.
!
METHOD multByLP: arg
	^ self * arg.
!
METHOD multBySmallInt: arg
	| result |
   "must check for overflow "
   result := < 15 arg self >.
   result isNil ifTrue: [
	   result := arg asLargeInteger * self asLargeInteger ].
   ^ result.
!
METHOD printString
	( self < 0 ) ifTrue: [ ^ '-' + self negated printString ].
	( self < 10 ) ifTrue: [ ^ ( Char new: ( self + 48 ) ) asString ].
	^ ( self quo: 10 ) printString + ( self rem: 10 ) printString.
!
METHOD quo: arg
	(0 = arg) ifTrue: [ ^ self error: 'division by zero' ].
	^ arg quoWithSmallInt: self

!
METHOD quoWithSmallInt: arg
	^ <11 arg self>
!
METHOD rem: arg
	( 0 = arg ) ifTrue: [ ^ self error: 'division by zero' ].
	^ arg remWithSmallInt: self
!
METHOD remWithSmallInt: arg
	^ <12 arg self>
!
METHOD subtractFromLP: arg
	" private internal method "
	^ arg - self asLargeInteger
!
METHOD subtractFromSmallInt: arg
	| r |
	r := < 16 arg self >.
	"Check for overflow."
	r isNil ifTrue: [
		r := arg asLargeInteger - self asLargeInteger ].
	^ r.
!
METHOD timesRepeat: aBlock
	| times |
	times := self.
	[ times > 0 ] whileTrue: [
		aBlock value.
		times := times - 1 ].
!
METHOD to: limit
	^ Interval from: self to: limit by: 1
!
METHOD to: limit by: step
	^ Interval from: self to: limit by: step
!
METHOD to: limit do: aBlock
	"Value aBlock repeatedly with integers in range from self upto limit.
	 Is optimized case of Interval."
	| i |
	i := self.
	[ i <= limit ] whileTrue: [
		aBlock value: i.
		i := i + 1 ].
!
