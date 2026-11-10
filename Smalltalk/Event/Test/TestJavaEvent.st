CLASS TestCase subclass: 'TestJavaEvent' variables: '' classVariables: ''
	"Unit tests for JavaEvent, the abstract base class of the Java event wrappers.
	 It is tested through an ActionEvent from a button click.
	 Run with: TestJavaEvent run"
METHODS
testEvent
	| button semaphore event |
	semaphore := Semaphore new.
	button := Button new text: 'Save' action: [ :actionEvent | semaphore set: actionEvent ].
	< 38 nil button 'doClick' >.
	event := semaphore wait.
	self assert: ( event isKindOf: JavaEvent ).
	self assert: ( event isKindOf: JavaObject ).
	self assert: < 38 Boolean ( < 38 JavaObject event 'getSource' > ) 'equals' button >.
!
testSubclasses
	| subclasses |
	subclasses := JavaEvent subclasses.
	self assert: ( subclasses includes: ActionEvent ).
	self assert: ( subclasses includes: MouseEvent ).
	self assert: ( subclasses includes: WindowEvent ).
!
