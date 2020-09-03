CLASS Component subclass: 'TabbedPane' variables: '' classVariables: ''
	"Implements javax.swing.JTabbedPane
	 Note: Indices of tabs are 1-based, with 0 indicating no selection."
META new
	"JTabbedPane()"
	^ < 37 self 'javax.swing.JTabbedPane' >.
!
METHOD addTab: title component: component
	"void addTab( String title, Component component )"
	< 38 nil self 'addTab' title component >.
!
METHOD removeTabAt: index
	"removeTabAt( int index )"
	^ < 38 SmallInt self 'removeTabAt' ( index - 1 ) >.
!
METHOD selectedIndex
	"Return index of selected tab, 1-based or 0 if none."
	"int getSelectedIndex()"
	^ < 38 SmallInt self 'getSelectedIndex' > + 1.
!
METHOD selectedIndex: index
	"Set selected tab by index, 1-based or 0 if none."
	"setSelectedIndex( int index )"
	^ < 38 SmallInt self 'setSelectedIndex' ( index - 1 ) >.
!
METHOD tabCount
	"int getTabCount()"
	^ < 38 SmallInt self 'getTabCount' >.
!
