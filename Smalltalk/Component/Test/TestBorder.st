CLASS TestCase subclass: 'TestBorder' variables: '' classVariables: ''
	"Unit tests for Border.
	 Run with: TestBorder run"
METHODS
testCreateTitledBorder
	| border |
	border := Border createTitledBorder: 'Title'.
	self assert: ( border isKindOf: Border ).
	self assert: < 38 String border 'getTitle' > = 'Title'.
!
