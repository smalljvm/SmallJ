CLASS Object subclass: 'ColorEditor' variables: 'color frame image imageLabel textField scrollBars semaphore' classVariables: ''
META show: aColor
	^ self new show: aColor
!
METHOD show: aColor
	"Display color selection window on argument. Answer selected new color."
	color := aColor.

	semaphore := Semaphore new.
	self createFrame.
	self loadColor.
  	frame show.

	^ semaphore wait.
!
METHOD createFrame
	|  selectButton framePanel |

	textField := TextField new.
	selectButton := Button new text: 'Select' action: [ :actionEvent | self onSelect ].

	framePanel := Panel new layout: BorderLayout new.
	framePanel border: ( BorderLayout emptyBorder: ( Insets top: 4 left: 4 bottom: 4 right: 4 ) ).
	framePanel add: textField constraints: BorderLayout north.
	framePanel add: self createScrollBarsPanel constraints: BorderLayout west.
	framePanel add: self createImageLabel constraints: BorderLayout center.
	framePanel add: selectButton constraints: BorderLayout south.

	frame := Frame new title: 'Color Editor'.
	frame setSize: 300 @ 250.
	frame add: framePanel.
!
METHOD createScrollBarsPanel
	| scrollBarsPanel scrollBar |

	scrollBarsPanel := Panel new layout: ( GridLayout size: 3 @ 1 ).

	scrollBars := List new.
	3 timesRepeat: [
		"ScrollBar max must also have room for the extent: 255 + 10."
		scrollBar := ScrollBar orientation: 1 value: 0 extent: 10 min: 0 max: 265.
		scrollBar onAdjust: [ :adjustmentEvent | self onScrollBarChanged ].
		scrollBars add: scrollBar.
		scrollBarsPanel add: scrollBar ].

	^ scrollBarsPanel.
!
METHOD createImageLabel
	image := Image size: 200 @ 200.
	image setColor: color.
	image at: 0 @ 0 fillRect: 200 @ 200.

	^ imageLabel := Label new image: image.
!
METHOD loadColor
	"Load the current color into the GUI."
	textField text: color printString.

	( scrollBars at: 1 ) value: color red.
	( scrollBars at: 2 ) value: color green.
	( scrollBars at: 3 ) value: color blue.

	image setColor: color.
	image at: 0 @ 0 fillRect: 200 @ 200.

	imageLabel repaint.
!
METHOD onScrollBarChanged
	"Get new color from changed scrollbar values and update GUI."
	color := Color red: ( scrollBars at: 1 ) value green: ( scrollBars at: 2 ) value blue: ( scrollBars at: 3 ) value.
	self loadColor.
!
METHOD onSelect
	"Close frame and return selected color via semaphore."
	frame close.
	semaphore set: color.
!
