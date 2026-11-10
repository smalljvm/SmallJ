CLASS TestCase subclass: 'TestJavaVector' variables: '' classVariables: ''
	"Unit tests for JavaVector, a java.util.Vector.
	 Run with: TestJavaVector run"
METHODS
testAdd
	| vector |
	vector := JavaVector from: #( 1 2 ).
	vector add: 3.
	self assert: < 38 SmallInt vector 'size' > = 3.
	self assert: < 38 SmallInt vector 'get' 2 > = 3.
!
testFrom
	| vector |
	vector := JavaVector from: #( 'a' 'b' ).
	self assert: ( vector isKindOf: JavaVector ).
	self assert: < 38 SmallInt vector 'size' > = 2.
	self assert: < 38 String vector 'get' 0 > = 'a'.
!
