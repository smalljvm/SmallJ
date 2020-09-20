CLASS Component subclass: 'Image' variables: 'graphics' classVariables: ''
	"Implements java.awt.image.BufferedImage.
	 Also encapsulates java.awt.Graphics2D for manipulating the image."
META size: aSize
    "Initialize blank image with argument size."
	| width height |
	width := aSize x.
	height := aSize y.
	"BufferedImage( int width, int height, int imageType )
	 imageType: 1 = TYPE_INT_RGB, see others in Java documentation for ColorSpace."
	^ < 37 Image 'java.awt.image.BufferedImage' width height 1 >.
!
META fromFile: aFileName
	| fileInputStream |
	"public FileInputStream( String name )"
	fileInputStream := < 37 File 'java.io.FileInputStream' aFileName >.
	"public static BufferedImage read( InputStream input )"
	^ < 39 Image 'javax.imageio.ImageIO' 'read' fileInputStream >.
!
METHOD graphics
	"Private - Return graphics member for image manipulation.
	 Create and remember it if it was not set yet."
	 graphics ifNil: [
		graphics := < 38 JavaObject self 'createGraphics' > ].
	^ graphics.
!
METHOD at: loc drawLine: to
	< 38 nil ( self graphics ) 'drawLine' ( loc x ) ( loc y ) ( to x ) ( to y ) >.
!
METHOD at: loc drawOval: size
	< 38 nil ( self graphics ) 'drawOval' ( loc x ) ( loc y ) ( size x ) ( size y ) >.
!
METHOD at: loc drawRect: size
	< 38 nil ( self graphics ) 'drawRect' ( loc x ) ( loc y ) ( size x ) ( size y ) >.
!
METHOD at: loc fillOval: size
	< 38 nil ( self graphics ) 'fillOval' ( loc x ) ( loc y ) ( size x ) ( size y ) >.
!
METHOD at: loc fillRect: size
	< 38 nil ( self graphics ) 'fillRect' ( loc x ) ( loc y ) ( size x ) ( size y ) >.
!
METHOD at: loc text: text
	< 38 nil ( self graphics ) 'drawString' text ( loc x ) ( loc y ) >.
!
METHOD setColor: color
	< 38 nil ( self graphics ) 'setColor' color >.
!
