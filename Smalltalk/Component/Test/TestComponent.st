CLASS TestCase subclass: 'TestComponent' variables: '' classVariables: ''
	"Unit tests for Component, the abstract base class of the Swing component wrappers.
	 It is tested through its subclass Panel. Java properties without a Smalltalk getter are read with the FFI.
	 Run with: TestComponent run"
METHODS
testAdd
	| panel |
	panel := Panel new.
	panel add: Label new.
	panel add: Label new constraints: BorderLayout north.
	"Adding nil is ignored."
	panel add: nil.
	self assert: < 38 SmallInt panel 'getComponentCount' > = 2.
!
testBackground
	| panel |
	panel := Panel new.
	panel background: Color red.
	self assert: < 38 SmallInt ( < 38 JavaObject panel 'getBackground' > ) 'getRed' > = 255.
!
testBorder
	| panel |
	panel := Panel new.
	panel border: ( Border createTitledBorder: 'Title' ).
	self assert: < 38 JavaObject panel 'getBorder' > notNil.
!
testFont
	| panel |
	panel := Panel new.
	panel font: ( Font name: 'Dialog' style: 1 size: 20 ).
	self assert: ( panel font isKindOf: Font ).
	self assert: < 38 SmallInt ( panel font ) 'getSize' > = 20.
!
testRepaintRequestFocus
	| panel |
	panel := Panel new.
	panel repaint.
	panel requestFocus.
	self assert: true.
!
