CLASS TestCase subclass: 'TestByteArray' variables: '' classVariables: ''
	"Unit tests for ByteArray.
	 Run with: TestByteArray run"
METHODS
testAtPut
	| bytes |
	bytes := ByteArray new: 2.
	self assert: bytes size = 2.
	self assert: ( bytes at: 1 ) = 0.
	bytes at: 1 put: 255.
	self assert: ( bytes at: 1 ) = 255.
	self assert: ( bytes at: 3 ifAbsent: [ nil ] ) isNil.
!
testAsByteArray
	| bytes |
	bytes := #( 1 2 3 ) asByteArray.
	self assert: ( bytes isKindOf: ByteArray ).
	self assert: bytes last = 3.
!
testAsCode
	| bytes |
	bytes := ByteArray new: 1.
	bytes at: 1 put: 18.
	self assert: bytes asCode = '( 1:2 )'.
!
