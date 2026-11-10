CLASS TestCase subclass: 'TestSystemBrowser' variables: '' classVariables: ''
	"Unit tests for SystemBrowser, without showing its window.
	 The panels are created without the frame, then loaded with data.
	 Not tested: the menu actions, which show dialogs.
	 Run with: TestSystemBrowser run"
METHODS
createBrowser
	"Return a browser with all panels, but without a frame."
	| browser |
	browser := SystemBrowser new.
	browser createSelectPanel.
	browser createSourcePanel.
	browser createEvaluatePanel.
	^ browser.
!
testEvaluate
	| browser |
	browser := self createBrowser.
	( self valueOf: 'expressionTextField' in: browser ) text: '3 + 4'.
	self assert: browser evaluate = 7.
	self assert: ( self valueOf: 'evaluateResultTextField' in: browser ) text = '7'.
!
testFolderNameOf
	| browser root base test |
	browser := self createBrowser.
	root := TreeNode userObject: '.'.
	base := TreeNode userObject: 'Base'.
	test := TreeNode userObject: 'Test'.
	root add: base.
	base add: test.
	self assert: ( browser folderNameOf: base ) = 'Base'.
	self assert: ( browser folderNameOf: test ) = 'Base/Test'.
!
testLoadClasses
	| browser classes |
	browser := self createBrowser.
	Object in: browser initialize: 'selectedFolder' with: 'Base'.
	browser loadClasses.
	classes := self valueOf: 'classes' in: browser.
	self assert: ( classes includes: Boolean ).
	self assert: ( classes includes: TestBoolean ) not.
!
testLoadFolders
	| browser folderTree |
	browser := self createBrowser.
	browser loadFolders.
	folderTree := self valueOf: 'folderTree' in: browser.
	"The top level folders are shown, like Base, Collection and Io."
	self assert: < 38 SmallInt folderTree 'getRowCount' > >= 9.
	self assert: folderTree selectedNode isNil.
!
testSelectPanelHeights
	"The folder, class and method panes are 11 rows high and have the same height."
	| browser selectPanel heights |
	browser := SystemBrowser new.
	selectPanel := browser createSelectPanel.
	self assert: < 38 SmallInt ( self valueOf: 'folderTree' in: browser ) 'getVisibleRowCount' > = 11.
	self assert: < 38 SmallInt ( self valueOf: 'classListComponent' in: browser ) 'getVisibleRowCount' > = 11.
	< 38 nil selectPanel 'setSize' ( < 38 JavaObject selectPanel 'getPreferredSize' > ) >.
	< 38 nil selectPanel 'doLayout' >.
	heights := ( 0 to: 2 ) collect: [ :index |
		< 38 SmallInt ( < 38 JavaObject selectPanel 'getComponent' index > ) 'getHeight' > ].
	self assert: heights first > 100.
	self assert: heights first = ( heights at: 2 ).
	self assert: heights first = ( heights at: 3 ).
!
testLoadSource
	| browser |
	browser := self createBrowser.
	Object in: browser initialize: 'selectedClass' with: Boolean.
	browser loadSource.
	browser loadMethods.
	self assert: ( ( self valueOf: 'sourceTextArea' in: browser ) text find: 'CLASS Object subclass: ''Boolean''' ) = 1.
!
