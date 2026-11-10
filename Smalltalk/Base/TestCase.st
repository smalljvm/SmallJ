CLASS Object subclass: 'TestCase' variables: 'testName testAssertCount assertCount failureCount' classVariables: ''
	"Base class for unit tests.
	 A subclass defines test methods, whose names start with 'test', that check results with assert:.
	 Run all test methods with: TestBoolean run
	 Run the tests of all subclasses with: TestCase runAll
	 When run from the GUI, like with Evaluate in the System Browser, a failed assert opens the Debugger.
	 Otherwise, like when run as the startup expression of SmallJ, failures are printed on the console
	 and the remaining tests continue."
CLASSMETHODS
run
	"Run all test methods of a new instance. Return true if all asserts passed."
	^ self new run.
!
runAll
	"Run all test classes (see testClasses). Return true if all asserts passed."
	| allPassed |
	allPassed := true.
	self testClasses do: [ :testClass |
		testClass run ifFalse: [ allPassed := false ] ].
	^ allPassed.
!
testClasses
	"Return all classes that inherit from TestCase, directly or indirectly, sorted by name."
	^ Class classes select: [ :aClass | self isTestClass: aClass ].
!
isTestClass: aClass
	"Return true if aClass inherits from TestCase, directly or indirectly."
	| parent |
	parent := aClass superclass.
	[ parent notNil ] whileTrue: [
		parent == TestCase ifTrue: [ ^ true ].
		parent := parent superclass ].
	^ false.
!
METHODS
run
	"Run all instance methods of the class of self whose names start with 'test', in alphabetical order.
	 Print a summary on the console. Return true if all asserts passed."
	assertCount := 0.
	failureCount := 0.
	self selectTestMethods do: [ :method |
		testName := method name.
		testAssertCount := 0.
		self runTest: method ].
	System out println: self class name + ': ' + self selectTestMethods size + ' tests, '
		+ assertCount + ' asserts, ' + failureCount + ' failed.'.
	^ failureCount = 0.
!
selectTestMethods
	"Return the instance methods of the class of self whose names start with 'test'."
	^ self class methods select: [ :method |
		method name size > 4 and: [ ( method name from: 1 to: 4 ) = 'test' ] ].
!
runTest: method
	"Send the message of test method to self.
	 This is done with a compiled block, so the test runs on the same call stack as the sender.
	 Then a failure from the GUI halts all tests, and reaches a Block>>onError: of the sender."
	( '[ :testCase | testCase ' + method name + ' ]' ) doIt value: self.
!
assert: aBoolean
	"Check that aBoolean is true; anything else fails the test.
	 On failure from the GUI, open the Debugger and halt. Otherwise print the failure on the console and continue."
	| message |
	assertCount := assertCount + 1.
	testAssertCount := testAssertCount + 1.
	aBoolean == true ifTrue: [ ^ self ].

	failureCount := failureCount + 1.
	message := 'Assert failed: ' + self class name + '>>' + testName + ', assert ' + testAssertCount + '.'.
	self runningFromGui
		ifTrue: [ self error: message ]
		ifFalse: [ System out println: message ].
!
valueOf: variableName in: object
	"Return the value of instance variable variableName of object.
	 For testing the state of objects that have no accessor method for it."
	| index |
	index := object class instanceVariables indexOf: variableName ifAbsent: [
		^ self error: 'Instance variable not found: ' + variableName ].
	^ Object in: object at: index.
!
runningFromGui
	"Return true if self runs from the GUI, like from Evaluate in the System Browser.
	 GUI events are handled in their own Java threads,
	 while the startup expression of SmallJ runs in the Java main thread."
	| thread |
	thread := < 39 JavaObject 'java.lang.Thread' 'currentThread' >.
	^ < 38 String thread 'getName' > ~= 'main'.
!
