CLASS TestCase subclass: 'TestActionEvent' variables: '' classVariables: ''
	"Unit tests for ActionEvent, sent by a button click.
	 Run with: TestActionEvent run"
METHODS
testButtonClick
	| button semaphore event |
	semaphore := Semaphore new.
	button := Button new text: 'Save' action: [ :actionEvent | semaphore set: actionEvent ].
	< 38 nil button 'doClick' >.
	event := semaphore wait.
	self assert: ( event isKindOf: ActionEvent ).
	"The action command of a button is its text."
	self assert: < 38 String event 'getActionCommand' > = 'Save'.
!
