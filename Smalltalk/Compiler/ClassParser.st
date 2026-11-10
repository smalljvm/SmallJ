CLASS Object subclass: 'ClassParser' variables: 'file lineNum' classVariables: ''
	"Parse class from source file"
CLASSMETHODS
fileIn: fileName
	^ self new fileIn: fileName.
!
fileInAll
	"File-in (update) all known classes from their source files.
	 Then file-in the other source files in the current working folder and its subfolders, which define new classes."
	| knownFileNames |
	Class classes do: [ :class |
		self fileIn: class sourceFileName ].
	knownFileNames := Class classes collect: [ :class | class sourceFileName ].
	( File sourceFileNamesIn: '' ) do: [ :fileName |
		( knownFileNames includes: fileName ) ifFalse: [
			self fileIn: fileName ] ].
!
METHODS
error: message
	"Report parse error with some added info."
	super error: 'Class.fileIn: Line: ' + lineNum + ', error: ' + message.
!
fileIn: fileName
	| line trimmedLine class classMethods instanceMethods methodClass methods |
	"File-in the argument Smalltalk class. Raises error on parse failure.
	 Source file format:
	 - The first line is the CLASS line, with the class creation expression.
	 - Following lines, upto the first keyword line, are the class comment.
	 - Keyword line CLASSMETHODS starts class methods, keyword line METHODS starts instance methods.
	 - Each method is a header line with the method name and arguments, then the method body,
	   ending with a line containing only an exclamation mark.
	 - Blank lines between methods are skipped."
	System out println: 'ClassParser.FileIn: ' + fileName.

	lineNum := 0.
	file := File openRead: fileName.

	class := self parseClass: self readLine.
	class sourceFileName: fileName.

	classMethods := Ordered new: [ :a :b | a name < b name ].
	instanceMethods := Ordered new: [ :a :b | a name < b name ].

	[ ( line := self readLine ) = nil ] whileFalse: [
		trimmedLine := line trim.
		trimmedLine = 'CLASSMETHODS'
			ifTrue: [ methodClass := class class. methods := classMethods ]
			ifFalse: [
				trimmedLine = 'METHODS'
					ifTrue: [ methodClass := class. methods := instanceMethods ]
					ifFalse: [
						( methods notNil and: [ trimmedLine size > 0 ] ) ifTrue: [
							methods add: ( self parseMethod: trimmedLine class: methodClass ) ] ] ] ].

	"Set class methods to only those that were filed-in, removing others.
	 Removing methods afterwards like this is needed to enable filing-in critical base- and compiler classes."
	class class methods: classMethods asArray.
	class methods: instanceMethods asArray.
!
parseClass: line
	"Parse the CLASS <class creation expression> line.
	 This should be in the first line in the file.
	 Raise error if parsing fails."
	| keyword |
	keyword := 'CLASS'.
	( line isNil or: [ ( line from: 1 to: keyword size ) ~= keyword ] ) ifTrue: [
		self error: 'CLASS keyword not found on start of first line' ].

	^ ( line from: keyword size + 1 to: line size ) doIt.
!
parseMethod: header class: class
	"Parse method with argument header line < method name and args >,
	 followed by the method body read upto the end marker line.
	 Return the new method. Raise error on failure."
	| methodLineNum method |
	methodLineNum := lineNum.
	method := class compileMethod: header + Char newline asString + self readMethodBody.
	method lineNum: methodLineNum.
	^ method.
!
readMethodBody
	"Read method source upto next '!' line."
	| newline methodSource line |
	newline := Char newline asString.
	methodSource := ''.
	[ ( line := self readLine ) = nil ] whileFalse: [
		line = '!' ifTrue: [ ^ methodSource ].
		methodSource := methodSource + line + newline ].

	self error: 'Failed to find method end marker: "!"'.
!
readLine
	"Read next line from file, increasing line number.
	 Return nil on end of file."
	| line |
	line := file readLine.
	line ifNil: [ ^ nil ].
	lineNum := lineNum + 1.
	^ line.
!
