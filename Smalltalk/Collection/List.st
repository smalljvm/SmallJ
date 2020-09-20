CLASS Indexed subclass: 'List' variables: 'values current' classVariables: ''
META new
	^ self in: ( self in: super new at: 1 put: ( Array new: 5 ) ) at: 2 put: 0
!
METHOD add: newElement
	( current = values size ) ifTrue: [ self reallocate ].
	current := current + 1.
	values at: current put: newElement
!
METHOD addFirst: newElement
	self insert: newElement at: 1
!
METHOD at: position ifAbsent: exceptionBlock
	^ ( values includesKey: position )
		ifTrue: [ values at: position ifAbsent: exceptionBlock ]
		ifFalse: [ exceptionBlock value ]
!
METHOD at: position put: newElement
	( values includesKey: position )
		ifTrue: [ values at: position put: newElement ]
		ifFalse: [ self error: 'Index error' ]
!
METHOD insert: value at: position
	( ( position < 1 ) or: [ position > ( current + 1 ) ] )
		ifTrue: [ self error: 'invalid index for insert:at:' ].
	( current = values size ) ifTrue: [ self reallocate ].
	( position to: current ) reverseDo:
		[ :i | values at: i+1 put: ( values at: i ) ].
	current := current + 1.
	values at: position put: value
!
METHOD printString
	^  self class name + super printString
!
METHOD reallocate
	| newArray |
	newArray := Array new: 2 * values size.
	1 to: values size do: [ :i | newArray at: i put: ( values at: i ) ].
	values := newArray
!
METHOD remove: element
	self remove: element ifAbsent: [ nil ].
!
METHOD remove: element ifAbsent: exceptionBlock
	self removeAt:
		( self indexOf: element ifAbsent: [ ^ exceptionBlock value ] )
!
METHOD removeAt: index
  ( index between: 1 and: current )
      ifFalse: [ self error: 'invalid index for removeAt:' ].
   current := current - 1.
   index to: current do: [ :i | values at: i put: ( values at: i+1 ) ]
!
METHOD size
	^ current
!
