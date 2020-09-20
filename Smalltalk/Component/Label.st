CLASS Component subclass: 'Label' variables: '' classVariables: ''
	"Implements javax.swing.JLabel."
META new
	"JLabel()"
	^ < 37 self 'javax.swing.JLabel'>.
!
METHOD text: text
	"void setText( String text )"
	< 38 nil self 'setText' text >.
!
METHOD image: image
	"Set image in label using Java Icon."
	| imageIcon |

	"Must create intermediate ImageIcon first.
	 ImageIcon( Image image )"
	imageIcon := < 37 JavaObject 'javax.swing.ImageIcon' image >.
	"void setIcon( Icon icon )"
	< 38 nil self 'setIcon' imageIcon >.

	"Align image top/left so that mouse coordinates for the label are equal to the image coordinates."
	self horizontalAlignment: 2.	"left"
	self verticalAlignment: 1.		"top"
!
METHOD horizontalAlignment: alignment
	"void setHorizontalAlignment( int alignment )
	 alignment: 0 = center, 1 = top, 2 = left, 3 = bottom, 4 = right."
	< 38 nil self 'setHorizontalAlignment' alignment >.
!
METHOD verticalAlignment: alignment
	"void setVerticalAlignment( int alignment )
	 alignment: 0 = center, 1 = top, 2 = left, 3 = bottom, 4 = right."
	< 38 nil self 'setVerticalAlignment' alignment >.
!
