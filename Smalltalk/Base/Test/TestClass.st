CLASS TestCase subclass: 'TestClass' variables: '' classVariables: ''
	"Unit tests for Class.
	 Run with: TestClass run"
METHODS
testAtIfAbsent
	self assert: ( Class at: 'Boolean' ifAbsent: [ nil ] ) == Boolean.
	self assert: ( Class at: 'NoSuchClass' ifAbsent: [ 0 ] ) = 0.
!
testInstanceVariables
	self assert: ( Class instanceVariables includes: 'name' ).
	self assert: ( Class instanceVariables includes: 'methods' ).
	self assert: Object instanceVariables isEmpty.
!
testMethods
	self assert: ( ( Boolean methods collect: [ :method | method name ] ) includes: 'and:' ).
	self assert: ( ( True class methods collect: [ :method | method name ] ) includes: 'new' ).
!
testName
	self assert: Boolean name = 'Boolean'.
	self assert: Boolean printString = 'Boolean'.
!
testNew
	self assert: Object new class == Object.
	self assert: ( Array new: 3 ) size = 3.
!
testSourceFileName
	self assert: Boolean sourceFileName = 'Base/Boolean.st'.
	self assert: Boolean sourceFolderName = 'Base'.
	self assert: TestClass sourceFolderName = 'Base/Test'.
!
testSuperclass
	self assert: True superclass == Boolean.
	self assert: Boolean superclass == Object.
	self assert: Object superclass isNil.
!
testSubclasses
	| subclasses |
	subclasses := Boolean subclasses.
	self assert: subclasses size = 2.
	self assert: ( subclasses includes: True ).
	self assert: ( subclasses includes: False ).
!
