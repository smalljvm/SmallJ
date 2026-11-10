CLASS Object subclass: 'Inspector' variables: 'frame frameTabbedPane' classVariables: ''
	"The Inspector GUI window for inspecting objects and classes.
	 This window maintains a list of InspectorTab panes with objects displayed."
CLASSMETHODS
show: object
	^ self new show: object.
!
METHODS
show: object
	self createFrame.
	self addTab: object.
	frame show.
!
createFrame
	frame := Frame new title: 'Inspector'.
	frame setSize: 400 @ 400.
	frame add: self createObjectsTabbedPane.
!
createObjectsTabbedPane
	^ frameTabbedPane := TabbedPane new.
!
addTab: object
	"Add object in a new tab."
	| tab |
	tab := InspectorTab new parent: self show: object.
	frameTabbedPane addTab: object class name component: tab panel.
	frameTabbedPane selectedIndex: frameTabbedPane tabCount.
!
closeSelectedTab
	"Close the selected tab if it is not the last remaining one."
	| index |
	frameTabbedPane tabCount > 1 ifTrue: [
		index := frameTabbedPane selectedIndex.
		index >= 1 ifTrue: [
			frameTabbedPane removeTabAt: index ] ].
!
