CLASS TestCase subclass: 'TestColor' variables: '' classVariables: ''
	"Unit tests for Color.
	 Run with: TestColor run"
METHODS
testAsInteger
	self assert: ( Color red: 1 green: 2 blue: 3 ) asInteger = ( 65536 + 512 + 3 ).
	self assert: Color white asInteger = 16777215.
!
testComponents
	| color |
	color := Color red: 10 green: 20 blue: 30.
	self assert: color red = 10.
	self assert: color green = 20.
	self assert: color blue = 30.
	"The Java color has the same components."
	self assert: < 38 SmallInt color 'getGreen' > = 20.
!
testConstants
	self assert: Color black asInteger = 0.
	self assert: Color red red = 255.
	self assert: Color green green = 255.
	self assert: Color blue blue = 255.
	self assert: Color white red = 255.
!
testPrintString
	self assert: ( Color red: 1 green: 2 blue: 3 ) printString = 'Color [ red: 1, green: 2, blue: 3 ]'.
!
