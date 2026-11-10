CLASS TestCase subclass: 'TestFileChooser' variables: '' classVariables: ''
	"Unit tests for FileChooser, without showing its dialog.
	 Not tested: showOpenDialog:, which is a modal dialog.
	 Run with: TestFileChooser run"
METHODS
testCurrentDirectory
	| chooser directory |
	chooser := FileChooser new.
	directory := < 38 File chooser 'getCurrentDirectory' >.
	"The default is the current working folder, the Smalltalk folder."
	self assert: directory name = 'Smalltalk'.
	chooser currentDirectory: 'Base'.
	directory := < 38 File chooser 'getCurrentDirectory' >.
	self assert: directory name = 'Base'.
!
testExtensionFilter
	| chooser filter |
	chooser := FileChooser new.
	chooser extensionFilter: 'Smalltalk files' extensions: #( 'st' ).
	filter := < 38 JavaObject chooser 'getFileFilter' >.
	self assert: < 38 String filter 'getDescription' > = 'Smalltalk files'.
!
