CLASS TestCase subclass: 'TestAdjustmentEvent' variables: '' classVariables: ''
	"Unit tests for AdjustmentEvent, sent when a scroll bar changes.
	 Run with: TestAdjustmentEvent run"
METHODS
testValue
	| scrollBar semaphore event |
	semaphore := Semaphore new.
	scrollBar := ScrollBar orientation: 1 value: 0 extent: 10 min: 0 max: 100.
	scrollBar onAdjust: [ :adjustmentEvent | semaphore set: adjustmentEvent ].
	scrollBar value: 40.
	event := semaphore wait.
	self assert: ( event isKindOf: AdjustmentEvent ).
	self assert: event value = 40.
!
