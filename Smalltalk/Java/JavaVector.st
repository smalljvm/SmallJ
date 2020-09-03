CLASS JavaObject subclass: 'JavaVector' variables: '' classVariables: ''
	"Implements java.util.Vector.
	 Used for conversion of Smalltalk connections to this class, for use with FFI."
META from: array
	"Create a new instance of self with elements from argument array added to it."
	|  javaVector |
	javaVector <- < 37 self 'java.util.Vector' ( array size ) >.
	array do: [ :element |
		javaVector add: element ].
	^ javaVector.
!
METHOD add: element			
	"public boolean add( E element )
	 return value is always true."
	< 38 nil self 'add' element >.
!
