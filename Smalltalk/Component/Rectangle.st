CLASS JavaObject subclass: 'Rectangle' variables: '' classVariables: ''
	"Implements java.awt.Rectangle."
META x: x y: y width: width height: height
	^ < 37 self 'java.awt.Rectangle' x y width height >.
!
METHOD printString
	^ 'Rectangle( loc: ' + self x printString + ' @ ' + self y printString +
		', size: ' + self width printString + ' @ ' + self height printString + ' )'.
!
METHOD location
	"Point getLocation()"
	^ < 38 JPoint self 'getLocation' >.
!
METHOD x
	^ < 40 SmallInt self 'x' >.
!
METHOD y
	^ < 40 SmallInt self 'y' >.
!
METHOD width
	^ < 40 SmallInt self 'width' >.
!
METHOD height
	^ < 40 SmallInt self 'height' >.
!
