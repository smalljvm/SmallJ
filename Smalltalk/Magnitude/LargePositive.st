CLASS Integer subclass: 'LargePositive' variables: 'values' classVariables: ''
META new: v
   ^ self in: super new at: 1 put: v.
!
METHOD * arg
	^ arg multByLP: self.
!
METHOD + arg
	^ arg addToLP: self.
!
METHOD - arg
	^ self < arg
		ifTrue: [ ( arg - self ) negated ]
		ifFalse: [ arg subtractFromLP: self ].
!
METHOD < arg
	^ 0 < (arg compareToLP: self)
!
METHOD = arg
	^ 0 = (arg compareToLP: self)
!
METHOD addToLP: arg
	| carry nv newValue |
	carry := 0.
	newValue := List new.
	values with: arg values pad: 0 do: [ :lv :rv |
		nv := lv + rv + carry.
		carry := nv quo: 100.
		newValue add: (nv rem: 100) ].
	( carry = 0 ) ifFalse: [ newValue add: carry ].
	^ LargePositive new: newValue asByteArray.
!
METHOD asFloat
	| r |
	r := 0 asFloat.
	values reverseDo: [ :e | r := r * 100 + e ].
	^ r.
!
METHOD compareToLP: arg
	| r |
	r := 0.
	values with: arg values pad: 0 do: [ :lv :rv |
		( lv = rv ) ifFalse:
			[ r := ( lv < rv ) ifTrue: [ -1 ] ifFalse: [ 1 ] ] ].
	^ r.
!
METHOD multByLP: arg
	| r a b c|
	r := List new.
	values reverseDo: [ :e |
		r := ( ( LargePositive new: ( r addFirst: 0 ) ) + ( arg * e ) ) values asList ].
	^ LargePositive new: r asByteArray
!
METHOD multBySmallInt: arg
	| carry newValue |
	" private internal method "
	arg < 0 ifTrue: [ ^ (self multBySmallInt: arg negated) negated ].
	carry := 0. newValue := List new.
	values do: [:e | carry := e * arg + carry.
		newValue add: (carry rem: 100). carry := carry quo: 100 ].
	[ carry > 0 ] whileTrue: [ newValue add: (carry rem: 100). carry := carry quo: 100 ].
	^ LargePositive new: newValue asByteArray
!
METHOD negated
	^ LargeNegative new: values
!
METHOD printString
	^ values inject: '' into: [ :r :e |
		( '00' + e printString last: 2 ) + r ].
!
METHOD subtractFromLP: arg
	| borrow newValue |
	" private internal method,  know we are smaller than arg "
	borrow := 0. newValue := List new.
	arg values with: values pad: 0 do: [ :lv :rv |
		lv := lv - borrow.
		( lv < rv ) ifTrue: [ lv := lv + 100. borrow := 1 ] ifFalse: [ borrow := 0 ].
		newValue add: (lv - rv) ].
	^ LargePositive new: newValue asByteArray

!
METHOD values
	^ values
!
