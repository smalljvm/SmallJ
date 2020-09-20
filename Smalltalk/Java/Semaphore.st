CLASS JavaObject subclass: 'Semaphore' variables: 'value' classVariables: ''
	"implements java.util.concurrent.Semaphore.
	 Additionally holds a value that can be communicated from sender to receiver (set: & wait)."
META new
	"Semaphore​( int permits )"
	^ < 37 self 'java.util.concurrent.Semaphore' 0 >.
!
METHOD acquire
	"void acquire()
		throws InterruptedException"
	< 38 nil self 'acquire' >.
!
METHOD release
	"void release()"
	< 38 nil self 'release' >.
!
METHOD set: aValue
	"Set semaphore value and release it."
	value := aValue.
	self release.
!
METHOD wait
	"Wait for semaphore release and return value that might have been set."
	self acquire.
	^ value.
!
