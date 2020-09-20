CLASS Object subclass: 'Inspector' variables: 'frame frameTabbedPane' classVariables: ''
	"The Inspector GUI window for inspecting objects and classes.
	 This window maintains a list of InspectorTab panes with objects displayed."
META show: object
	^ self new show: object.
!
METHOD show: object
	self createFrame.
	self addTab: object.
	frame show.
!
METHOD createFrame
	frame := Frame new title: 'Inspector'.
	frame setSize: 400 @ 400.
	frame add: self createObjectsTabbedPane.
!
METHOD createObjectsTabbedPane
	^ frameTabbedPane := TabbedPane new.
!
METHOD addTab: object
	"Add object in a new tab."
	| tab |
	tab := InspectorTab new parent: self show: object.
	frameTabbedPane addTab: object class name component: tab panel.
	frameTabbedPane selectedIndex: frameTabbedPane tabCount.
!
METHOD closeSelectedTab
	"Close the selected tab if it is not the last remaining one."
	| index |
	frameTabbedPane tabCount > 1 ifTrue: [
		index := frameTabbedPane selectedIndex.
		index >= 1 ifTrue: [
			frameTabbedPane removeTabAt: index ] ].
!
