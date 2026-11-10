CLASS Object subclass: 'File' variables: '' classVariables: ''.
	"Implements:
	 	java.io.File for file constants.
	 	java.io.PrintStream for writing a file
	 	java.io.DataInputStream for reading it."
CLASSMETHODS
name: fileName
	^ < 37 File 'java.io.File' fileName >.
!
fileNamesIn: folderName
	"Return the sorted names of the files and folders in folderName, as paths starting with folderName.
	 Use '' for the current working folder; the names are then relative to it.
	 Hidden files and folders, whose names start with a dot, are skipped."
	| folderFile names |
	folderFile := File name: ( folderName isEmpty ifTrue: [ '.' ] ifFalse: [ folderName ] ).
	names := ( folderFile list reject: [ :entry | ( entry at: 1 ) = $. ] ) asOrdered: [ :a :b | a < b ].
	folderName isEmpty ifTrue: [ ^ names asArray ].
	^ ( names collect: [ :fileName | folderName + '/' + fileName ] ) asArray.
!
folderNamesIn: folderName
	"Return the sorted names of the subfolders of folderName (see fileNamesIn:)."
	^ ( self fileNamesIn: folderName ) select: [ :fileName | ( File name: fileName ) isDirectory ].
!
forwardSlashes: fileName
	"Returns filename with Windows style backward slashes replaced with Unix style forward slashes."
	^ ( fileName collect: [ :char | char = $\ ifTrue: [ $/ ] ifFalse: [ char ] ] ) asString.
!
openRead: fileName
	"Open fileName for reading using DataInputStream class in Java"
	| file fileInputStream |
	( file := File name: fileName ) canRead ifFalse: [
		self error: 'Cannot open file for reading: ' + fileName ].

	fileInputStream := < 37 File 'java.io.FileInputStream' file >.
	^ < 37 File 'java.io.DataInputStream' fileInputStream >
!
openWrite: fileName
	"Open fileName for writing using the PrintStream class in Java.
	 A new file is created, an existing file is overwritten if it is writable."
	| file fileOutputStream |
	file := File name: fileName.
	( file exists and: [ file canWrite not ] ) ifTrue: [
		self error: 'Cannot open file for writing: ' + fileName ].
	fileOutputStream := < 37 File 'java.io.FileOutputStream' file >.
	^ < 37 File 'java.io.PrintStream' fileOutputStream >
!
sourceFileNamesIn: folderName
	"Return the names of all Smalltalk source files (*.st) in folderName and its subfolders (see fileNamesIn:)."
	| sourceFileNames |
	sourceFileNames := List new.
	( self fileNamesIn: folderName ) do: [ :fileName |
		( File name: fileName ) isDirectory
			ifTrue: [ sourceFileNames addAll: ( self sourceFileNamesIn: fileName ) ]
			ifFalse: [
				( fileName size > 3 and: [ ( fileName last: 3 ) = '.st' ] ) ifTrue: [
					sourceFileNames add: fileName ] ] ].
	^ sourceFileNames.
!
separatorChar
	"static final char separatorChar"
	^ Char new: < 41 Char 'java.io.File' 'separatorChar' >.
!
METHODS
canRead
	"boolean canRead()"
	^ < 38 Boolean self 'canRead' >.
!
canWrite
	"boolean canWrite()"
	^ < 38 Boolean self 'canWrite' >.
!
exists
	"boolean exists()"
	^ < 38 Boolean self 'exists' >.
!
delete
	"boolean delete()
	 Delete the file or empty folder. Return true if it was deleted."
	^ < 38 Boolean self 'delete' >.
!
isDirectory
	"boolean isDirectory()"
	^ < 38 Boolean self 'isDirectory' >.
!
list
	"String[] list()
	 Return an Array with the names of the files and folders in self, or an empty Array if self is not a folder."
	^ JavaArray toArray: < 38 JavaObject self 'list' > class: String.
!
name
	"String getName()"
	^ < 38 String self 'getName' >.
!
path
	"String getPath()"
	^ < 38 String self 'getPath' >.
!
relativePath
	"Return relative path to file from current working folder, if possible.
	 Otherwise return absolute path."
	| basePath path |
	basePath := System currentDirectoryName.
	path := self path.
	( basePath from: 1 to: basePath size ) = ( path from: 1 to: basePath size ) ifFalse: [ ^ path ].
	^ path from: basePath size + 2 to: path size.
!
readLine
	"Read next text line form file.
	 Return nil on end-of-file."
	^ < 38 String self 'readLine' >.
!
asString
	"Read all the lines in file file and return them as a single string."
	| newline result line |
	newline := Char newline asString.
	result := ''.
	[ ( line := self readLine ) = nil ] whileFalse: [
		result := result + line + newline ].
	^ result.
!
write: aString
	< 38 nil self 'print' aString >.
!
lastModified
	"long lastModified()"
	^ < 38 SmallLong self 'lastModified' >.
!
close
	"void close(). Self should be output stream."
	^ < 38 nil self 'close' >.
!
