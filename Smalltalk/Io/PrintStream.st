CLASS JavaObject subclass: 'PrintStream' variables: '' classVariables: ''
METHODS
print: object
	"public void print( String s )"
	< 38 nil self 'print' ( object printString ) >.
!
println: object
	"public void println( String s )"
	< 38 nil self 'println' ( object printString ) >.
!
