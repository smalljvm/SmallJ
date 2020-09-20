CLASS Collection subclass: 'Indexed' variables: '' classVariables: ''
METHOD at: index
	^ self at: index ifAbsent: [ self error: 'Index out of range.' ]
!
METHOD first
	^ self at: 1.
!
METHOD last
	^ self at: self size.
!
METHOD do: aBlock
	^ 1 to: self size do: [ :index |
		aBlock value: ( self at: index ) ]
!
METHOD includesKey: index
	^ index between: 1 and: self size
!
METHOD indexOf: element ifAbsent: exceptionBlock
	"Return the index of the first occurance of element in self,
	 or exceptionBlock value if not found."
	1 to: self size do: [ :i |
		( element = ( self at: i ) ) ifTrue: [ ^ i ] ].
	^ exceptionBlock value
!
METHOD indexOfLast: element ifAbsent: exceptionBlock
	"Return the index of the *last* occurance of element in self,
	 or exceptionBlock value if not found."
	| index |
	index := self size.
	[ index >= 1 ] whileTrue: [
			( self at: index ) = element ifTrue: [ ^ index ].
			index := index - 1 ].
	^ exceptionBlock value
!
METHOD indexOf: element match: matchBlock ifAbsent: exceptionBlock
	"Return index of the first element for which the matching block returns true.
	 The block should have 2 arguments and is valued with arg1: search element arg2: collection element."
	1 to: self size do: [ :i |
		( matchBlock value: element value: ( self at: i ) ) ifTrue: [ ^ i ] ].
	^ exceptionBlock value
!
METHOD reverseDo: aBlock
	^ ( 1 to: self size ) reverseDo: [ :i |
		aBlock value: ( self at: i ) ].
!
METHOD with: aCollection pad: aValue do: aBlock
	| selfSize argSize |
	selfSize := self size.
	argSize := aCollection size.
	1 to: ( selfSize max: argSize ) do: [ :index |
		aBlock
			value: ( index <= selfSize ifTrue: [ self at: index ] ifFalse: [ aValue ] )
			value: ( index <= argSize  ifTrue: [ aCollection at: index ] ifFalse: [ aValue ] ) ].
!
