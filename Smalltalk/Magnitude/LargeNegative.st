CLASS Integer subclass: 'LargeNegative' variables: 'values' classVariables: ''
CLASSMETHODS
new: value
	^ self in: super new at: 1 put: value.
!
METHODS
* arg
	^ ( self negated * arg ) negated.
!
+ arg
	^ arg - self negated.
!
- arg
	^ ( self negated + arg ) negated.
!
< arg
	^ ( self negated < arg negated ) not.
!
= arg
	^ self negated = arg negated.
!
addToLP: arg
	"Private internal method."
	^ arg - self negated.
!
asFloat
	^ self negated asFloat negated.
!
compareToLP: arg
	"We are always smaller than a positive number."
	^ -1.
!
multByLP: arg
	^ ( self negated multByLP: arg ) negated.
!
multBySmallInt: arg
	^ ( self negated multBySmallInt: arg ) negated.
!
negated
	^ LargePositive new: values.
!
printString
	^ '-' + self negated printString.
!
subtractFromLP: arg
	"Private internal method."
	^ arg + self negated.
!
