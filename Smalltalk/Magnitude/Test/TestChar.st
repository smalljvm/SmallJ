CLASS TestCase subclass: 'TestChar' variables: '' classVariables: ''
	"Unit tests for Char.
	 Run with: TestChar run"
METHODS
testAsString
	self assert: $a asString = 'a'.
	self assert: $a printString = '$a'.
!
testCase
	self assert: $A lowerCase = $a.
	self assert: $a lowerCase = $a.
	self assert: $a upperCase = $A.
	self assert: $1 upperCase = $1.
!
testClassification
	self assert: $a isLowerCase.
	self assert: $A isUpperCase.
	self assert: $a isAlphabetic.
	self assert: $1 isDigit.
	self assert: $1 isAlphanumeric.
	self assert: $- isAlphanumeric not.
	self assert: $  isBlank.
	self assert: Char tab isBlank.
	self assert: $a isBlank not.
!
testComparing
	self assert: $a = $a.
	self assert: $a < $b.
	self assert: ( $b < $a ) not.
!
testValue
	self assert: $a value = 97.
	self assert: ( Char new: 65 ) = $A.
	self assert: Char newline value = 10.
	self assert: Char tab value = 9.
!
