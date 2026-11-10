CLASS TestCase subclass: 'TestImageEditor' variables: '' classVariables: ''
	"Unit tests for ImageEditor, without showing its window.
	 Not tested: drawing with the mouse and loadColor, which draw on an Image (see TestImage),
	 and show:, which waits for the window to be closed.
	 Run with: TestImageEditor run"
METHODS
testColorPanel
	| editor colorTextField |
	editor := ImageEditor new.
	self assert: ( editor createColorPanel isKindOf: Panel ).
	colorTextField := self valueOf: 'colorTextField' in: editor.
	self assert: < 38 Boolean colorTextField 'isEditable' > not.
!
testImagePanel
	| editor |
	editor := ImageEditor new.
	self assert: ( editor createImagePanel isKindOf: ScrollPane ).
	self assert: ( ( self valueOf: 'imageLabel' in: editor ) isKindOf: Label ).
!
testMousePressed
	| editor event point |
	editor := ImageEditor new.
	event := < 37 MouseEvent 'java.awt.event.MouseEvent' ( Label new ) 501 ( SmallLong new: 0 ) 0 3 4 1 false >.
	editor onMousePressed: event.
	point := self valueOf: 'prevPoint' in: editor.
	self assert: point x = 3.
	self assert: point y = 4.
!
