CLASS JavaObject subclass: 'JavaArray' variables: '' classVariables: ''
	"Implements java.lang.reflect.Array.
	 Used for conversion of Smalltalk connections to this class, for use with FFI."
CLASSMETHODS
from: array
	"Return Java Object[] array with elements from argument."
	^ self from: array type: 'java.lang.Object'.
!
from: array type: type
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
in: array at: index class: elementClass
	"static Object get( Object array, int index )
	 index is 0-based. The element is converted to elementClass."
	^ < 39 elementClass 'java.lang.reflect.Array' 'get' array index >.
!
in: array at: index put: object
	"static void set( Object array, int index, Object value )"
	< 39 nil 'java.lang.reflect.Array' 'set' array index object >.
!
sizeOf: array
	"static int getLength( Object array )"
	^ < 39 SmallInt 'java.lang.reflect.Array' 'getLength' array >.
!
toArray: javaArray class: elementClass
	"Return a Smalltalk Array with the elements of javaArray, converted to elementClass.
	 Return an empty Array if javaArray is nil."
	| length array |
	javaArray isNil ifTrue: [ ^ Array new: 0 ].
	length := self sizeOf: javaArray.
	array := Array new: length.
	1 to: length do: [ :index |
		array at: index put: ( self in: javaArray at: index - 1 class: elementClass ) ].
	^ array.
!
