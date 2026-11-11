# Foreign Function Interface (FFI) to Java
SmallJ has a set of primitives dedicated to accessing Java language items
(classes, methods and fields) dynamically, that is, at runtime by name.
Return values of the FFI calls can be associated with a Smalltalk class,
or nil is specified if the return type is void or the value is to be ignored.

## Basic FFI primitives

	#37 - javaObjectNew
		Purpose: Invoke class constructor.
		Syntax:  < 37 smalltalkClass javaClassName [ arg1 arg2 ... ] >
		Example: < 37 Color 'java.awt.Color' red green blue >

	#38 - javaObjectInvokeMethod
		Purpose: Invoke method on object.
		Syntax:  < 38 returnClass smallJavaObject javaMethodName [ arg1 arg2 ... ] >
		Example: < 38 String aTextComponent 'getText' >

	#39 - javaClassInvokeStaticMethod
		Purpose: Invoke static method on class.
		Syntax:  < 39 returnClass javaClassName javaMethodName [ arg1 arg2 ... ] >
		Example: < 39 Float 'java.lang.Math' 'sqrt' aFloat >

## Smalltalk <-> Java type conversion
Smalltalk arguments to these function calls are converted to Java types as follows:

	Smalltalk -> Java
	==================
	nil -> null
	true -> Boolean / boolean
	false -> Boolean / boolean
	SmallInt -> Integer / int
	SmallLong -> Long / long
	String -> String
	Float -> Double / double
	JavaObject (and subclasses) -> the Java object it wraps

Any other Smalltalk object can't be passed to Java: the primitive fails with the error
"smalltalkToJava: Invalid parameter".

Java return values are converted back to Smalltalk as follows:

	Java -> Smalltalk
	==================
	null -> nil
	Boolean -> true / false
	Integer -> SmallInt
	Long -> SmallLong
	String -> String
	Double -> Float
	Character -> SmallInt (the character code)
	<other objects> -> a new instance of returnClass, wrapping the Java object

If returnClass is nil, the Java return value is ignored and nil is returned.

## FFI primitives with typed arguments

Sometimes it is necessary to 'cast' Java arguments to specific types
to match the arguments of a specific (overloaded) function.
For this reason the primitives 37, 38 and 39 also have a typed version.
In these, each argument is preceded by the name of its desired (cast) Java type.
These are:

	#43 - javaObjectNewTyped
		Syntax:  < 43 smalltalkClass javaClassName [ argType1 argValue1 argType2 argValue2 ... ] >
		Example: < 43 JavaObject 'javax.swing.tree.DefaultTreeModel' 'javax.swing.tree.TreeNode' rootNode >

	#44 - javaObjectInvokeMethodTyped
		Syntax:  < 44 returnClass smallJavaObject javaMethodName [ argType1 argValue1 argType2 argValue2 ... ] >
		Example: < 44 nil aTable 'setDefaultEditor' 'java.lang.Class' columnClass 'javax.swing.DefaultCellEditor' nil >

	#45 - javaClassInvokeStaticMethodTyped
		Syntax:  < 45 returnClass javaClassName javaMethodName [ argType1 argValue1 argType2 argValue2 ... ] >
		Example: < 45 nil 'javax.swing.JOptionPane' 'showMessageDialog' 'java.awt.Component' nil 'java.lang.Object' message >

The Smalltalk class JavaArray can be used to pass an array of objects to a Java function.
It wraps a Java array, created with the Java class 'java.lang.reflect.Array'.

	Example: < 38 nil aListComponent 'setListData' ( JavaArray from: listData ) >

Use JavaArray from: array type: 'java.lang.String' to create an array with a specific element type.

## Accessing field variables

There are also primitives for accessing fields (variables) in classes and objects:

	#40 - javaObjectReadField
		Purpose: Read a field (variable) from an object.
		Syntax:  < 40 returnClass javaObject javaFieldName >
		Example: < 40 SmallInt aPoint 'x' >

	#41 - javaClassReadStaticField
		Purpose: Read a static field (variable) from a class.
		Syntax:  < 41 returnClass javaClassName javaFieldName >
		Example: < 41 JavaObject 'java.lang.System' 'in' >

## Loading a Java class

If you need to access a Java class as an object, you can use this primitive:

	#46 - javaLoadClass
		Purpose: Load a Java class, and return it as an instance of returnClass.
		Syntax:  < 46 returnClass javaClassName >
		Example: javaObjectClass := < 46 JavaObject 'java.lang.Object' >.

## Handling Java events

And finally, Java events can be handled by Smalltalk blocks:

	#42 - javaAddEventListener
		Purpose: Add a listener to a Java object, which evaluates a block when the event occurs.
		Syntax:  < 42 javaObject eventType block eventClass >
		Example: < 42 aButton 2 [ :event | ... ] ActionEvent >

When the event occurs, the Java event object is wrapped in a new instance of eventClass,
and the block is evaluated with it as its argument, in a new thread.
The event types are:

	1 - window closing (on a JFrame; also disables the default close operation)
	2 - action (button press, menu selection)
	3 - adjustment (scrollbar)
	4 - mouse pressed
	5 - mouse released
	6 - mouse moved or dragged
	7 - list selection
	8 - mouse clicked
	9 - tree selection

## Final thoughts

Of course, these primitives are not very type safe and it is easy to make mistakes in their syntax,
which will cause exception errors in the VM.
That's why it is recommended to implement every Java FFI call *only once*,
in a Smalltalk method that matches the Java function name,
in a class that matches the Java class name.
After that, you can safely use the Smalltalk method and forget about the primitive.
