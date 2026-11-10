CLASS Component subclass: 'Label' variables: '' classVariables: ''
	"Implements javax.swing.JLabel."
CLASSMETHODS
new
	"JLabel()"
	^ < 37 self 'javax.swing.JLabel'>.
!
METHODS
text: text
	"void setText( String text )"
	< 38 nil self 'setText' text >.
!
image: image
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
horizontalAlignment: alignment
	"void setHorizontalAlignment( int alignment )
	 alignment: 0 = center, 1 = top, 2 = left, 3 = bottom, 4 = right."
	< 38 nil self 'setHorizontalAlignment' alignment >.
!
verticalAlignment: alignment
	"void setVerticalAlignment( int alignment )
	 alignment: 0 = center, 1 = top, 2 = left, 3 = bottom, 4 = right."
	< 38 nil self 'setVerticalAlignment' alignment >.
!
