CLASS Object subclass: 'Encoder' variables: 'name byteCodes literals stackSize maxStack' classVariables: ''
METHOD backUp
	"Back up one instruction."
	byteCodes removeAt: byteCodes size
!
METHOD currentLocation
	^ byteCodes size
!
METHOD genCode: byte
	byteCodes add: byte.
	^ byteCodes size
!
METHOD genHigh: high low: low
	( low >= 16 )
		ifTrue: [ self genHigh: 0 low: high. self genCode: low ]
		ifFalse: [ self genCode: high * 16 + low ]
!
METHOD genLiteral: aValue
	literals <- literals add: aValue.
	^ literals size - 1
!
METHOD method: maxTemps class: c
	"Stack size doesn't take into account primitives."
	^ Method name: name byteCodes: byteCodes asByteArray literals: literals
		stackSize: maxStack + 5 temporarySize: maxTemps class: c.
!
METHOD name: n
	name <- n.
	byteCodes <- List new.
	literals <- Array new: 0.
	stackSize <- 0.
	maxStack <- 1.
!
METHOD patch: loc
	"Patch a goto from a block."
	byteCodes at: loc put: self currentLocation
!
METHOD popArgs: n
	stackSize <- stackSize - n.
!
METHOD pushArgs: n
	stackSize <- stackSize + n.
	maxStack <- stackSize max: maxStack
!
