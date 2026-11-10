CLASS TestCase subclass: 'TestButton' variables: '' classVariables: ''
	"Unit tests for Button.
	 The action block runs in its own thread, so its result is passed back with a Semaphore.
	 Run with: TestButton run"
METHODS
testAction
	| button semaphore |
	semaphore := Semaphore new.
	button := Button new text: 'Save' action: [ :actionEvent | semaphore set: actionEvent ].
	< 38 nil button 'doClick' >.
	self assert: ( semaphore wait isKindOf: ActionEvent ).
!
testText
	| button |
	button := Button new.
	button text: 'Save'.
	self assert: < 38 String button 'getText' > = 'Save'.
	"The first character is the mnemonic."
	self assert: < 38 SmallInt button 'getMnemonic' > = $S value.
!
