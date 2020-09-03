CLASS Object subclass: 'ClassParser' variables: 'file lineNum' classVariables: ''
	"Parse class from source file"
META fileIn: fileName
	^ self new fileIn: fileName.
!
META fileInAll
	"File-in (update) all known classes from their source files."
	Class classes do: [ :class |
		self fileIn: class sourceFileName ].
!
METHOD error: message
	"Report parse error with some added info."
	super error: 'Class.fileIn: Line: ' + lineNum + ', error: ' + message.
!
METHOD fileIn: fileName
	| line class classMethods instanceMethods method |
	"File-in the argument Smaltalk class.
	 Raises error on parse failure."
	System out println: 'ClassParser.FileIn: ' + fileName.

	lineNum <- 0.
	file <- File openRead: fileName.

	class <- self parseClass: self readLine.
	class sourceFileName: fileName.

	classMethods <- Ordered new: [ :a :b | a name < b name ].
	instanceMethods <- Ordered new: [ :a :b | a name < b name ].

	[ ( line <- self readLine ) = nil ] whileFalse: [
		method <- self parseMethod: line type: 'META' class: class class.
		method ifNotNil: [ classMethods add: method ].

		method <- self parseMethod: line type: 'METHOD' class: class.
		method ifNotNil: [ instanceMethods add: method ] ].

	"Set class methods to only those that were filed-in, removing others.
	 Removing methods afterwards like this is needed to enable filing-in critical base- and compiler classes."
	class class methods: classMethods asArray.
	class methods: instanceMethods asArray.
!
METHOD parseClass: line
	"Parse the CLASS <class creation expression> line.
	 This should be in the first line in the file.
	 Raise error if parsing fails."
	| keyword |
	keyword <- 'CLASS'.
	( line isNil or: [ ( line from: 1 to: keyword size ) ~= keyword ] ) ifTrue: [
		self error: 'CLASS keyword not found on start of first line' ].

	^ ( line from: keyword size + 1 to: line size ) doIt.
!
METHOD parseMethod: line type: type class: class
	"Try to parse [ META | METHOD ] < method name and args > \n <method source> !.
	 Return true on succesful parse, false otherwise."
	| methodLineNum methodHeader method |
	( line from: 1 to: type size ) = type ifFalse: [ ^ nil ].
	methodLineNum <- lineNum.
	methodHeader <- ( line from: type size + 1 to: line size ) trim + Char newline asString.
	method <- class compileMethod: ( methodHeader + self readMethodBody ).
	method lineNum: methodLineNum.
	^ method.
!
METHOD readMethodBody
	"Read method source upto next '!' line."
	| newline methodSource line |
	newline <- Char newline asString.
	methodSource <- ''.
	[ ( line <- self readLine ) = nil ] whileFalse: [
		line = '!' ifTrue: [ ^ methodSource ].
		methodSource <- methodSource + line + newline ].

	self error: 'Failed to find method end marker: "!"'.
!
METHOD readLine
	"Read next line from file, increasing line number.
	 Return nil on end of file."
	| line |
	line <- file readLine.
	line ifNil: [ ^ nil ].
	lineNum <- lineNum + 1.
	^ line.
!
