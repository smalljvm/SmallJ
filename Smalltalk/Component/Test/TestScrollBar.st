CLASS TestCase subclass: 'TestScrollBar' variables: '' classVariables: ''
	"Unit tests for ScrollBar.
	 Run with: TestScrollBar run"
METHODS
testCreate
	| scrollBar |
	scrollBar := ScrollBar orientation: 1 value: 5 extent: 10 min: 0 max: 100.
	self assert: scrollBar value = 5.
	self assert: scrollBar maximum = 100.
	self assert: < 38 SmallInt scrollBar 'getOrientation' > = 1.
!
testOnAdjust
	| scrollBar semaphore |
	semaphore := Semaphore new.
	scrollBar := ScrollBar orientation: 1 value: 5 extent: 10 min: 0 max: 100.
	scrollBar onAdjust: [ :adjustmentEvent | semaphore set: adjustmentEvent value ].
	scrollBar value: 20.
	self assert: semaphore wait = 20.
!
testValue
	| scrollBar |
	scrollBar := ScrollBar orientation: 0 value: 0 extent: 10 min: 0 max: 100.
	scrollBar value: 30.
	self assert: scrollBar value = 30.
!
