CLASS TestCase subclass: 'TestClassParser' variables: '' classVariables: ''
	"Unit tests for ClassParser, the file-in of class source files.
	 Files in a temporary source file with a new class, which is removed again afterwards.
	 Not tested: parse errors, which open the debugger.
	 Run with: TestClassParser run"
METHODS
tempFileName
	"Return the name of a file in the temporary folder of Java."
	^ ( File forwardSlashes: < 39 String 'java.lang.System' 'getProperty' 'java.io.tmpdir' > ) + '/SmallJTestParsedClass.st'.
!
writeSource
	"Write the source file of class TestParsedClass to the temporary file."
	| newline file |
	newline := Char newline asString.
	file := File openWrite: self tempFileName.
	file write: 'CLASS Object subclass: ''TestParsedClass'' variables: ''count'' classVariables: '''''  + newline.
	file write: '	"A class comment, which is skipped."' + newline.
	file write: 'CLASSMETHODS' + newline.
	file write: 'answer' + newline + '	^ 42.' + newline + '!' + newline.
	file write: 'METHODS' + newline.
	file write: newline.
	file write: 'count' + newline + '	^ count.' + newline + '!' + newline.
	file write: 'count: aCount' + newline + '	count := aCount.' + newline + '!' + newline.
	file close.
!
testFileIn
	| parsedClass instance |
	self writeSource.
	ClassParser fileIn: self tempFileName.
	parsedClass := Class at: 'TestParsedClass' ifAbsent: [ nil ].
	self assert: parsedClass notNil.
	self assert: parsedClass superclass == Object.
	self assert: parsedClass sourceFileName = self tempFileName.
	self assert: ( parsedClass variables includes: 'count' ).
	self assert: parsedClass methods size = 2.
	self assert: parsedClass class methods size = 1.
	"Methods are sorted by name. The header of method count is on line 9."
	self assert: parsedClass methods first name = 'count'.
	self assert: parsedClass methods first lineNum = 9.

	self assert: parsedClass answer = 42.
	instance := parsedClass new.
	instance count: 3.
	self assert: instance count = 3.

	Class removeClass: 'TestParsedClass'.
	self assert: ( Class at: 'TestParsedClass' ifAbsent: [ nil ] ) isNil.
	( File name: self tempFileName ) delete.
!
