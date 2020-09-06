CLASS Object subclass: 'File' variables: '' classVariables: ''.
	"Implements:
	 	java.io.File for file constants.
	 	java.io.PrintStream for writing a file
	 	java.io.DataInputStream for reading it."
META name: fileName
	^ < 37 File 'java.io.File' fileName >.
!
META openRead: fileName
	"Open fileName for reading using DataInputStream class in Java"
	| fileInputStream |
	fileInputStream <- < 37 File 'java.io.FileInputStream' fileName >.
	^ < 37 File 'java.io.DataInputStream' fileInputStream >
!
META openWrite: fileName
	"Open fileName for writing using the PrintStream class in Java."
	| fileOutputStream |
	fileOutputStream <- < 37 File 'java.io.FileOutputStream' fileName >.
	^ < 37 File 'java.io.PrintStream' fileOutputStream >
!
META separatorChar
	"static final char separatorChar"
	^ Char new: < 41 Char 'java.io.File' 'separatorChar' >.
!
METHOD name
	"String getName()"
	^ < 38 String self 'getName' >.
!
METHOD path
	"String getPath()"
	^ < 38 String self 'getPath' >.
!
METHOD relativePath
	"Return relative path to file from current working folder, if possible.
	 Otherwise return absolute path."
	| basePath path |
	basePath <- System currentDirectoryName.
	path <- self path.
	( basePath from: 1 to: basePath size ) = ( path from: 1 to: basePath size ) ifFalse: [ ^ path ].
	^ path from: basePath size + 2 to: path size.
!
METHOD readLine
	"Read next text line form file.
	 Return nil on end-of-file."
	^ < 38 String self 'readLine' >.
!
METHOD asString
	"Read all the lines in file file and return them as a single string."
	| newline result line |
	newline <- Char newline asString.
	result <- ''.
	[ ( line <- self readLine ) = nil ] whileFalse: [
		result <- result + line + newline ].
	^ result.
!
METHOD write: aString
	< 38 nil self 'print' aString >.
!
METHOD lastModified
	"long lastModified()"
	^ < 38 SmallLong self 'lastModified' >.
!
METHOD close
	"void close(). File should be output stream."
	^ < 38 nil self 'close' >.
!