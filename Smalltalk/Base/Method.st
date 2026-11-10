CLASS Object subclass: 'Method' variables: 'name byteCodes literals stackSize temporarySize class lineNum' classVariables: ''
METHODS
name
	^ name
!
byteCodes
	^ byteCodes
!
literals
	^ literals
!
stackSize
	^ stackSize
!
tempSize
	^ temporarySize
!
lineNum
	^ lineNum.
!
lineNum: aLineNum
	lineNum := aLineNum.
!
printString
	^ name
!
stackSize
	^ stackSize
!
