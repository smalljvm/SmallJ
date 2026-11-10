CLASS Magnitude subclass: 'Collection' variables: '' classVariables: ''
METHODS
addAll: aCollection
   aCollection do: [ :element | self add: element ]
!
asArray
	| newArray index |
	newArray := Array new: self size.
	index := 1.
	self do: [ :element | newArray at: index put: element.
		index := index + 1 ].
	^ newArray
!
asByteArray
	| newArray index |
	newArray := ByteArray new: self size.
	index := 1.
	self do: [ :element |
		newArray at: index put: element.
		index := index + 1 ].
	^ newArray
!
asList
	^ List new addAll: self
!
asOrdered
	^ Ordered new addAll: self
!
asOrdered: testBlock
	^ ( Ordered new: testBlock ) addAll: self
!
asString
	| newString index |
	newString := String new: self size.
	index := 1.
	self do: [ :element | newString at: index put: element.
		index := index + 1 ].
	^ newString
!
collect: transformBlock
	^ self inject: List new into: [ :list :element |
		list add: ( transformBlock value: element ) ]
!
find: testBlock ifAbsent: exceptionBlock
	self do: [ :element | ( testBlock value: element ) ifTrue: [ ^ element ] ].
	^ exceptionBlock value
!
includes: value
	self do: [ :element | element = value ifTrue: [ ^ true ] ].
	^ false
!
includesTest: aBlock
	self do: [ :element | ( aBlock value: element ) ifTrue: [ ^ true ] ].
	^ false
!
inject: value into: binaryBlock | result |
	result := value.
	self do: [ :element | result := binaryBlock value: result value: element ].
	^ result
!
isEmpty
	"Return true if there are no elements."
	^ self size = 0.
!
printString
	^ ( self inject: '( ' into: [ :str :element | str + element + ' ' ] ) + ' )'
!
reject: testBlock
	^ self select: [ :x | ( testBlock value: x ) not ]
!
select: testBlock
	^ self inject: List new into: [ :list :element |
		( testBlock value: element ) ifTrue: [ list add: element ].
		list ].
!
size
	^ self inject: 0 into: [ :tally :element | tally + 1 ]
!
