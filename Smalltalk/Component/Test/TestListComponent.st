CLASS TestCase subclass: 'TestListComponent' variables: '' classVariables: ''
	"Unit tests for ListComponent, a javax.swing.JList.
	 Run with: TestListComponent run"
METHODS
testListData
	| list |
	list := ListComponent new.
	list listData: #( 'a' 'b' 'c' ).
	"Selecting the last element only works if there are 3 elements.
	 The list model is not read with the FFI, because it is a non-public Java class (see TestImage)."
	list selectedIndex: 3.
	self assert: list selectedIndex = 3.
!
testPlainFont
	self assert: < 38 Boolean ( ListComponent new font ) 'isPlain' >.
!
testSelectedIndex
	| list |
	list := ListComponent new.
	list listData: #( 'a' 'b' 'c' ).
	self assert: list selectedIndex = 0.
	list selectedIndex: 2.
	self assert: list selectedIndex = 2.
	list selectedIndex: 0.
	self assert: list selectedIndex = 0.
!
testVisibleRowCount
	| list |
	list := ListComponent new.
	list visibleRowCount: 11.
	self assert: < 38 SmallInt list 'getVisibleRowCount' > = 11.
!
testSelectionMode
	| list |
	list := ListComponent new.
	list selectionMode: 0.
	self assert: < 38 SmallInt list 'getSelectionMode' > = 0.
!
