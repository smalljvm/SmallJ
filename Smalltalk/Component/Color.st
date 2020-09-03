CLASS JavaObject subclass: 'Color' variables: 'red green blue' classVariables: ''
	"Implements java.awt.Color.
	 Also maintains red green and blue color components dor speed.
	 Objects of this class are immutable."
META new
	self error: 'Color instances cannot be created with new.'.
!
META red: red green: green blue: blue
	"Color( int red, int green, int blue )"
	^ < 37 Color 'java.awt.Color' red green blue >
		red: red green: green blue: blue.
!
META black
  ^ self red: 0 green: 0 blue: 0.
!
META blue
  ^ self red: 0 green: 0 blue: 255.
!
META green
  ^ self red: 0 green: 255 blue: 0.
!
META red
  ^ self red: 255 green: 0 blue: 0.
!
META white
  ^ self red: 255 green: 255 blue: 255.
!
METHOD red: aRed green: aGreen blue: aBlue
	"Private - Set interal color components.
	 Should only be called in constructor because we are immutable."
	red <- aRed.
	green <- aGreen.
	blue <- aBlue.
!
METHOD asInteger
	"Note: Left to right evaluation order, no operator precedence."
	^ red * 256 + green * 256 + blue.
!
METHOD printString
  ^ 'Color [ red: ' + red + ', green: ' + green + ', blue: ' + blue + ' ]'.
!
METHOD red
	^ red.
!
METHOD green
	^ green.
!
METHOD blue
	^ blue.
!
