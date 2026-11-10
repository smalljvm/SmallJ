CLASS TestCase subclass: 'TestMenu' variables: '' classVariables: ''
	"Unit tests for Menu.
	 Run with: TestMenu run"
METHODS
testAdd
	| menu item semaphore |
	semaphore := Semaphore new.
	menu := Menu text: 'File'.
	item := menu add: 'Open' action: [ :actionEvent | semaphore set: 'opened' ].
	self assert: < 38 SmallInt menu 'getItemCount' > = 1.
	self assert: < 38 String item 'getText' > = 'Open'.
	self assert: < 38 SmallInt item 'getMnemonic' > = $O value.
	< 38 nil item 'doClick' >.
	self assert: semaphore wait = 'opened'.
!
testText
	| menu |
	menu := Menu text: 'File'.
	self assert: < 38 String menu 'getText' > = 'File'.
	self assert: < 38 SmallInt menu 'getMnemonic' > = $F value.
!
