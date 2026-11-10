CLASS Magnitude subclass: 'Char' variables: 'value' classVariables: ''
CLASSMETHODS
new: v
	"Create and initialize a new char."
	^ Object in: super new initialize: 'value' with: v
!
newline
	"Return newline character."
	^ self new: 10
!
tab
	"Return tab character."
	^ self new: 9.
!
METHODS
< aChar
	^ value < aChar value
!
= aChar
	^ value = aChar value
!
asString
	| r |
	"Return char as a string value."
	r := String new: 1.
	r at: 1 put: self.
	^ r
!
isAlphabetic
	^ self isLowerCase or: [ self isUpperCase ]
!
isAlphanumeric
	"Are we a letter or a digit?"
	^ self isAlphabetic or: [ self isDigit ]
!
isBlank
	"Spaces, tabs and newlines are considered blank."
	^ value = 32 or: [ value = 9 or: [ value = 10 ] ]
!
isDigit
	^ self between: $0 and: $9
!
isLowerCase
	^ self between: $a and: $z
!
isUpperCase
	^ self between: $A and: $Z
!
lowerCase
	self isUpperCase
		ifTrue: [ ^ Char new: (value - 65) + 97 ]
!
printString
	| r |
	r := String new: 2.
	r at: 1 put: $$.
	r at: 2 put: self.
	^ r
!
upperCase
	self isLowerCase ifTrue: [
		^ Char new: (value - 97) + 65 ].
!
value
  "Return our ascii value as an integer."
  ^ value
!
