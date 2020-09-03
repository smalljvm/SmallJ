CLASS Object subclass: 'SystemBrowser' variables: 'frame folderListComponent classListComponent methodTabbedPane instanceMethodListComponent classMethodListComponent sourceScrollPane sourceTextArea compileResultTextField expressionTextField evaluateResultTextField folders selectedFolder classes selectedClass selectedSource' classVariables: ''
META show
	^ self new show.
!
METHOD show
	self createFrame.
	self loadFolders.
	frame show.
!
METHOD createFrame
	| selectSourceSplitPane framePanel |

	"Splitter bar betweeen select panel and source panel."
	selectSourceSplitPane <- SplitPane new.
	selectSourceSplitPane orientation: SplitPane vertical.
	selectSourceSplitPane leftComponent: self createSelectPanel.	"top"
	selectSourceSplitPane rightComponent: self createSourcePanel.	"bottom"

	framePanel <- Panel new.
	framePanel layout: BorderLayout new.
	framePanel add: selectSourceSplitPane constraints: ( BorderLayout center ).
	framePanel add: self createEvaluatePanel constraints: ( BorderLayout south ).

	frame <- Frame new title: 'System Browser'.
	frame setSize: 800 @ 800.
	frame menuBar: self createMenuBar.
	frame onClosing: [ :windowEvent | self confirmExit ].
	frame add: framePanel.
!
METHOD createMenuBar
	| fileMenu classMenu menuBar |

	fileMenu <- Menu text: 'File'.
	fileMenu add: 'Save Image' action: [ :actionEvent | self saveImage ].
	fileMenu add: 'Exit' action: [ :actionEvent | self confirmExit ].

	classMenu <- Menu text: 'Class'.
	classMenu add: 'Compile All' action: [ :actionEvent | self compileAll ].
	classMenu add: 'File In' action: [ :actionEvent | self fileInClass ].
	classMenu add: 'Delete' action: [ :actionEvent | self deleteClass ].

	menuBar <- MenuBar new.
	menuBar add: fileMenu.
	menuBar add: classMenu.

	^ menuBar.
!
METHOD createSelectPanel
	"Initialize the folder, class, method selection panel. Sets member variables."
	| insets gbc00 gbc10 gbc20 selectPanel |

	insets <- Insets top: 4 left: 4 bottom: 4 right: 4.

	"Layouts for panels: Folder, Class and Method."
	gbc00 <- GridBagConstraints grid: 0 @ 0 size: 1 @ 1 weight: 1.0 @ 1.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints both )
		insets: insets ipad: 0 @ 0.
	gbc10 <- GridBagConstraints grid: 1 @ 0 size: 1 @ 1 weight: 1.0 @ 1.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints both )
		insets: insets ipad: 0 @ 0.
	gbc20 <- GridBagConstraints grid: 2 @ 0 size: 1 @ 1 weight: 1.0 @ 1.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints both )
		insets: insets ipad: 0 @ 0.

	selectPanel <- Panel new.
	selectPanel layout: GridBagLayout new.
	selectPanel add: self createFolderPanel constraints: gbc00.
	selectPanel add: self createClassPanel constraints: gbc10.
	selectPanel add: self createMethodPanel constraints: gbc20.

	^ selectPanel.
!
METHOD createFolderPanel
	| folderScrollPane |

	folderListComponent <- ListComponent new.
	folderListComponent onSelect: [ :listSelectionEvent | self onFolderSelected ].

	folderScrollPane <- ScrollPane view: folderListComponent.
	folderScrollPane border: ( Border createTitledBorder: 'Folder' ).
	^ folderScrollPane.
!
METHOD createClassPanel
	| classScrollPane |

	classListComponent <- ListComponent new.
	classListComponent onMouseClicked: [ :listSelectionEvent | self onClassSelected ].

	classScrollPane <- ScrollPane view: classListComponent.
	classScrollPane border: ( Border createTitledBorder: 'Class' ).
	^ classScrollPane.
!
METHOD createMethodPanel
	| instanceMethodScrollPane classMethodScrollPane |

	instanceMethodListComponent <- ListComponent new.
	instanceMethodListComponent onMouseClicked: [ :listSelectionEvent | self onInstanceMethodSelected ].
	instanceMethodScrollPane <- ScrollPane view: instanceMethodListComponent.

	classMethodListComponent <- ListComponent new.
	classMethodListComponent onMouseClicked: [ :listSelectionEvent | self onClassMethodSelected ].
	classMethodScrollPane <- ScrollPane view: classMethodListComponent.

	methodTabbedPane <- TabbedPane new.
	methodTabbedPane border: ( Border createTitledBorder: 'Method' ).
	methodTabbedPane addTab: 'Instance' component: instanceMethodScrollPane.
	methodTabbedPane addTab: 'Class' component: classMethodScrollPane.

	^ methodTabbedPane.
!
METHOD createSourcePanel
	"Initialize the source edit & compile panel. Sets member variables."
	| insets gbc00 gbc10 gbc20
	  sourcePanel compilePanel compileButton compileResultLabel |

	insets <- Insets top: 4 left: 4 bottom: 4 right: 4.

	sourceTextArea <- TextArea new.
	sourceTextArea tabSize: 2.
	sourceTextArea font: ( Font name: 'Consolas' style: 0 size: 12 ).

	sourceScrollPane <- ScrollPane view: sourceTextArea.

	compileButton <- Button new text: 'Save & Compile' action: [ :actionEvent | self saveAndCompile ].
	gbc00 <- GridBagConstraints grid: 0 @ 0 size: 1 @ 1 weight: 0.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints none )
		insets: insets ipad: 0 @ 0.

	compileResultLabel <- Label new text: 'Result'.
	gbc10 <- GridBagConstraints grid: 1 @ 0 size: 1 @ 1 weight: 0.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints none )
		insets: insets ipad: 0 @ 0.

	compileResultTextField <- TextField new.
	compileResultTextField background: ( Color red: 250 green: 250 blue: 250 ).
	compileResultTextField editable: false.
	gbc20 <- GridBagConstraints grid: 2 @ 0 size: 1 @ 1 weight: 1.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints horizontal )
		insets: insets ipad: 0 @ 0.

	compilePanel <- Panel new.
	compilePanel layout: GridBagLayout new.
	compilePanel add: compileButton constraints: gbc00.
	compilePanel add: compileResultLabel constraints: gbc10.
	compilePanel add: compileResultTextField constraints: gbc20.

	sourcePanel <- Panel new.
	sourcePanel layout: BorderLayout new.
	sourcePanel border: ( Border createTitledBorder: 'Source' ).
	sourcePanel add: sourceScrollPane constraints: BorderLayout center.
	sourcePanel add: compilePanel constraints: BorderLayout south.

	^ sourcePanel.
!
METHOD createEvaluatePanel
	"Initialize the expression evaluation & result panel. Sets member variables."
	| insets gbc00 gbc10 gbc20 gbc01 gbc11
	  evaluatePanel evaluateButton inspectButton evaluateResultLabel |

	insets <- Insets top: 4 left: 4 bottom: 4 right: 4.

	inspectButton <- Button new text: 'Inspect' action: [ :actionEvent | self onInspect ].
	gbc00 <- GridBagConstraints grid: 0 @ 0 size: 1 @ 1 weight: 0.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints none )
		insets: insets ipad: 0 @ 0.

	evaluateButton <- Button new text: 'Evaluate' action: [ :actionEvent | self evaluate ].
	gbc10 <- GridBagConstraints grid: 1 @ 0 size: 1 @ 1 weight: 0.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints none )
		insets: insets ipad: 0 @ 0.

	expressionTextField <- TextField new.
	gbc20 <- GridBagConstraints grid: 2 @ 0 size: 1 @ 1 weight: 1.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints horizontal )
		insets: insets ipad: 0 @ 0.

	evaluateResultLabel <- Label new text: 'Result'.
	evaluateResultLabel horizontalAlignment: 0.		"center"
	gbc01 <- GridBagConstraints grid: 0 @ 1 size: 1 @ 1 weight: 0.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints horizontal )
		insets: insets ipad: 0 @ 0.

	evaluateResultTextField <- TextField new.
	evaluateResultTextField background: ( Color red: 250 green: 250 blue: 250 ).
	evaluateResultTextField editable: false.
	gbc11 <- GridBagConstraints grid: 1 @ 1 size: 2 @ 1 weight: 1.0 @ 0.0
		anchor: ( GridBagConstraints west ) fill: ( GridBagConstraints horizontal )
		insets: insets ipad: 0 @ 0.

	evaluatePanel <- Panel new.
	evaluatePanel layout: GridBagLayout new.
	evaluatePanel border: ( Border createTitledBorder: 'Evaluate' ).
	evaluatePanel add: inspectButton constraints: gbc00.
	evaluatePanel add: evaluateButton constraints: gbc10.
	evaluatePanel add: expressionTextField constraints: gbc20.
	evaluatePanel add: evaluateResultLabel constraints: gbc01.
	evaluatePanel add: evaluateResultTextField constraints: gbc11.

	^ evaluatePanel.
!
METHOD loadFolders
	| folder |
	"Load unique folder names into folderListComponent component."
	folders <- Ordered new.
	Class classes do: [ :class |
		folder <- class sourceFolderName.
		( folders includes: folder ) ifFalse: [
			folders add: folder ] ].
	folderListComponent listData: folders.
	self clearSelectedFolder.
!
METHOD clearSelectedFolder
	selectedFolder <- nil.
	classListComponent listData: List new.
	self clearSelectedClass.
!
METHOD onFolderSelected
	"Set selected folder and load classes from it."
	selectedFolder <- folders at: ( folderListComponent selectedIndex ).
	self loadClasses.
!
METHOD loadClasses
	"Load classes for selected folder into classListComponent component."
	| classNames |
	classes <- Ordered new: [ :class1 :class2 | class1 name < class2 name ].
	Class classes do: [ :class |
		class sourceFolderName = selectedFolder ifTrue: [
			classes add: class ] ].
	classNames <- classes collect: [ :class | class name ].
	classListComponent listData: classNames.
	self clearSelectedClass.
!
METHOD clearSelectedClass
	selectedClass <- nil.
	instanceMethodListComponent listData: List new.
	classMethodListComponent listData: List new.
	sourceTextArea text: ''.
!
METHOD onClassSelected
	"Set selected class and load methods from it."
	selectedClass <- classes at: ( classListComponent selectedIndex ).
	self loadMethods.
	self loadSource.
	"Because of a bug in de Java framework (currently 14),
	 setting the caret position 0 does not scroll to the top text line.
	 So we first set it to 1 and then to 0."
	sourceTextArea caretPosition: 1.
	sourceTextArea caretPosition: 0.
	sourceTextArea requestFocus.
!
METHOD loadMethods
	"Load instance and class methods for the selected class."
	instanceMethodListComponent listData: selectedClass methods asStringArray.
	classMethodListComponent listData: selectedClass class methods asStringArray.
!
METHOD loadSource
	"Load source fom selected class into the source text area."
	selectedSource <- ( File openRead: selectedClass sourceFileName ) asString.
	sourceTextArea text: selectedSource.
!
METHOD onInstanceMethodSelected
	"Set cursor to line number of selected insctance method in source text area."
	self gotoMethodInSource: (
		selectedClass methods at:
			instanceMethodListComponent selectedIndex ).
!
METHOD onClassMethodSelected
	"Set cursor to line number of selected class method in source text area."
	self gotoMethodInSource: (
		selectedClass class methods at:
			classMethodListComponent selectedIndex ).
!
METHOD gotoMethodInSource: method
	"Place the cursor (caret) at the starting line of the method.
	 Make that line the top in the view of there is enough text behind it to fill the source pane."
	| textPosition viewPosition |
	textPosition <- sourceTextArea lineStartOffset: method lineNum.
	viewPosition <- sourceTextArea modelToView: textPosition.
	sourceTextArea requestFocus.
	sourceTextArea caretPosition: textPosition.
	sourceTextArea repaint.
	"NB: Setting the viewport must be done last, due to a drawing bug in the JVM."
	sourceScrollPane viewport viewPosition: viewPosition location.
!
METHOD saveAndCompile
	| file |
	"Save file if it is modified.
	 Then file it in from disk, just in case it was modified in an external editor like VSCode.
	 Then reload possible modified source into GUI."

	"Save source if it was changed."
	selectedSource = sourceTextArea text ifFalse: [
		selectedSource <- sourceTextArea text.
		file <- File openWrite: selectedClass sourceFileName.
		file write: selectedSource.
		file close ].

	"Reload & file-in source, possibly modified externally."
	self loadSource.
	"Must set default result to failed because compilation failure currently executes a thread halt."
	compileResultTextField text: ''.
	ClassParser fileIn: selectedClass sourceFileName.
	compileResultTextField text: 'Succeeded'.
	self loadMethods.
!
METHOD evaluate
	"Evaluate the expression in expressionTextField and show the result in evaluateResultTextField."
	| result |
	evaluateResultTextField text: ''.
	result <- expressionTextField text doIt.
	evaluateResultTextField text: result printString.
	^ result.
!
METHOD onInspect
	"Inspect the result of evaluatiing the expression (see evaluate)."
	Inspector show: self evaluate.
!
METHOD saveImage
	"Save image and show notification."
	System saveImage.
	OptionPane showMessageDialogOn: frame message: 'Image saved.' title: 'Save Image' type: 1.
!
METHOD confirmExit
	| answer |
	answer <- OptionPane showConfirmDialogOn: frame message: 'Save Image?' title: 'Exiting SmallJ' option: 1.
	answer ifTrue: [ System saveImage ].
	answer ifNotNil: [ frame close. System exit: 0 ].	"Yes or No, not Cancel."
!
METHOD compileAll
	ClassParser fileInAll.
	OptionPane showMessageDialogOn: frame message: 'All classes compiled succesfully.' title: 'Compile all classes' type: 1.
!
METHOD fileInClass
	| fileChooser fileName |
	fileChooser <- FileChooser new extensionFilter: 'Smallltalk files' extensions: #( 'st' ).
	fileName <- fileChooser showOpenDialog: frame.
	fileName ifNil: [ ^ nil ].
	ClassParser fileIn: fileName.
	OptionPane showMessageDialogOn: frame message: 'Succesfully filed in: ' + fileName title: 'File In Class' type: 1.
	self loadFolders.
!
METHOD deleteClass
	| confirmed className |
	selectedClass ifNil: [
		OptionPane showMessageDialogOn: frame message: 'No class selected.' title: 'Delete Class' type: 0.
		^ nil ].

	className <- selectedClass name.
	confirmed <- OptionPane showConfirmDialogOn: frame message: 'Are you sure you want to delete class: ' + className + '?' title: 'Deleting class' option: 2.
	confirmed ifTrue: [
		Class removeClass: className.
		self loadClasses ].
!
