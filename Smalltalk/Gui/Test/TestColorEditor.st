CLASS TestCase subclass: 'TestColorEditor' variables: '' classVariables: ''
	"Unit tests for ColorEditor, without showing its window.
	 Not tested: the color image and loadColor, which draw on an Image (see TestImage),
	 and show:, which waits for the user to select a color.
	 Run with: TestColorEditor run"
METHODS
testScrollBars
	| editor scrollBars |
	editor := ColorEditor new.
	editor createScrollBarsPanel.
	scrollBars := self valueOf: 'scrollBars' in: editor.
	"One scroll bar for each of red, green and blue."
	self assert: scrollBars size = 3.
	self assert: ( scrollBars first isKindOf: ScrollBar ).
	self assert: scrollBars first maximum = 265.
	self assert: scrollBars first value = 0.
!
