CLASS List subclass: 'Ordered' variables: 'testBlock' classVariables: ''
META new
	^ self new: [ :a :b | a < b ].
!
META new: testBlock
	^ self in: super new at: 3 put: testBlock.
!
METHOD add: newElement
	super add: newElement.
	(2 to: current) reverseDo: [:i |
		(testBlock value: newElement value: (values at: i-1))
			ifTrue: [ values at: i put: (values at: i-1) ]
			ifFalse: [ ^ values at: i put: newElement] ].
	values at: 1 put: newElement.
!
METHOD at: index put: value
	self error: 'Cannot insert into ordered collection using at:'
!
METHOD insert: value at: index
	self error: 'Cannot insert into ordered collection using insert:'
!
