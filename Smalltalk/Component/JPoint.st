CLASS JavaObject subclass: 'JPoint' variables: '' classVariables: ''
	"Implements java.awt.Point.
	 Note: The @ operator constructs instances of the Point class."
META x: x y: y
	^ < 37 self 'java.awt.Point' x y >.
!
METHOD printString
	^ self x printString + ' @ ' + self y printString.
!
METHOD x
	^ < 40 SmallInt self 'x' >.
!
METHOD y
	^ < 40 SmallInt self 'y' >.
!
