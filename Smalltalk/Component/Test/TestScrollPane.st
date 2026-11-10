CLASS TestCase subclass: 'TestScrollPane' variables: '' classVariables: ''
	"Unit tests for ScrollPane.
	 Run with: TestScrollPane run"
METHODS
testView
	| label scrollPane view |
	label := Label new text: 'Text'.
	scrollPane := ScrollPane view: label.
	view := < 38 JavaObject ( scrollPane viewport ) 'getView' >.
	self assert: < 38 Boolean view 'equals' label >.
!
testScrollBarViewport
	| scrollPane |
	scrollPane := ScrollPane view: Label new.
	self assert: ( scrollPane verticalScrollBar isKindOf: ScrollBar ).
	self assert: ( scrollPane viewport isKindOf: Viewport ).
!
