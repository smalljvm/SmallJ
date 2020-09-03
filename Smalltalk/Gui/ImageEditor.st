CLASS Object subclass: 'ImageEditor' variables: 'image color semaphore frame colorTextField imageLabel prevPoint' classVariables: ''
	"Editor for Image objects."
META show: aImage
	^ self new show: aImage.
!
METHOD show: aImage
	image <- aImage.
	color <- Color black.
	semaphore <- Semaphore new.

	self createFrame.
	self loadImage.
	self loadColor.
	frame pack show.

	^ semaphore wait.
!
METHOD createFrame
	| closeButton framePanel |

	closeButton <- Button new text: 'Close' action: [ :actionEvent | self onClose ].

	framePanel <- Panel new layout: ( BorderLayout gap: 0 @ 4 ).
	framePanel border: ( BorderLayout emptyBorder: ( Insets top: 4 left: 4 bottom: 4 right: 4 ) ).
	framePanel add: self createColorPanel constraints: BorderLayout north.
	framePanel add: self createImagePanel constraints: BorderLayout center.
	framePanel add: closeButton constraints: BorderLayout south.

	frame <- Frame new.
	frame title: 'Image Editor'.
	frame add: framePanel.
!
METHOD createColorPanel
	| colorButton colorPanel |

	colorButton <- Button new text: 'Color' action: [ :actionEvent | self onColor ].

	colorTextField <- TextField new.
	colorTextField editable: false.
	colorTextField background: ( Color red: 250 green: 250 blue: 250 ).

	colorPanel <- Panel new layout: ( BorderLayout gap: 4 @ 0 ).
	colorPanel add: colorButton constraints: BorderLayout west.
	colorPanel add: colorTextField constraints: BorderLayout center.
	^ colorPanel.
!
METHOD createImagePanel
	"In Java, an image in a frame is displayed as an image icon in a label component."
	imageLabel <- Label new.
	imageLabel onMousePressed: [ :mouseEvent | self onMousePressed: mouseEvent ].
	imageLabel onMouseReleased: [ :mouseEvent | self onMouseReleased: mouseEvent ].
	imageLabel onMouseMoved: [ :mouseEvent | self onMouseMoved: mouseEvent ].
	^ ScrollPane view: imageLabel.
!
METHOD loadColor
	colorTextField text: color printString.
	image setColor: color.
!
METHOD loadImage
	imageLabel image: image.
!
METHOD onColor
	color <- ColorEditor show: color.
	self loadColor.
!
METHOD onMousePressed: mouseEvent
	prevPoint <- mouseEvent x @ mouseEvent y.
!
METHOD onMouseReleased: mouseEvent
	prevPoint <- nil.
!
METHOD onMouseMoved: mouseEvent
	| newPoint |
	prevPoint ifNotNil: [
		newPoint <- mouseEvent x @ mouseEvent y.
		image at: prevPoint drawLine: newPoint.
		prevPoint <- newPoint.
		frame repaint ].
!
METHOD onClose
	semaphore set: self.
	frame close.
!
