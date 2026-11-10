CLASS JavaObject subclass: 'JPoint' variables: '' classVariables: ''
	"Implements java.awt.Point.
	 Note: The @ operator constructs instances of the Point class."
CLASSMETHODS
x: x y: y
	^ < 37 self 'java.awt.Point' x y >.
!
METHODS
printString
	^ self x printString + ' @ ' + self y printString.
!
x
	^ < 40 SmallInt self 'x' >.
!
y
	^ < 40 SmallInt self 'y' >.
!
