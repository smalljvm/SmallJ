

# Foreign Function Interface (FFI) to Java
SmallJ has as a set of primitives dedicated for acessing Java laguage items
classes, methods and field dynamiclly, so called at runtime by name.
Return values of the FFI calls can be associated with a Smalltalk object,
or nil is specifield if return type is void or the value is to be ignored.

## Basic FFI primitives

	#37 - javaObjectNew
		Propose: Invoke class contructor.
		Syntax:  < 37 smalltalkClass javaClassName [ arg1 arg2 ... ] >
		Example: < 37 Color 'java.awt.Color' red green blue >

	#38 - javaObjectInvokeMethod
		Propose: Invoke method on object.
		Syntax: < 38 returnClass smallJavaObject javaMethodName [ arg1 arg2 ... ] >
		Example: < 38 String aTextComponent 'getText' >

	#39 - javaClassInvokeStaticMethod
		Propose: Invoke static method on class.
		Syntax: < 39 returnClass javaClassName javaMethodName [ arg1 arg2 ... ] >
		Example: < 39 Float 'java.lang.Math' 'sqrt' anInteger >.

## Smalltalk <-> Java type conversion
Smalltalk arguments to these function calls are converted to java types as follows:

	SmallTalk -> Java
	==================
	nil -> null
	true -> True / true
	false -> False / false
	SmallInt -> Integer / int
	String -> String
	Float -> Double / double
	<other objects> -> Object.

For converting Java return types back to Smalltalk, the conversions are reversed.

## FFI primitives with typed arguments

Sometimes it is necessary to 'cast' Java arguments to specific types
to match it to match the arguments of a specific (overloaded) function.
For this reason there the primitives 37, 38 and 39 also have a typed version.
Then each argument is preceded by the desired (cast) type of the argument.
These are:

	#43 - javaObjectNewTyped
		Syntax: < 43 smalltalkClass javaClassName [ argType1 argValue1 argType2 argValue2 ... ] >
		Example: < todo >

	#44 - javaObjectInvokeMethodTyped
		Syntax: < 44 returnClass smallJavaObject javaMethodName [ argType1 argValue1 argType2 argValue2 ... ] >
		Example: < todo >

	#45 - javaClassInvokeStaticMethodTyped
		Syntax: < 45 returnClass javaClassName javaMethodName [ argType1 argValue1 argType2 argValue2 ... ] >
		Example: < 45 String 'javax.swing.JOptionPane' 'showMessageDialog' 'java.awt.Component' nil 'java.lang.String' message >

The smalltalk class JavaArray can be used to pass an array of objects to a Java function,
as it implements the Java class 'java.lang.reflect.Array'.
	Example: < 38 nil aListComponent 'setListData' ( JavaArray fromArray: listData ) >

## Accessing field variables

There are also primitives for accessing fields (variables) in classes and objects:

	#40 - javaObjectReadField
		Propose: Read a field (variable) from an object.
		Syntax: < 40 returnClass javaObject javaFieldName >
		Example: < todo >

	#41 - javaClassReadStaticField
		Propose: Read a static field (variable) from a class.
		Syntax: < 41 returnClass javaClassName javaFieldName >
		Example: < 41 JavaObject 'java.lang.System' 'in' >

## Loading a Java class

And finally, if you need to acces a Java class as an oject, you can use this primtive:

	#46 - javaLoadClass
		Syntax: < 46 returnClass javaClassName >
		Example: javaObjectClass := < 46 JavaObject 'java.lang.Object' >.

## Final thoughts

Of course, these primitives are not very type safe and it is easy to make mistakes in their syntax,
that will cause exception errors in the VM.
That's why it is recommended to only implement every Java FFI call *only once*,
in a Smalltalk method that matches the Java function name,
that is a class that matches the Java class name.
After that, you can safely use the Smalltalk method and forget about the primitive.
