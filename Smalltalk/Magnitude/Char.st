CLASS Magnitude subclass: 'Char' variables: 'value' classVariables: ''
META new: v
	"Create and initialize a new char."
	^ Object in: super new initialize: 'value' with: v
!
META newline
	"Return newline character."
	^ self new: 10
!
META tab
	"Return tab character."
	^ self new: 9.
!
METHOD < aChar
	^ value < aChar value
!
METHOD = aChar
	^ value = aChar value
!
METHOD asString
	| r |
	"Return char as a string value."
	r <- String new: 1.
	r at: 1 put: self.
	^ r
!
METHOD isAlphabetic
	^ self isLowerCase or: [ self isUpperCase ]
!
METHOD isAlphanumeric
	"Are we a letter or a digit?"
	^ self isAlphabetic or: [ self isDigit ]
!
METHOD isBlank
	"Spaces, tabs and newlines are considered blank."
	^ value = 32 or: [ value = 9 or: [ value = 10 ] ]
!
METHOD isDigit
	^ self between: $0 and: $9
!
METHOD isLowerCase
	^ self between: $a and: $z
!
METHOD isUpperCase
	^ self between: $A and: $Z
!
METHOD lowerCase
	self isUpperCase
		ifTrue: [ ^ Char new: (value - 65) + 97 ]
!
METHOD printString
	| r |
	r <- String new: 2.
	r at: 1 put: $$.
	r at: 2 put: self.
	^ r
!
METHOD upperCase
	self isLowerCase ifTrue: [
		^ Char new: (value - 97) + 65 ].
!
METHOD value
  "Return our ascii value as an integer."
  ^ value
!
