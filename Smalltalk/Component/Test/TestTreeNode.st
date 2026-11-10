CLASS TestCase subclass: 'TestTreeNode' variables: '' classVariables: ''
	"Unit tests for TreeNode, a javax.swing.tree.DefaultMutableTreeNode.
	 Run with: TestTreeNode run"
METHODS
testAdd
	| root |
	root := TreeNode userObject: 'root'.
	root add: ( TreeNode userObject: 'a' ).
	root add: ( TreeNode userObject: 'b' ).
	self assert: < 38 SmallInt root 'getChildCount' > = 2.
!
testUserObject
	self assert: ( TreeNode userObject: 'a' ) userObject = 'a'.
!
testUserObjectPath
	| root child leaf path |
	root := TreeNode userObject: 'root'.
	child := TreeNode userObject: 'child'.
	leaf := TreeNode userObject: 'leaf'.
	root add: child.
	child add: leaf.
	path := leaf userObjectPath.
	self assert: path size = 3.
	self assert: path first = 'root'.
	self assert: path last = 'leaf'.
!
