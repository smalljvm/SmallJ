CLASS Object subclass: 'SystemBrowser' variables: 'frame folderTree classListComponent methodTabbedPane instanceMethodListComponent classMethodListComponent sourceScrollPane sourceTextArea compileResultTextField expressionTextField evaluateResultTextField selectedFolder classes selectedClass selectedSource' classVariables: ''
CLASSMETHODS
show
	^ self new show.
!
METHODS
show
	self createFrame.
	self loadFolders.
	frame show.
!
createFrame
	| selectSourceSplitPane framePanel |

	"Splitter bar betweeen select panel and source panel."
	selectSourceSplitPane := SplitPane new.
	selectSourceSplitPane orientation: SplitPane vertical.
	selectSourceSplitPane leftComponent: self createSelectPanel.	"top"
	selectSourceSplitPane rightComponent: self createSourcePanel.	"bottom"

	framePanel := Panel new.
	framePanel layout: BorderLayout new.
	framePanel add: selectSourceSplitPane constraints: ( BorderLayout center ).
	framePanel add: self createEvaluatePanel constraints: ( BorderLayout south ).

	frame := Frame new title: 'System Browser'.
	frame setSize: 800 @ 800.
	frame menuBar: self createMenuBar.
	frame onClosing: [ :windowEvent | self confirmExit ].
	frame add: framePanel.
!
createMenuBar
	| fileMenu classMenu menuBar |

	fileMenu := Menu text: 'File'.
	fileMenu add: 'Save Image' action: [ :actionEvent | self saveImage ].
	fileMenu add: 'Exit' action: [ :actionEvent | self confirmExit ].

	classMenu := Menu text: 'Class'.
	classMenu add: 'Compile All' action: [ :actionEvent | self compileAll ].
	classMenu add: 'Test All' action: [ :actionEvent | self testAll ].
	classMenu add: 'File In' action: [ :actionEvent | self fileInClass ].
	classMenu add: 'Delete' action: [ :actionEvent | self deleteClass ].

	menuBar := MenuBar new.
	menuBar add: fileMenu.
	menuBar add: classMenu.

	^ menuBar.
!
createSelectPanel
	"Initialize the folder, class, method selection panel. Sets member variables."
	| insets gbc00 gbc10 gbc20 selectPanel |

	insets := Insets top: 4 left: 4 bottom: 4 right: 4.

	"Layouts for panels: Folder, Class and Method."
	gbc00 := GridBagConstraints grid: 0 @ 0 size: 1 @ 1 weight: 1.0 @ 1.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints both )
		insets: insets ipad: 0 @ 0.
	gbc10 := GridBagConstraints grid: 1 @ 0 size: 1 @ 1 weight: 1.0 @ 1.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints both )
		insets: insets ipad: 0 @ 0.
	gbc20 := GridBagConstraints grid: 2 @ 0 size: 1 @ 1 weight: 1.0 @ 1.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints both )
		insets: insets ipad: 0 @ 0.

	selectPanel := Panel new.
	selectPanel layout: GridBagLayout new.
	selectPanel add: self createFolderPanel constraints: gbc00.
	selectPanel add: self createClassPanel constraints: gbc10.
	selectPanel add: self createMethodPanel constraints: gbc20.

	^ selectPanel.
!
selectRowCount
	"Return the default height in rows of the folder, class and method panes.
	 They are in one row of the select panel, so they get the same height.
	 The split pane gives the remaining height of the frame to the source pane."
	^ 11.
!
createFolderPanel
	| folderScrollPane |

	"The root node of the folder tree is the current working folder. It is hidden, showing its subfolders at the top level."
	folderTree := Tree new.
	folderTree rootVisible: false.
	folderTree showsRootHandles: true.
	folderTree visibleRowCount: self selectRowCount.
	folderTree onSelect: [ :treeSelectionEvent | self onFolderSelected ].

	folderScrollPane := ScrollPane view: folderTree.
	folderScrollPane border: ( Border createTitledBorder: 'Folder' ).
	^ folderScrollPane.
!
createClassPanel
	| classScrollPane |

	classListComponent := ListComponent new.
	classListComponent visibleRowCount: self selectRowCount.
	classListComponent onMouseClicked: [ :listSelectionEvent | self onClassSelected ].

	classScrollPane := ScrollPane view: classListComponent.
	classScrollPane border: ( Border createTitledBorder: 'Class' ).
	^ classScrollPane.
!
createMethodPanel
	| instanceMethodScrollPane classMethodScrollPane |

	instanceMethodListComponent := ListComponent new.
	instanceMethodListComponent visibleRowCount: self selectRowCount.
	instanceMethodListComponent onMouseClicked: [ :listSelectionEvent | self onInstanceMethodSelected ].
	instanceMethodScrollPane := ScrollPane view: instanceMethodListComponent.

	classMethodListComponent := ListComponent new.
	classMethodListComponent visibleRowCount: self selectRowCount.
	classMethodListComponent onMouseClicked: [ :listSelectionEvent | self onClassMethodSelected ].
	classMethodScrollPane := ScrollPane view: classMethodListComponent.

	methodTabbedPane := TabbedPane new.
	methodTabbedPane border: ( Border createTitledBorder: 'Method' ).
	methodTabbedPane addTab: 'Instance' component: instanceMethodScrollPane.
	methodTabbedPane addTab: 'Class' component: classMethodScrollPane.

	^ methodTabbedPane.
!
createSourcePanel
	"Initialize the source edit & compile panel. Sets member variables."
	| insets gbc00 gbc10 gbc20
	  sourcePanel compilePanel compileButton compileResultLabel |

	insets := Insets top: 4 left: 4 bottom: 4 right: 4.

	sourceTextArea := TextArea new.
	sourceTextArea tabSize: 2.
	sourceTextArea font: ( Font name: 'Consolas' style: 0 size: 12 ).

	sourceScrollPane := ScrollPane view: sourceTextArea.

	compileButton := Button new text: 'Save & Compile' action: [ :actionEvent | self saveAndCompile ].
	gbc00 := GridBagConstraints grid: 0 @ 0 size: 1 @ 1 weight: 0.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints none )
		insets: insets ipad: 0 @ 0.

	compileResultLabel := Label new text: 'Result'.
	gbc10 := GridBagConstraints grid: 1 @ 0 size: 1 @ 1 weight: 0.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints none )
		insets: insets ipad: 0 @ 0.

	compileResultTextField := TextField new.
	compileResultTextField background: ( Color red: 250 green: 250 blue: 250 ).
	compileResultTextField editable: false.
	gbc20 := GridBagConstraints grid: 2 @ 0 size: 1 @ 1 weight: 1.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints horizontal )
		insets: insets ipad: 0 @ 0.

	compilePanel := Panel new.
	compilePanel layout: GridBagLayout new.
	compilePanel add: compileButton constraints: gbc00.
	compilePanel add: compileResultLabel constraints: gbc10.
	compilePanel add: compileResultTextField constraints: gbc20.

	sourcePanel := Panel new.
	sourcePanel layout: BorderLayout new.
	sourcePanel border: ( Border createTitledBorder: 'Source' ).
	sourcePanel add: sourceScrollPane constraints: BorderLayout center.
	sourcePanel add: compilePanel constraints: BorderLayout south.

	^ sourcePanel.
!
createEvaluatePanel
	"Initialize the expression evaluation & result panel. Sets member variables."
	| insets gbc00 gbc10 gbc20 gbc01 gbc11
	  evaluatePanel evaluateButton inspectButton evaluateResultLabel |

	insets := Insets top: 4 left: 4 bottom: 4 right: 4.

	inspectButton := Button new text: 'Inspect' action: [ :actionEvent | self onInspect ].
	gbc00 := GridBagConstraints grid: 0 @ 0 size: 1 @ 1 weight: 0.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints none )
		insets: insets ipad: 0 @ 0.

	evaluateButton := Button new text: 'Evaluate' action: [ :actionEvent | self evaluate ].
	gbc10 := GridBagConstraints grid: 1 @ 0 size: 1 @ 1 weight: 0.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints none )
		insets: insets ipad: 0 @ 0.

	expressionTextField := TextField new.
	gbc20 := GridBagConstraints grid: 2 @ 0 size: 1 @ 1 weight: 1.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints horizontal )
		insets: insets ipad: 0 @ 0.

	evaluateResultLabel := Label new text: 'Result'.
	evaluateResultLabel horizontalAlignment: 0.		"center"
	gbc01 := GridBagConstraints grid: 0 @ 1 size: 1 @ 1 weight: 0.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints horizontal )
		insets: insets ipad: 0 @ 0.

	evaluateResultTextField := TextField new.
	evaluateResultTextField background: ( Color red: 250 green: 250 blue: 250 ).
	evaluateResultTextField editable: false.
	gbc11 := GridBagConstraints grid: 1 @ 1 size: 2 @ 1 weight: 1.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints horizontal )
		insets: insets ipad: 0 @ 0.

	evaluatePanel := Panel new.
	evaluatePanel layout: GridBagLayout new.
	evaluatePanel border: ( Border createTitledBorder: 'Evaluate' ).
	evaluatePanel add: inspectButton constraints: gbc00.
	evaluatePanel add: evaluateButton constraints: gbc10.
	evaluatePanel add: expressionTextField constraints: gbc20.
	evaluatePanel add: evaluateResultLabel constraints: gbc01.
	evaluatePanel add: evaluateResultTextField constraints: gbc11.

	^ evaluatePanel.
!
loadFolders
	"Load the folders in the current working folder and its subfolders into folderTree.
	 Folders of classes that are not in it, like classes filed in from elsewhere,
	 are added at the top level with their full name."
	| rootNode folderNames folderName |
	rootNode := TreeNode userObject: '.'.
	folderNames := List new.
	self addFolderNodesIn: '' to: rootNode names: folderNames.
	Class classes do: [ :class |
		folderName := class sourceFolderName.
		( folderName notNil and: [ ( folderNames includes: folderName ) not ] ) ifTrue: [
			folderNames add: folderName.
			rootNode add: ( TreeNode userObject: folderName ) ] ].
	folderTree root: rootNode.
	self clearSelectedFolder.
!
addFolderNodesIn: folderName to: parentNode names: folderNames
	"Add a node for every subfolder of folderName to parentNode, recursively.
	 Add the subfolder names to folderNames."
	| node |
	( File folderNamesIn: folderName ) do: [ :subfolderName |
		folderNames add: subfolderName.
		node := TreeNode userObject: ( File name: subfolderName ) name.
		parentNode add: node.
		self addFolderNodesIn: subfolderName to: node names: folderNames ].
!
folderNameOf: node
	"Return the folder name of node in folderTree: the names of the nodes from the root to node, separated by slashes.
	 The root node itself is not part of the name."
	| names |
	names := node userObjectPath.
	^ ( names from: 3 to: names size ) inject: ( names at: 2 ) into: [ :path :name | path + '/' + name ].
!
clearSelectedFolder
	selectedFolder := nil.
	classListComponent listData: List new.
	self clearSelectedClass.
!
onFolderSelected
	"Set selected folder and load classes from it."
	| node |
	node := folderTree selectedNode.
	node isNil ifTrue: [ ^ self clearSelectedFolder ].
	selectedFolder := self folderNameOf: node.
	self loadClasses.
!
loadClasses
	"Load classes for selected folder into classListComponent component."
	| classNames |
	classes := Ordered new: [ :class1 :class2 | class1 name < class2 name ].
	Class classes do: [ :class |
		class sourceFolderName = selectedFolder ifTrue: [
			classes add: class ] ].
	classNames := classes collect: [ :class | class name ].
	classListComponent listData: classNames.
	self clearSelectedClass.
!
clearSelectedClass
	selectedClass := nil.
	instanceMethodListComponent listData: List new.
	classMethodListComponent listData: List new.
	sourceTextArea text: ''.
!
onClassSelected
	"Set selected class and load methods from it."
	selectedClass := classes at: ( classListComponent selectedIndex ).
	self loadMethods.
	self loadSource.
	"Because of a bug in de Java framework (currently 14),
	 setting the caret position 0 does not scroll to the top text line.
	 So we first set it to 1 and then to 0."
	sourceTextArea caretPosition: 1.
	sourceTextArea caretPosition: 0.
	sourceTextArea requestFocus.
!
loadMethods
	"Load instance and class methods for the selected class."
	instanceMethodListComponent listData: selectedClass methods asStringArray.
	classMethodListComponent listData: selectedClass class methods asStringArray.
!
loadSource
	"Load source fom selected class into the source text area."
	selectedSource := ( File openRead: selectedClass sourceFileName ) asString.
	sourceTextArea text: selectedSource.
!
onInstanceMethodSelected
	"Set cursor to line number of selected insctance method in source text area."
	self gotoMethodInSource: (
		selectedClass methods at:
			instanceMethodListComponent selectedIndex ).
!
onClassMethodSelected
	"Set cursor to line number of selected class method in source text area."
	self gotoMethodInSource: (
		selectedClass class methods at:
			classMethodListComponent selectedIndex ).
!
gotoMethodInSource: method
	"Place the cursor (caret) at the starting line of the method.
	 Make that line the top in the view of there is enough text behind it to fill the source pane."
	| textPosition viewPosition |
	method lineNum <= sourceTextArea lineCount ifTrue: [
		textPosition := sourceTextArea lineStartOffset: method lineNum.
		viewPosition := sourceTextArea modelToView: textPosition.
		sourceTextArea requestFocus.
		sourceTextArea caretPosition: textPosition.
		sourceTextArea repaint.
		"NB: Setting the viewport must be done last, due to a drawing bug in the Java framework."
		sourceScrollPane viewport viewPosition: viewPosition location. ]
!
saveAndCompile
	| file |
	"Save file if it is modified.
	 Then file it in from disk, just in case it was modified in an external editor like VSCode.
	 Then reload possible modified source into GUI."

	"Save source if it was changed."
	selectedSource = sourceTextArea text ifFalse: [
		file := File openWrite: selectedClass sourceFileName.
		file write: sourceTextArea text.
		file close.
		selectedSource := sourceTextArea text ].

	"Reload & file-in source, possibly modified externally."
	self loadSource.
	"Must set default result to failed because compilation failure currently executes a thread halt."
	compileResultTextField text: ''.
	ClassParser fileIn: selectedClass sourceFileName.
	compileResultTextField text: 'Succeeded'.
	self loadMethods.
!
evaluate
	"Evaluate the expression in expressionTextField and show the result in evaluateResultTextField.
	 On an error, show the error message instead."
	| result |
	evaluateResultTextField text: ''.
	result := [ expressionTextField text doIt ] onError: [ :message |
		evaluateResultTextField text: 'Error: ' + message ].
	evaluateResultTextField text: result printString.
	^ result.
!
onInspect
	"Inspect the result of evaluating the expression (see evaluate)."
	Inspector show: self evaluate.
!
saveImage
	"Save image and show notification."
	System saveImage.
	OptionPane showMessageDialogOn: frame message: 'Image saved.' title: 'Save Image' type: 1.
!
confirmExit
	| answer |
	answer := OptionPane showConfirmDialogOn: frame message: 'Save Image?' title: 'Exiting SmallJ' option: 1.
	answer ifTrue: [ System saveImage ].
	answer ifNotNil: [ frame close. System exit: 0 ].	"Yes or No, not Cancel."
!
compileAll
	"Compile all classes, including new source files in the folder tree (see ClassParser class>>fileInAll)."
	ClassParser fileInAll.
	OptionPane showMessageDialogOn: frame message: 'All classes compiled succesfully.' title: 'Compile all classes' type: 1.
	self loadFolders.
!
testAll
	"Run all unit tests (see TestCase class>>runAll) and show the result: OK, or the first failure.
	 A failure halts the tests and also opens the Debugger (see TestCase>>assert:)."
	| allPassed |
	allPassed := [ TestCase runAll ] onError: [ :message |
		OptionPane showMessageDialogOn: frame message: message title: 'Test All' type: 0 ].
	allPassed
		ifTrue: [ OptionPane showMessageDialogOn: frame message: 'All tests OK.' title: 'Test All' type: 1 ]
		ifFalse: [ OptionPane showMessageDialogOn: frame message: 'Tests failed, see the console.' title: 'Test All' type: 0 ].
!
fileInClass
	| fileChooser fileName |
	fileChooser := FileChooser new extensionFilter: 'Smallltalk files' extensions: #( 'st' ).
	fileName := fileChooser showOpenDialog: frame.
	fileName ifNil: [ ^ nil ].
	ClassParser fileIn: fileName.
	OptionPane showMessageDialogOn: frame message: 'Succesfully filed in: ' + fileName title: 'File In Class' type: 1.
	self loadFolders.
!
deleteClass
	| confirmed className |
	selectedClass ifNil: [
		OptionPane showMessageDialogOn: frame message: 'No class selected.' title: 'Delete Class' type: 0.
		^ nil ].

	className := selectedClass name.
	confirmed := OptionPane showConfirmDialogOn: frame message: 'Are you sure you want to delete class: ' + className + '?' title: 'Deleting class' option: 2.
	confirmed ifTrue: [
		Class removeClass: className.
		self loadClasses ].
!
