CLASS JavaObject subclass: 'Rectangle' variables: '' classVariables: ''
	"Implements java.awt.Rectangle."
CLASSMETHODS
x: x y: y width: width height: height
	^ < 37 self 'java.awt.Rectangle' x y width height >.
!
METHODS
printString
	^ 'Rectangle( loc: ' + self x printString + ' @ ' + self y printString +
		', size: ' + self width printString + ' @ ' + self height printString + ' )'.
!
location
	"Point getLocation()"
	^ < 38 JPoint self 'getLocation' >.
!
x
	^ < 40 SmallInt self 'x' >.
!
y
	^ < 40 SmallInt self 'y' >.
!
width
	^ < 40 SmallInt self 'width' >.
!
height
	^ < 40 SmallInt self 'height' >.
!
