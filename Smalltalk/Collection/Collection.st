CLASS Magnitude subclass: 'Collection' variables: '' classVariables: ''
METHOD addAll: aCollection
   aCollection do: [ :element | self add: element ]
!
METHOD asArray
	| newArray index |
	newArray <- Array new: self size.
	index <- 1.
	self do: [ :element | newArray at: index put: element.
		index <- index + 1 ].
	^ newArray
!
METHOD asByteArray
	| newArray index |
	newArray <- ByteArray new: self size.
	index <- 1.
	self do: [ :element |
		newArray at: index put: element.
		index <- index + 1 ].
	^ newArray
!
METHOD asList
	^ List new addAll: self
!
METHOD asOrdered
	^ Ordered new addAll: self
!
METHOD asOrdered: testBlock
	^ ( Ordered new: testBlock ) addAll: self
!
METHOD asString
	| newString index |
	newString <- String new: self size.
	index <- 1.
	self do: [ :element | newString at: index put: element.
		index <- index + 1 ].
	^ newString
!
METHOD collect: transformBlock
	^ self inject: List new into: [ :list :element |
		list add: ( transformBlock value: element ) ]
!
METHOD find: testBlock ifAbsent: exceptionBlock
	self do: [ :element | ( testBlock value: element ) ifTrue: [ ^ element ] ].
	^ exceptionBlock value
!
METHOD includes: value
	self do: [ :element | element = value ifTrue: [ ^ true ] ].
	^ false
!
METHOD includesTest: aBlock
	self do: [ :element | ( aBlock value: element ) ifTrue: [ ^ true ] ].
	^ false
!
METHOD inject: value into: binaryBlock | result |
	result <- value.
	self do: [ :element | result <- binaryBlock value: result value: element ].
	^ result
!
METHOD isEmpty
	"Return true if there are no elements."
	^ self size = 0.
!
METHOD printString
	^ ( self inject: '( ' into: [ :str :element | str + element + ' ' ] ) + ' )'
!
METHOD reject: testBlock
	^ self select: [ :x | ( testBlock value: x ) not ]
!
METHOD select: testBlock
	^ self inject: List new into: [ :list :element |
		( testBlock value: element ) ifTrue: [ list add: element ].
		list ].
!
METHOD size
	^ self inject: 0 into: [ :tally :element | tally + 1 ]
!
