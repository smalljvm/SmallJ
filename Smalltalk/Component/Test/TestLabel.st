CLASS TestCase subclass: 'TestLabel' variables: '' classVariables: ''
	"Unit tests for Label.
	 Run with: TestLabel run"
METHODS
testAlignment
	| label |
	label := Label new.
	label horizontalAlignment: 4.
	label verticalAlignment: 3.
	self assert: < 38 SmallInt label 'getHorizontalAlignment' > = 4.
	self assert: < 38 SmallInt label 'getVerticalAlignment' > = 3.
!
testImage
	| label |
	label := Label new.
	label image: ( Image size: 5 @ 5 ).
	self assert: < 38 JavaObject label 'getIcon' > notNil.
	"Images are aligned left and top."
	self assert: < 38 SmallInt label 'getHorizontalAlignment' > = 2.
!
testText
	| label |
	label := Label new text: 'Name'.
	self assert: < 38 String label 'getText' > = 'Name'.
!
