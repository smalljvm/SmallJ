CLASS Component subclass: 'Tree' variables: '' classVariables: ''
	"Implements javax.swing.JTree
	 The nodes are TreeNode instances. Use root: to set or replace them."
CLASSMETHODS
new
	"JTree()"
	^ < 37 self 'javax.swing.JTree' >.
!
METHODS
root: rootNode
	"void setModel( TreeModel newModel ), with a new DefaultTreeModel( TreeNode root ).
	 Replaces all nodes of the tree. The root node is expanded."
	| model |
	model := < 43 JavaObject 'javax.swing.tree.DefaultTreeModel' 'javax.swing.tree.TreeNode' rootNode >.
	< 38 nil self 'setModel' model >.
!
rootVisible: aBoolean
	"void setRootVisible( boolean rootVisible )
	 If false, the children of the root node are shown as the top level nodes."
	< 38 nil self 'setRootVisible' aBoolean >.
!
showsRootHandles: aBoolean
	"void setShowsRootHandles( boolean newValue )
	 Show expand handles for the top level nodes, needed when the root is not visible."
	< 38 nil self 'setShowsRootHandles' aBoolean >.
!
visibleRowCount: rowCount
	"void setVisibleRowCount( int newCount )
	 The preferred height of the tree in rows, used when it is in a scroll pane. The default is 20."
	< 38 nil self 'setVisibleRowCount' rowCount >.
!
selectedNode
	"Object getLastSelectedPathComponent()
	 Return the selected TreeNode, or nil if there is no selection."
	^ < 38 TreeNode self 'getLastSelectedPathComponent' >.
!
onSelect: block
	"On selection change in the tree, evaluate block
	 with a new instance of TreeSelectionEvent as a parameter, containing the event data.
	 void addTreeSelectionListener( TreeSelectionListener listener )"
	< 42 self 9 block TreeSelectionEvent >.
!
