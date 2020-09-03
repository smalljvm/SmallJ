CLASS Integer subclass: 'LargeNegative' variables: 'values' classVariables: ''
META new: value
	^ self in: super new at: 1 put: value.
!
METHOD * arg
	^ ( self negated * arg ) negated.
!
METHOD + arg
	^ arg - self negated.
!
METHOD - arg
	^ ( self negated + arg ) negated.
!
METHOD < arg
	^ ( self negated < arg negated ) not.
!
METHOD = arg
	^ self negated = arg negated.
!
METHOD addToLP: arg
	"Private internal method."
	^ arg - self negated.
!
METHOD asFloat
	^ self negated asFloat negated.
!
METHOD compareToLP: arg
	"We are always smaller than a positive number."
	^ -1.
!
METHOD multByLP: arg
	^ ( self negated multByLP: arg ) negated.
!
METHOD multBySmallInt: arg
	^ ( self negated multBySmallInt: arg ) negated.
!
METHOD negated
	^ LargePositive new: values.
!
METHOD printString
	^ '-' + self negated printString.
!
METHOD subtractFromLP: arg
	"Private internal method."
	^ arg + self negated.
!
