CLASS JavaObject subclass: 'Semaphore' variables: 'value' classVariables: ''
	"implements java.util.concurrent.Semaphore.
	 Additionally holds a value that can be communicated from sender to receiver (set: & wait)."
CLASSMETHODS
new
	"Semaphore​( int permits )"
	^ < 37 self 'java.util.concurrent.Semaphore' 0 >.
!
METHODS
acquire
	"void acquire()
		throws InterruptedException"
	< 38 nil self 'acquire' >.
!
release
	"void release()"
	< 38 nil self 'release' >.
!
set: aValue
	"Set semaphore value and release it."
	value := aValue.
	self release.
!
wait
	"Wait for semaphore release and return value that might have been set."
	self acquire.
	^ value.
!
