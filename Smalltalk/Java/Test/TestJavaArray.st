CLASS TestCase subclass: 'TestJavaArray' variables: '' classVariables: ''
	"Unit tests for JavaArray, the conversion between Smalltalk collections and Java arrays.
	 Run with: TestJavaArray run"
METHODS
testFrom
	| javaArray |
	javaArray := JavaArray from: #( 1 2 3 ).
	self assert: ( JavaArray sizeOf: javaArray ) = 3.
	self assert: ( JavaArray in: javaArray at: 0 class: SmallInt ) = 1.
	self assert: ( JavaArray in: javaArray at: 2 class: SmallInt ) = 3.
!
testFromType
	| javaArray |
	javaArray := JavaArray from: #( 'a' 'b' ) type: 'java.lang.String'.
	self assert: ( JavaArray sizeOf: javaArray ) = 2.
	self assert: ( JavaArray in: javaArray at: 1 class: String ) = 'b'.
!
testToArray
	| array |
	array := JavaArray toArray: ( JavaArray from: #( 1 2 3 ) ) class: SmallInt.
	self assert: ( array isKindOf: Array ).
	self assert: array printString = #( 1 2 3 ) printString.
	self assert: ( JavaArray toArray: nil class: SmallInt ) isEmpty.
!
