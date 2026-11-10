CLASS JavaObject subclass: 'TreeNode' variables: '' classVariables: ''
	"Implements javax.swing.tree.DefaultMutableTreeNode
	 A node of a Tree. The user object is shown as the text of the node."
CLASSMETHODS
userObject: anObject
	"DefaultMutableTreeNode( Object userObject )"
	^ < 43 self 'javax.swing.tree.DefaultMutableTreeNode' 'java.lang.Object' anObject >.
!
METHODS
add: childNode
	"void add( MutableTreeNode newChild )"
	< 38 nil self 'add' childNode >.
!
userObject
	"Object getUserObject()"
	^ < 38 JavaObject self 'getUserObject' >.
!
userObjectPath
	"Object[] getUserObjectPath()
	 Return an Array with the user objects of the nodes from the root to this node."
	^ JavaArray toArray: < 38 JavaObject self 'getUserObjectPath' > class: JavaObject.
!
