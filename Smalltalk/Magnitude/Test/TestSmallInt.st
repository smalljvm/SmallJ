CLASS TestCase subclass: 'TestSmallInt' variables: '' classVariables: ''
	"Unit tests for SmallInt, the 32 bit integers.
	 Run with: TestSmallInt run"
METHODS
testArithmetic
	self assert: 3 + 4 = 7.
	self assert: 3 - 4 = -1.
	self assert: 3 * 4 = 12.
!
testComparing
	self assert: 3 < 4.
	self assert: ( 4 < 3 ) not.
	self assert: 3 = 3.
	self assert: ( 3 = 4 ) not.
!
testNew
	self assert: SmallInt new = 0.
!
testOverflow
	"Results that do not fit in 32 bits become large integers."
	| big |
	big := 100000 * 100000.
	self assert: ( big isKindOf: LargePositive ).
	self assert: big printString = '10000000000'.
	self assert: ( -100000 * 100000 ) printString = '-10000000000'.
!
testPrintString
	self assert: 0 printString = '0'.
	self assert: 123 printString = '123'.
	self assert: -45 printString = '-45'.
!
testQuoRem
	self assert: ( 7 quo: 2 ) = 3.
	self assert: ( 7 rem: 2 ) = 1.
	"Truncated towards zero, like Java."
	self assert: ( -7 quo: 2 ) = -3.
	self assert: ( -7 rem: 2 ) = -1.
!
testTimesRepeat
	| count |
	count := 0.
	3 timesRepeat: [ count := count + 1 ].
	self assert: count = 3.
!
testToDo
	| sum |
	sum := 0.
	1 to: 4 do: [ :each | sum := sum + each ].
	self assert: sum = 10.
	sum := 0.
	( 1 to: 9 by: 4 ) do: [ :each | sum := sum + each ].
	self assert: sum = 15.
!
