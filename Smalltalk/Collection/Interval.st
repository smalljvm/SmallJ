CLASS Collection subclass: 'Interval' variables: 'low high step' classVariables: ''
META from: aLow to: aHigh by: aStep
	| newInterval |
	newInterval := self new.
	self in: newInterval at: 1 put: aLow.
	self in: newInterval at: 2 put: aHigh.
	self in: newInterval at: 3 put: aStep.
	^ newInterval.
!
METHOD do: aBlock
	| current |
	current := low.
	[ current <= high ] whileTrue: [
		aBlock value: current.
		current := current + step ].
!
METHOD reverseDo: aBlock
	| current |
	current := high.
	[ current >= low ] whileTrue: [
		aBlock value: current.
		current := current - step ].
!
