CLASS Component subclass: 'TabbedPane' variables: '' classVariables: ''
	"Implements javax.swing.JTabbedPane
	 Note: Indices of tabs are 1-based, with 0 indicating no selection."
CLASSMETHODS
new
	"JTabbedPane()"
	^ < 37 self 'javax.swing.JTabbedPane' >.
!
METHODS
addTab: title component: component
	"void addTab( String title, Component component )"
	< 38 nil self 'addTab' title component >.
!
removeTabAt: index
	"removeTabAt( int index )"
	^ < 38 SmallInt self 'removeTabAt' ( index - 1 ) >.
!
selectedIndex
	"Return index of selected tab, 1-based or 0 if none."
	"int getSelectedIndex()"
	^ < 38 SmallInt self 'getSelectedIndex' > + 1.
!
selectedIndex: index
	"Set selected tab by index, 1-based or 0 if none."
	"setSelectedIndex( int index )"
	^ < 38 SmallInt self 'setSelectedIndex' ( index - 1 ) >.
!
tabCount
	"int getTabCount()"
	^ < 38 SmallInt self 'getTabCount' >.
!
