CLASS Object subclass: 'Method' variables: 'name byteCodes literals stackSize temporarySize class lineNum' classVariables: ''
META name: aName byteCodes: aByteCodes literals: aLiterals stackSize: aStackSize temporarySize: aTemporarySize class: aClass
	| newMethod |
	newMethod := self new.
	super in: newMethod at: 1 put: aName.
	super in: newMethod at: 2 put: aByteCodes.
	super in: newMethod at: 3 put: aLiterals.
	super in: newMethod at: 4 put: ( aStackSize max: 20 ).	"To support primitives with upto 20 args."
	super in: newMethod at: 5 put: aTemporarySize.
	super in: newMethod at: 6 put: aClass.
	^ newMethod
!
METHOD name
	^ name
!
METHOD byteCodes
	^ byteCodes
!
METHOD literals
	^ literals
!
METHOD stackSize
	^ stackSize
!
METHOD tempSize
	^ temporarySize
!
METHOD lineNum
	^ lineNum.
!
METHOD lineNum: aLineNum
	lineNum := aLineNum.
!
METHOD printString
	^ name
!
METHOD stackSize
	^ stackSize
!
