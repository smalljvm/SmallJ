CLASS TestCase subclass: 'TestFile' variables: '' classVariables: ''
	"Unit tests for File.
	 Uses a temporary file in the temporary folder of Java, which is deleted afterwards.
	 Run with: TestFile run"
METHODS
tempFileName
	"Return the name of a file in the temporary folder of Java."
	^ ( File forwardSlashes: < 39 String 'java.lang.System' 'getProperty' 'java.io.tmpdir' > ) + '/SmallJTestFile.txt'.
!
testFileNamesIn
	self assert: ( ( File fileNamesIn: 'Base' ) includes: 'Base/Object.st' ).
	self assert: ( ( File fileNamesIn: 'Base' ) includes: 'Base/Test' ).
	self assert: ( ( File fileNamesIn: '' ) includes: 'Base' ).
!
testFolderNamesIn
	self assert: ( ( File folderNamesIn: '' ) includes: 'Base' ).
	self assert: ( ( File folderNamesIn: 'Base' ) includes: 'Base/Test' ).
	self assert: ( ( File folderNamesIn: 'Base' ) includes: 'Base/Object.st' ) not.
!
testForwardSlashes
	self assert: ( File forwardSlashes: 'a\b\c.st' ) = 'a/b/c.st'.
	self assert: ( File forwardSlashes: 'a/b' ) = 'a/b'.
!
testProperties
	| file |
	file := File name: 'Base/Object.st'.
	self assert: file exists.
	self assert: file canRead.
	self assert: file isDirectory not.
	self assert: file name = 'Object.st'.
	self assert: ( File name: 'Base' ) isDirectory.
	self assert: ( File name: 'NoSuchFile.st' ) exists not.
	self assert: ( file lastModified isKindOf: SmallLong ).
!
testList
	self assert: ( ( File name: 'Base' ) list includes: 'Object.st' ).
	self assert: ( File name: 'Base/Object.st' ) list isEmpty.
!
testRelativePath
	| file |
	file := File name: System currentDirectoryName + '/Base'.
	self assert: file relativePath = 'Base'.
!
testSourceFileNamesIn
	| fileNames |
	fileNames := File sourceFileNamesIn: 'Base'.
	self assert: ( fileNames includes: 'Base/Object.st' ).
	self assert: ( fileNames includes: 'Base/Test/TestFile.st' ) not.
	self assert: ( fileNames includes: 'Base/Test/TestObject.st' ).
!
testWriteRead
	| file contents |
	file := File openWrite: self tempFileName.
	file write: 'line 1' + Char newline asString + 'line 2' + Char newline asString.
	file close.

	file := File openRead: self tempFileName.
	self assert: file readLine = 'line 1'.
	self assert: file readLine = 'line 2'.
	self assert: file readLine isNil.
	file close.

	file := File openRead: self tempFileName.
	contents := file asString.
	file close.
	self assert: contents = ( 'line 1' + Char newline asString + 'line 2' + Char newline asString ).

	self assert: ( File name: self tempFileName ) delete.
	self assert: ( File name: self tempFileName ) exists not.
!
