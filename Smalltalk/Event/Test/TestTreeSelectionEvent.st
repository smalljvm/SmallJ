CLASS TestCase subclass: 'TestTreeSelectionEvent' variables: '' classVariables: ''
	"Unit tests for TreeSelectionEvent, sent when the selection of a tree changes.
	 Run with: TestTreeSelectionEvent run"
METHODS
testIsAddedPath
	| root tree semaphore event |
	root := TreeNode userObject: '.'.
	root add: ( TreeNode userObject: 'Base' ).
	tree := Tree new.
	tree root: root.
	semaphore := Semaphore new.
	tree onSelect: [ :treeSelectionEvent | semaphore set: treeSelectionEvent ].
	< 38 nil tree 'setSelectionRow' 1 >.
	event := semaphore wait.
	self assert: ( event isKindOf: TreeSelectionEvent ).
	self assert: event isAddedPath.
!
