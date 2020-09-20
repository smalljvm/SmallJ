CLASS Magnitude subclass: 'Point' variables: 'x y' classVariables: ''
META x: x y: y
	^ self new x: x y: y.
!
METHOD + aPoint
	^ ( x + aPoint x ) @ ( y + aPoint y ).
!
METHOD printString
	^ x printString + ' @ ' + y printString.
!
METHOD x
	^ x.
!
METHOD x: aX
  x := aX
!
METHOD x: aX y: aY
	x := aX.
	y := aY.
!
METHOD y
	^ y.
!
METHOD y: aY
   y := aY.
!
