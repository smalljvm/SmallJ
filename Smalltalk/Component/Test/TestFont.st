CLASS TestCase subclass: 'TestFont' variables: '' classVariables: ''
	"Unit tests for Font.
	 Run with: TestFont run"
METHODS
testNameStyleSize
	| font |
	font := Font name: 'Dialog' style: 0 size: 14.
	self assert: ( font isKindOf: Font ).
	self assert: < 38 SmallInt font 'getSize' > = 14.
	self assert: < 38 Boolean font 'isPlain' >.
!
testStyle
	| font bold |
	font := Font name: 'Dialog' style: 0 size: 14.
	bold := font style: 1.
	self assert: < 38 Boolean bold 'isBold' >.
	"Fonts are immutable, style: returns a new font."
	self assert: < 38 Boolean font 'isBold' > not.
!
