CLASS Indexed subclass: 'Array' variables: '' classVariables: ''
META new
	^ self error: 'Arrays cannot be created with new. Use new: <size>.'
!
META new: aSize
	^ < 7 self aSize >.
!
METHOD + argArray
	"Return new array with elements of self and argArray concatenated."
	| selfSize argSize newArray |
	selfSize <- self size.
	argSize <- argArray size.
	newArray <- self class new: ( selfSize + argSize ).
	1 to: selfSize do: [ :i |
		newArray at: i put: ( self at: i ) ].
	1 to: argSize do: [ :i |
		newArray at: ( selfSize + i ) put: ( argArray at: i ) ].
	^ newArray.
!
METHOD add: newItem
   ^ < 31 self newItem >.
!
METHOD asString
  ^ self inject: '' into: [ :string :element |
		string + element + ' ' ].
!
METHOD asStringArray
   ^ ( self collect: [ :n | n printString ] ) asArray.
!
METHOD at: index ifAbsent: exceptionBlock
	( self includesKey: index )
	     ifTrue: [ ^ < 30 self index > ]
	     ifFalse: [ ^ exceptionBlock value ]
!
METHOD at: index put: value
	( self includesKey: index ) ifFalse: [
		self error: 'Array index out of bounds: ' + self size + ', size: ' + index ].
	< 18 self index value >.
!
METHOD copy
	^ self asArray
!
METHOD from: start size: sz
	^ self from: start to: ( start + sz - 1 )
!
METHOD from: low to: high | start size newArray |
	start <- low max: 0.
	size <- ( high min: self size ) + 1 - start max: 0.
	newArray <- self class new: size.
	1 to: size do: [ :i |
		newArray at: i put: ( self at: start ).
		start <- start + 1 ].
	^ newArray
!
METHOD printString
	^ '#' + super printString.
!
METHOD removeAt: i
	"Return new array with the item at index i removed."
	| result |
	( i between: 1 and: self size ) ifFalse: [ ^ self ].
	result <- Array new: self size - 1.
	( 1 to: i - 1 ) do: [ :j |
		result at: j put: ( self at: j ) ].
	( i + 1 to: self size ) do: [ :j |
		result at: j - 1 put: ( self at: j ) ].
	^ result.
!
METHOD size
	"Return number of elements in array."
	^ < 4 self >.
!
