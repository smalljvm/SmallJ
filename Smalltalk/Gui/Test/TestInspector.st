CLASS TestCase subclass: 'TestInspector' variables: '' classVariables: ''
	"Unit tests for Inspector, without showing its window.
	 The tabbed pane is created without the frame.
	 Run with: TestInspector run"
METHODS
testTabs
	| inspector tabbedPane |
	inspector := Inspector new.
	tabbedPane := inspector createObjectsTabbedPane.
	inspector addTab: 3 @ 4.
	self assert: tabbedPane tabCount = 1.
	self assert: < 38 String tabbedPane 'getTitleAt' 0 > = 'Point'.
	inspector addTab: #( 1 2 ).
	self assert: tabbedPane tabCount = 2.
	self assert: tabbedPane selectedIndex = 2.
	inspector closeSelectedTab.
	self assert: tabbedPane tabCount = 1.
	"The last tab is not closed."
	inspector closeSelectedTab.
	self assert: tabbedPane tabCount = 1.
!
