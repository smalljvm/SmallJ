CLASS JavaObject subclass: 'JavaArray' variables: '' classVariables: ''
	"Implements java.lang.reflect.Array.
	 Used for conversion of Smalltalk connections to this class, for use with FFI."
META from: array
	"Return Java Object[] array with elements from argument."
	^ self from: array type: 'java.lang.Object'.
!
META from: array type: type
	"Return Java <type>[] array with elements from array argument."
	| javaClass javaArray |
	javaClass := < 46 JavaObject type >.
	"static Object newInstance( Class<?> elementType, int length )"
	javaArray := < 39 self 'java.lang.reflect.Array' 'newInstance' javaClass ( array size ) >.
	1 to: array size do: [ :index |
		"static void set( Object array, int index, Object value )"
		self in: javaArray at: index - 1 put: ( array at: index ) ].
	^ javaArray.
!
META in: array at: index put: object
	"static void set( Object array, int index, Object value )"
	< 39 nil 'java.lang.reflect.Array' 'set' array index object >.
!
