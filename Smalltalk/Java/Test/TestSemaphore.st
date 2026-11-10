CLASS TestCase subclass: 'TestSemaphore' variables: '' classVariables: ''
	"Unit tests for Semaphore, also testing Block>>fork.
	 Run with: TestSemaphore run"
METHODS
testForkSetWait
	"A forked block passes a value to this thread through the semaphore."
	| semaphore |
	semaphore := Semaphore new.
	[ semaphore set: 42 ] fork.
	self assert: semaphore wait = 42.
!
testReleaseAcquire
	| semaphore |
	semaphore := Semaphore new.
	semaphore release.
	semaphore acquire.
	self assert: true.
!
