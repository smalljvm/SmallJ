CLASS JavaObject subclass: 'Font' variables: '' classVariables: ''
	"Implements java.awt.Font.
	 This class is immutable, so changes return new instances.
	 Font styles: 0 = PLAIN, 1= BOLD, 3 = ITALIC"
CLASSMETHODS
name: aName style: aStyle size: aSize
	"Font( String name, int style, int size )"
	^ < 37 self 'java.awt.Font' aName aStyle aSize >.
!
METHODS
style: style
	"Return copy of font with style set to argument.
	 Font deriveFont( int style )"
	^ < 38 Font self 'deriveFont' style >.
!
