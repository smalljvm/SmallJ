CLASS TestCase subclass: 'TestImage' variables: '' classVariables: ''
	"Unit tests for Image.
	 Not tested: drawing (setColor:, at:fillRect: etc.). It currently fails on Java 9 and later,
	 because the FFI looks up the method on the internal class sun.java2d.SunGraphics2D, which is not exported.
	 Run with: TestImage run"
METHODS
testFromFile
	| image |
	image := Image fromFile: 'smallj.png'.
	self assert: ( image isKindOf: Image ).
	self assert: < 38 SmallInt image 'getWidth' > > 0.
!
testGraphics
	| image |
	image := Image size: 10 @ 10.
	"The graphics object is created once."
	self assert: image graphics notNil.
	self assert: image graphics == image graphics.
!
testSize
	| image |
	image := Image size: 10 @ 20.
	self assert: < 38 SmallInt image 'getWidth' > = 10.
	self assert: < 38 SmallInt image 'getHeight' > = 20.
!
