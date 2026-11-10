CLASS TestCase subclass: 'TestPrintStream' variables: '' classVariables: ''
	"Unit tests for PrintStream.
	 Prints to a java.io.ByteArrayOutputStream, so the output can be checked.
	 Run with: TestPrintStream run"
METHODS
testPrint
	| bytes stream |
	bytes := < 37 JavaObject 'java.io.ByteArrayOutputStream' >.
	stream := < 37 PrintStream 'java.io.PrintStream' bytes >.
	stream print: 'a'.
	stream print: 12.
	stream print: nil.
	self assert: < 38 String bytes 'toString' > = 'a12nil'.
!
testPrintln
	| bytes stream |
	bytes := < 37 JavaObject 'java.io.ByteArrayOutputStream' >.
	stream := < 37 PrintStream 'java.io.PrintStream' bytes >.
	stream println: 'a'.
	self assert: ( < 38 String bytes 'toString' > at: 1 ) = $a.
	self assert: ( < 38 String bytes 'toString' > find: 'a' ) = 1.
	self assert: < 38 String bytes 'toString' > size > 1.
!
