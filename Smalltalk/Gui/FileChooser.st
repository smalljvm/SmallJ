CLASS Component subclass: 'FileChooser' variables: '' classVariables: ''
	"Implements Java javax.swing.JFileChooser"
META new
	^ < 37 self 'javax.swing.JFileChooser' > setToCurrentDirectory.
!
METHOD extensionFilter: description extensions: extensions
	"Sets the extensions to be selected.
	 Extensions shoud be a string collection of size >= 2, containing a description string and the extension names, like 'st'"
	| extensionFilter  |
	"FileNameExtensionFilter( String description, String... extensions )"
	extensionFilter <- < 37 JavaObject 'javax.swing.filechooser.FileNameExtensionFilter' description ( JavaArray from: extensions type: 'java.lang.String' ) >.
	"void setFileFilter( FileFilter filter )"
	< 38 nil self 'setFileFilter' extensionFilter >.
!
METHOD showOpenDialog: parent
	"Shows open dialog and return filename selected of nil if none."
	| option file |
	"int showOpenDialog( Component parent )
	 Returns: 0 = APPROVE_OPTION, 1 = CANCEL_OPTION, -1 = ERROR_OPTION"
	option <- < 38 SmallInt self 'showOpenDialog' parent >.
	option = 0 ifFalse: [ ^ nil ].

	"File getSelectedFile()"
	file <- < 38 File self 'getSelectedFile' >.
	^ file relativePath.
!
METHOD setToCurrentDirectory
	"Set file chooser to current working directory.
	 This is the default behavior."
	self currentDirectory: System currentDirectoryName.
!
METHOD currentDirectory: directoryName
	"void setCurrentDirectory( File directory )"
	< 38 nil self 'setCurrentDirectory' ( File name: directoryName ) >
!
