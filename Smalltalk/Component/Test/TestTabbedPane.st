CLASS TestCase subclass: 'TestTabbedPane' variables: '' classVariables: ''
	"Unit tests for TabbedPane. Tab indices start at 1, 0 means no selection.
	 Run with: TestTabbedPane run"
METHODS
testTabs
	| tabbedPane |
	tabbedPane := TabbedPane new.
	self assert: tabbedPane tabCount = 0.
	self assert: tabbedPane selectedIndex = 0.
	tabbedPane addTab: 'One' component: Panel new.
	tabbedPane addTab: 'Two' component: Panel new.
	self assert: tabbedPane tabCount = 2.
	"The first tab is selected automatically."
	self assert: tabbedPane selectedIndex = 1.
	tabbedPane selectedIndex: 2.
	self assert: tabbedPane selectedIndex = 2.
	tabbedPane removeTabAt: 1.
	self assert: tabbedPane tabCount = 1.
	self assert: < 38 String tabbedPane 'getTitleAt' 0 > = 'Two'.
!
