CLASS TestCase subclass: 'TestTree' variables: '' classVariables: ''
	"Unit tests for Tree, a javax.swing.JTree.
	 Run with: TestTree run"
METHODS
createTree
	"Return a tree with a hidden root and 2 top level nodes."
	| tree root |
	root := TreeNode userObject: '.'.
	root add: ( TreeNode userObject: 'Base' ).
	root add: ( TreeNode userObject: 'Io' ).
	tree := Tree new.
	tree rootVisible: false.
	tree showsRootHandles: true.
	tree root: root.
	^ tree.
!
testOnSelect
	| tree semaphore |
	semaphore := Semaphore new.
	tree := self createTree.
	tree onSelect: [ :treeSelectionEvent | semaphore set: treeSelectionEvent ].
	< 38 nil tree 'setSelectionRow' 1 >.
	self assert: ( semaphore wait isKindOf: TreeSelectionEvent ).
!
testRoot
	| tree |
	tree := self createTree.
	self assert: < 38 Boolean tree 'isRootVisible' > not.
	self assert: < 38 Boolean tree 'getShowsRootHandles' >.
	"The hidden root is expanded, so its children are the rows."
	self assert: < 38 SmallInt tree 'getRowCount' > = 2.
!
testVisibleRowCount
	| tree |
	tree := self createTree.
	tree visibleRowCount: 11.
	self assert: < 38 SmallInt tree 'getVisibleRowCount' > = 11.
!
testSelectedNode
	| tree |
	tree := self createTree.
	self assert: tree selectedNode isNil.
	< 38 nil tree 'setSelectionRow' 1 >.
	self assert: tree selectedNode userObject = 'Io'.
!
