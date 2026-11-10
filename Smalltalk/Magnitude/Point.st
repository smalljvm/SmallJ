CLASS Magnitude subclass: 'Point' variables: 'x y' classVariables: ''
CLASSMETHODS
x: x y: y
	^ self new x: x y: y.
!
METHODS
+ aPoint
	^ ( x + aPoint x ) @ ( y + aPoint y ).
!
printString
	^ x printString + ' @ ' + y printString.
!
x
	^ x.
!
x: aX
  x := aX
!
x: aX y: aY
	x := aX.
	y := aY.
!
y
	^ y.
!
y: aY
   y := aY.
!
