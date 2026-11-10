CLASS TestCase subclass: 'TestSystem' variables: '' classVariables: ''
	"Unit tests for System.
	 Not tested: exit: and saveImage, which stop SmallJ or overwrite the image.
	 Run with: TestSystem run"
METHODS
testCurrentDirectoryName
	"SmallJ runs in the Smalltalk folder."
	self assert: ( System currentDirectoryName last: 9 ) = 'Smalltalk'.
!
testImageFileName
	self assert: ( System imageFileName isKindOf: String ).
	self assert: System imageFileName isEmpty not.
!
testSleep
	System sleep: 1.
	self assert: true.
!
testStreams
	self assert: ( System out isKindOf: PrintStream ).
	self assert: ( System err isKindOf: PrintStream ).
	self assert: System in notNil.
!
