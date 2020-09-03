3.14159256            
$
$'
					  :
EVAL Class addNewClass: ( Object subclass: 'ColorEditor' variables: 'color frame framePanel image imagePanel text textPanel scrollBarsPanel redScrollBar greenScrollBar blueScrollBar selectButton semaphore' classVariables: '')
META Color
edit: color
	^ self new edit: color
METHOD ColorEditor
edit: aColor
	| scrollBarChangedBlock |
	"Display color selection window on argument. Answer selected new color."

	color <- aColor.
	semaphore <- Semaphore new.

	textPanel <- TextField new.
	textPanel setText: color printString.
		
	image <- Image size: 200 @ 200.
	image setColor: color.
	image at: 0 @ 0 fillRect: 200 @ 200.
	imagePanel <- Label image: image.

	scrollBarChangedBlock <- [ :unused | self scrollBarChanged ].
	"ScrollBar max must also have room for the extent: 255 + 10. 
	 Otherwise scrollBar creation will fail in Java when the value is at max."
	redScrollBar <- ScrollBar orientation: 1 value: color red extent: 10 min: 0 max: 265. 
	redScrollBar onAdjust: scrollBarChangedBlock.
	greenScrollBar <-  ScrollBar orientation: 1 value: color green extent: 10 min: 0 max: 265.
	greenScrollBar onAdjust: scrollBarChangedBlock.
	blueScrollBar <-  ScrollBar orientation: 1 value: color blue extent: 10 min: 0 max: 265.
	blueScrollBar onAdjust: scrollBarChangedBlock.
	scrollBarsPanel <- ( GridPanel rows: 1 columns: 3 ) addAll: #( redScrollBar greenScrollBar blueScrollBar ).

	selectButton <- Button text: 'Select' action: [ self select ].

	framePanel <- BorderPanel new north: textPanel south: selectButton east: nil west: scrollBarsPanel center: imagePanel.
	frame <- Frame new title: 'Color Editor'.
	frame setSize: 300 @ 250.
	frame add: framePanel.
  	frame show.

	^ semaphore wait.
!
METHOD Color
scrollBarChanged
	color <- Color red: redScrollBar getValue green: greenScrollBar getValue blue: blueScrollBar getValue.
	image setColor: color.
	image at: 0 @ 0 fillRect: 200 @ 200.
	textPanel setText: color printString.
	frame repaint.
!
METHOD Color
select
	"Close frame and return selected color via semaphore."
	frame close.
	semaphore set: color. 
!
