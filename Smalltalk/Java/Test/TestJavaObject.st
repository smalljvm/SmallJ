CLASS TestCase subclass: 'TestJavaObject' variables: '' classVariables: ''
	"Unit tests for JavaObject and the Java FFI primitives it is used with.
	 Run with: TestJavaObject run"
METHODS
testConversions
	"Basic Java types are converted to Smalltalk objects."
	self assert: < 39 SmallInt 'java.lang.Math' 'max' 3 7 > = 7.
	self assert: < 39 Boolean 'java.lang.Boolean' 'parseBoolean' 'true' > == true.
	self assert: < 39 String 'java.lang.String' 'valueOf' 12 > = '12'.
	self assert: < 39 Float 'java.lang.Math' 'abs' -1.5 > = 1.5.
	self assert: < 39 JavaObject 'java.lang.System' 'getenv' 'NoSuchEnvironmentVariableForSmallJ' > isNil.
!
testInvokeMethod
	| builder |
	builder := < 37 JavaObject 'java.lang.StringBuilder' 'ab' >.
	self assert: ( builder isKindOf: JavaObject ).
	< 38 nil builder 'append' 'cd' >.
	self assert: < 38 String builder 'toString' > = 'abcd'.
	self assert: < 38 SmallInt builder 'length' > = 4.
!
testReadField
	self assert: < 41 SmallInt 'java.lang.Integer' 'MAX_VALUE' > = 2147483647.
!
