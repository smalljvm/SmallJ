// Primitives of the interpreter, called from Smalltalk as < N args... > and dispatched from SmallOperations.doPrimitive() through the primitives table.
// Primitives pop their arguments from the current context of the interpreter and return their result.

class SmallPrimitives
{
	interface Primitive
	{
		SmallObject perform() throws SmallException;
	}

	SmallInterpreter interpreter;
	int argCount = 0;
	static final int maxPrimitive = 65;
	public Primitive[] primitives = new Primitive[ maxPrimitive + 1 ];

	SmallPrimitives( SmallInterpreter aInterpreter )
	{
		interpreter = aInterpreter;

		primitives[ 1 ] = this::objectEquals;
		primitives[ 2 ] = this::objectClass;
		primitives[ 3 ] = this::objectSetClass;
		primitives[ 4 ] = this::objectSize;
		primitives[ 5 ] = this::objectAtPut;
		primitives[ 6 ] = this::contextExecute;
		primitives[ 7 ] = this::objectNew;
		primitives[ 8 ] = this::blockInvoke;
		primitives[ 10 ] = this::intAdd;
		primitives[ 11 ] = this::intDivide;
		primitives[ 12 ] = this::intRemainder;
		primitives[ 13 ] = this::intLessThan;
		primitives[ 14 ] = this::intEquals;
		primitives[ 15 ] = this::intMultiply;
		primitives[ 16 ] = this::intSubtract;
		primitives[ 18 ] = this::objectAtPut;
		primitives[ 19 ] = this::blockFork;
		primitives[ 20 ] = this::byteArrayNew;
		primitives[ 21 ] = this::stringAt;
		primitives[ 22 ] = this::stringAtPut;
		primitives[ 23 ] = this::stringCopy;
		primitives[ 24 ] = this::stringAppend;
		primitives[ 25 ] = this::objectResize;
		primitives[ 26 ] = this::stringCompare;
		primitives[ 27 ] = this::imageFileName;
		primitives[ 29 ] = this::imageSave;
		primitives[ 30 ] = this::arrayAt;
		primitives[ 31 ] = this::arrayAdd;
		primitives[ 32 ] = this::objectAddToData;
		primitives[ 34 ] = this::threadKill;
		primitives[ 35 ] = this::contextCurrent;
		primitives[ 36 ] = this::arrayFastNew;
		primitives[ 37 ] = this::javaObjectNew;
		primitives[ 38 ] = this::javaObjectInvokeMethod;
		primitives[ 39 ] = this::javaClassInvokeStaticMethod;
		primitives[ 40 ] = this::javaObjectReadField;
		primitives[ 41 ] = this::javaClassReadStaticField;
		primitives[ 42 ] = this::javaAddEventListener;
		primitives[ 43 ] = this::javaObjectNewTyped;
		primitives[ 44 ] = this::javaObjectInvokeMethodTyped;
		primitives[ 45 ] = this::javaClassInvokeStaticMethodTyped;
		primitives[ 46 ] = this::javaLoadClass;
		primitives[ 47 ] = this::methodCompile;
		primitives[ 50 ] = this::floatFromSmallInt;
		primitives[ 51 ] = this::floatAdd;
		primitives[ 52 ] = this::floatSubtract;
		primitives[ 53 ] = this::floatMultiply;
		primitives[ 54 ] = this::floatDivide;
		primitives[ 55 ] = this::floatLessThan;
		primitives[ 56 ] = this::floatEquals;
		primitives[ 57 ] = this::floatAsInteger;
		primitives[ 58 ] = this::longAdd;
		primitives[ 59 ] = this::longDivide;
		primitives[ 60 ] = this::longRemainder;
		primitives[ 61 ] = this::longLessThan;
		primitives[ 62 ] = this::longEquals;
		primitives[ 63 ] = this::longMultiply;
		primitives[ 64 ] = this::longSubtract;
		primitives[ 65 ] = this::longNew;
	}

	// Execute primitive with argument number from the primitive

	SmallObject perform( int primitiveNum, int aArgCount )
			throws SmallException
	{
		if( primitiveNum < 1 || primitiveNum > maxPrimitive )
			throw new SmallException( "Unrecognized primitive: " + primitiveNum, interpreter.context );

		Primitive primitive = primitives[ primitiveNum ];
		if( primitive == null )
			throw new SmallException( "Unrecognized primitive: " + primitiveNum, interpreter.context );

		// The argument count is kept in a global variable and is not passed
		// because it is only used for primitives with a variable number of arguments.
		argCount = aArgCount;
		return primitive.perform();
	}

	// ============================================ All primitives below

	// < 1 self arg >

	SmallObject objectEquals()
	{
		SmallObject self = interpreter.context.stackPop();
		SmallObject argument = interpreter.context.stackPop();

		return argument == self ? interpreter.image.trueObject : interpreter.image.falseObject;
	}

	// < 2 self >

	SmallObject objectClass()
	{
		SmallObject self = interpreter.context.stackPop();

		return self.objClass;
	}

	// < 3 self class >
	// Set the class of an object.
	// Should normally not be necessary, put can be used to repair the image.

	SmallObject objectSetClass()
	{
		SmallObject newClass = interpreter.context.stackPop();
		SmallObject self = interpreter.context.stackPop();

		self.objClass = newClass;
		return self;
	}

	// < 4 self >
	// Return size of data members of self.

	SmallObject objectSize()
	{
		SmallObject self = interpreter.context.stackPop();
		int size;
		if( self instanceof SmallByteArray )
			size = ( ( SmallByteArray ) self ).values.length;
		else
			size = self.data.length;

		return interpreter.image.newInteger( size );
	}

	// < 25 self newSize >
	// Resize self to fit new size.
	// Should be called for instances when object class variable count is (possibly) modified.

	SmallObject objectResize()
	{
		int newSize = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		SmallObject self = interpreter.context.stackPop();

		self.resize( newSize );

		return self;
	}

	// < 18 self index value >

	SmallObject objectAtPut()
	{
		SmallObject value = interpreter.context.stackPop();
		int index = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		SmallObject self = interpreter.context.stackPop();

		self.data[ index - 1 ] = value;
		return self;
	}

	// < 6 self >

	SmallObject contextExecute()
			throws SmallException
	{
		SmallContext aContext = interpreter.context.castOrConvert( interpreter.context.stackPop() );

		return new SmallInterpreter( interpreter.image ).execute( aContext, interpreter.myThread, interpreter.parentThread );
	}

	// < 7 class size >

	SmallObject objectNew()
	{
		int size = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		SmallObject classObj = interpreter.context.stackPop();

		return new SmallObject( classObj, size );
	}

	// < 8 self > or < 8 arg1 self >  or < 8 arg1 arg2 self >
	// The stack order is non-standard here to be able to determine the variable number of arguments.

	SmallObject blockInvoke()
	{
		SmallBlock block = ( SmallBlock ) interpreter.context.stackPop();
		interpreter.context = block.invoke( argCount, interpreter.context );
		interpreter.context.setCachedValues();

		return block;
	}

	// ================================== Int

	// < 10 self arg >
	// Small integer addition.
	// Returns nil on overflow.
	// Todo: This is currently not used because additions are always done with large integers
	// Todo: Make optimized case for adding small integers.

	SmallObject intAdd()
	{
		int arg = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		int self = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		int sum = self + arg;
		long longSum = ( long ) self + ( long ) arg;

		if( sum != longSum )
			return interpreter.image.nilObject;     // Overflow.

		return interpreter.image.newInteger( sum );
	}

	// < 11 self arg >

	SmallObject intDivide()
	{
		int arg = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		int self = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		int quotient = self / arg;
		return interpreter.image.newInteger( quotient );
	}

	// < 12 self arg >

	SmallObject intRemainder()
	{
		int divider = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		int self = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		int remainder = self % divider;
		return interpreter.image.newInteger( remainder );
	}

	// < 13 self arg >
	// Note: This is currently not used because the compiler optimizes it in operation #11

	SmallObject intLessThan()
	{
		int arg = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		int self = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		return self < arg ? interpreter.image.trueObject : interpreter.image.falseObject;
	}

	// < 14 self arg >

	SmallObject intEquals()
	{
		int arg = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		int self = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		return self == arg ? interpreter.image.trueObject : interpreter.image.falseObject;
	}

	// < 15 self arg >
	// Returns nil on overflow.

	SmallObject intMultiply()
	{
		int arg = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		int self = ( ( SmallInt ) interpreter.context.stackPop() ).value;

		int product = self * arg;
		long longProduct = ( long ) self * ( long ) arg;
		if( product != longProduct )
			return interpreter.image.nilObject;         // Overflow

		return interpreter.image.newInteger( product );
	}

	// < 16 self arg >

	SmallObject intSubtract()
	{
		int arg = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		int self = ( ( SmallInt ) interpreter.context.stackPop() ).value;

		int subtraction = self - arg;
		long longSubtraction = ( long ) self - ( long ) arg;
		if( subtraction != longSubtraction )
			return interpreter.image.nilObject;        // Overflow

		return interpreter.image.newInteger( subtraction );
	}

	// ===================================== Long


	// < 58 self arg >
	// Long integer addition. Returns nil on overflow.

	SmallObject longAdd()
	{
		long arg = ( ( SmallLong ) interpreter.context.stackPop() ).value;
		long self = ( ( SmallLong ) interpreter.context.stackPop() ).value;

		long sum;
		try {
			sum = Math.addExact( self, arg );
		}
		catch( ArithmeticException e )
		{
			return interpreter.image.nilObject;     // Overflow.
		}

		return new SmallLong( interpreter.image.longClass, sum );
	}

	// < 59 self arg >

	SmallObject longDivide()
	{
		long arg = ( ( SmallLong ) interpreter.context.stackPop() ).value;
		long self = ( ( SmallLong ) interpreter.context.stackPop() ).value;

		long  quotient = self / arg;

		return new SmallLong( interpreter.image.longClass, quotient );
	}

	// < 60 self arg >

	SmallObject longRemainder()
	{
		long arg = ( ( SmallLong ) interpreter.context.stackPop() ).value;
		long self = ( ( SmallLong ) interpreter.context.stackPop() ).value;

		long remainder = self % arg;

		return new SmallLong( interpreter.image.longClass, remainder );
	}

	// < 61 self arg >
	// Note: This is currently not used because the compiler optimizes it in operation #11

	SmallObject longLessThan()
	{
		long arg = ( ( SmallLong ) interpreter.context.stackPop() ).value;
		long self = ( ( SmallLong ) interpreter.context.stackPop() ).value;

		return self < arg ? interpreter.image.trueObject : interpreter.image.falseObject;
	}

	// < 62 self arg >

	SmallObject longEquals()
	{
		long arg = ( ( SmallLong ) interpreter.context.stackPop() ).value;
		long self = ( ( SmallLong ) interpreter.context.stackPop() ).value;

		return self == arg ? interpreter.image.trueObject : interpreter.image.falseObject;
	}

	// < 63 self arg >
	// Returns nil on overflow.

	SmallObject longMultiply()
	{
		long arg = ( ( SmallLong ) interpreter.context.stackPop() ).value;
		long self = ( ( SmallLong ) interpreter.context.stackPop() ).value;

		long product;
		try {
			product = Math.multiplyExact( self, arg );
		}
		catch( ArithmeticException e )
		{
			return interpreter.image.nilObject;     // Overflow.
		}

		return new SmallLong( interpreter.image.longClass, product );
	}

	// < 64 self arg >

	SmallObject longSubtract()
	{
		long arg = ( ( SmallLong ) interpreter.context.stackPop() ).value;
		long self = ( ( SmallLong ) interpreter.context.stackPop() ).value;

		long subtraction;
		try {
			subtraction = Math.subtractExact( self, arg );
		}
		catch( ArithmeticException e )
		{
			return interpreter.image.nilObject;     // Underflow.
		}

		return new SmallLong( interpreter.image.longClass, subtraction );
	}

	// < 65 smallInt >
	// Return new Smalltalk long with value of smallInt.
	// So the range is limited for now. Should have compiler (SmallCompiler) support for longs.

	SmallObject longNew()
	{
		int value = ( ( SmallInt ) interpreter.context.stackPop() ).value;

		return interpreter.image.newLong( value );
	}

	// =========================================== Block

	// < 19 self >
	// Block may not have arguments

	SmallObject blockFork()
	{
		SmallObject self = interpreter.context.stackPop();
		new SmallThread( self, interpreter.myThread ).start();
		return self;
	}

	// < 20 arrayClass size >
	// arrayClass is ByteArray or String

	SmallObject byteArrayNew()
	{
		int size = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		SmallObject arrayClass = interpreter.context.stackPop();
		return new SmallByteArray( arrayClass, size );
	}

	// < 21 self index >

	SmallObject stringAt()
	{
		int index = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		SmallByteArray self = ( SmallByteArray ) interpreter.context.stackPop();
		int aChar = self.values[ index - 1 ] & 0xFF;
		return interpreter.image.newInteger( aChar );
	}

	// < 22 self index value >
	// Note: Self is returned, not the value.

	SmallObject stringAtPut()
	{
		byte value = ( byte ) ( ( ( SmallInt ) interpreter.context.stackPop() ).value & 0xFF );
		int index = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		SmallByteArray string = ( SmallByteArray ) interpreter.context.stackPop();

		string.values[ index - 1 ] = value;

		return string;
	}

	// < 23 self >

	SmallObject stringCopy()
	{
		SmallObject self = interpreter.context.stackPop();

		return self.copy( self.objClass );
	}

	// < 24 self arg >

	SmallObject stringAppend()
	{
		SmallByteArray arg = ( SmallByteArray ) interpreter.context.stackPop();
		SmallByteArray self = ( SmallByteArray ) interpreter.context.stackPop();
		int appendedSize = self.values.length + arg.values.length;
		SmallByteArray appendedString = new SmallByteArray( self.objClass, appendedSize );

		int selfLength = self.values.length;
		System.arraycopy( self.values, 0, appendedString.values, 0, selfLength );
		System.arraycopy( arg.values, 0, appendedString.values, selfLength, arg.values.length );

		return appendedString;
	}

	// < 26 self arg >
	// Return values: self < arg : -1, self == arg: 0, self > arg: 1.

	SmallObject stringCompare()
	{
		byte[] arg = ( ( SmallByteArray ) interpreter.context.stackPop() ).values;
		byte[] self = ( ( SmallByteArray ) interpreter.context.stackPop() ).values;

		int argLength = arg.length;
		int selfLength = self.length;

		int smallestLength = Math.min( selfLength, argLength );
		int result = 0;
		int index = 0;
		while( result == 0 && index < smallestLength ) {
			result = self[ index ] - arg[ index ];
			++ index;
		}

		if( result == 0 )                       // Are the strings equal up to now?
			result = selfLength - argLength;    // Then the longest one is the largest.

		result = result > 0 ? 1 : ( result < 0 ? - 1 : 0 );      // Compact result to: 1, -1 or 0.

		return interpreter.image.newInteger( result );
	}

	// < 27 >
	// Return the current SmallJ image file name as a string.

	SmallObject imageFileName()
	{
		return new SmallByteArray( interpreter.image.stringClass, String.valueOf( interpreter.image.fileName ) );
	}

	// < 29 fileName >

	SmallObject imageSave()
			throws SmallException
	{
		SmallByteArray smallFileName = ( SmallByteArray ) interpreter.context.stackPop();
		String fileName = smallFileName.toString();
		try {
			interpreter.image.saveAs( fileName );
		} catch( Exception e ) {
			throw new SmallException( "Error saving image: " + e, interpreter.context );
		}

		return smallFileName;
	}

	// < 30 self index >

	SmallObject arrayAt()
	{
		int index = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		SmallObject self = interpreter.context.stackPop();
		return self.data[ index - 1 ];
	}

	// < 31 self arg >
	// Returns a *new* array with argument added at the end.

	SmallObject arrayAdd()
	{
		SmallObject arg = interpreter.context.stackPop();
		SmallObject self = interpreter.context.stackPop();

		int selfSize = self.data.length;
		SmallObject addedArray = new SmallObject( self.objClass, selfSize + 1 );
		System.arraycopy( self.data, 0, addedArray.data, 0, selfSize );
		addedArray.data[ selfSize ] = arg;

		return addedArray;
	}

	// < 32 self arg >
	// Add argument as data member to self, increasing self size.
	// Returns self, not the argument.

	SmallObject objectAddToData()
	{
		SmallObject arg = interpreter.context.stackPop();
		SmallObject self = interpreter.context.stackPop();

		int selfSize = self.data.length;
		SmallObject addedArray[] = new SmallObject[ selfSize + 1 ];
		System.arraycopy( self.data, 0, addedArray, 0, selfSize );
		addedArray[ selfSize ] = arg;
		self.data = addedArray;

		return self;
	}

	// < 34 >
	// This is called by Object halt.

	SmallObject threadKill()
	{
		if( interpreter.parentThread != null )
			interpreter.parentThread.interrupt();

		if( interpreter.myThread != null )
			interpreter.myThread.interrupt();

		interpreter.killThread = true;

		return interpreter.image.nilObject;
	}

	// < 35 >

	SmallObject contextCurrent()
	{
		return interpreter.context;
	}

	// < 36 >
	// Size argument is passed in bytecode low bits.

	SmallObject arrayFastNew()
	{
		int newArraySize = argCount;
		SmallObject newArray = new SmallObject( interpreter.image.arrayClass, newArraySize );
		for( int i = newArraySize - 1; i >= 0; i-- )
			newArray.data[ i ] = interpreter.context.stackPop();
		return newArray;
	}

	// < 37 smalltalkClass javaClassName [ arg1 arg2 ... ] >
	// The args are the values to call the constructor of the java object with.
	// The Java types for the args are derived from their classes.

	// Note: This argument matching for all invocation primitives not completely solid:
	//       F.e. 'int' and 'Integer' are different in Java but the same in Smalltalk.
	//       The basic types are chosen by default now. Hope this will hold for all use.

	SmallObject javaObjectNew()
			throws SmallException
	{
		if( argCount < 2 )
			throw new SmallException( "javaObjectCreateInstance: Invalid argument count: " + argCount, interpreter.context );

		int javaArgCount = argCount - 2;     // Minus return class, java object, java method name.
		Object[] javaArgs = javaParseSmalltalkArgs( javaArgCount );

		String javaClassName = interpreter.context.stackPop().toString();
		SmallObject smallClass = interpreter.context.stackPop();

		try {
			return new SmallJavaObject( smallClass, javaClassName, javaArgs );
		} catch( Exception e ) {
			throw new SmallException( "Error creating Java object: " + javaClassName + ", exception: " + e, interpreter.context );
		}
	}

	// < 43 smalltalkClass javaClassName [ argType1 argValue1 argType2 argValue2 ... ] >
	// Invokes static method on Java class using Java argument types for exact matching of the method to be invoked.
	// Returns the Java return value converted tot returnClass.
	// If returnClass is nil, then then returned Java value is ignored and nil is returned.

	SmallObject javaObjectNewTyped()
			throws SmallException
	{
		if( argCount < 2 || ( argCount - 2 ) % 2 != 0 )
			throw new SmallException( "javaObjectNewTyped: Invalid argument count: " + argCount, interpreter.context );

		// java arg count is primitive arg count minus fixed args and every pairs for argType, argValue counts as 1.
		int javaArgCount = ( argCount - 2 ) / 2;
		JavaArgs javaArgs = javaParseTypedSmalltalkArgs( javaArgCount );

		String javaClassName = interpreter.context.stackPop().toString();
		SmallObject smallClass = interpreter.context.stackPop();

		try {
			return new SmallJavaObject( smallClass, javaClassName, javaArgs );
		} catch( Exception e ) {
			throw new SmallException( "Error creating Java object: " + javaClassName + ", exception: " + e, interpreter.context );
		}
	}

	// < 38 returnClass smallJavaObject javaMethodName [ arg1 arg2 ... ] >
	// Invokes java method on Java object with typed arguments for exact matching of the method to be invoked.
	// Returns the Java return value converted tot returnClass.
	// If returnClass is nil, then then returned Java value is ignored and nil is returned.
	// The args are the values to invoke the method of the java object with.
	// The Java types for the args are derived from their classes.

	SmallObject javaObjectInvokeMethod()
			throws SmallException
	{
		if( argCount < 3 )
			throw new SmallException( "javaObjectInvokeMethod: Invalid argument count: " + argCount, interpreter.context );

		int javaArgCount = argCount - 3;     // Minus return class, java object, java method name.
		Object[] javaArgs = javaParseSmalltalkArgs( javaArgCount );

		String javaMethodName = interpreter.context.stackPop().toString();
		SmallJavaObject smallJavaObject = ( SmallJavaObject ) interpreter.context.stackPop();
		SmallObject smallClass = interpreter.context.stackPop();

		try {
			return smallJavaObject.invokeMethod( javaMethodName, javaArgs, smallClass );
		} catch( Exception e ) {
			throw new SmallException( "Error invoking Java method: " + javaMethodName +
					", on: " + smallJavaObject.getClass().toString() + ", exception: " + e, interpreter.context );
		}
	}

	// < 44 returnClass smallJavaObject javaMethodName [ argType1 argValue1 argType2 argValue2 ... ] >
	// Invokes java method on Java object.
	// Returns the Java return value converted tot returnClass.
	// If returnClass is nil, then then returned Java value is ignored and nil is returned.
	// The args are the types and values to invoke the method of the java object with.

	SmallObject javaObjectInvokeMethodTyped()
			throws SmallException
	{
		if( argCount < 3 || ( argCount - 3 ) % 2 != 0 )
			throw new SmallException( "javaObjectNewTyped: Invalid argument count: " + argCount, interpreter.context );

		// The Java arg count is primitive arg count minus fixed args.
		// Every pair of argType, argValue counts as 1.
		int javaArgCount = ( argCount - 3 ) / 2;
		JavaArgs javaArgs = javaParseTypedSmalltalkArgs( javaArgCount );

		String javaMethodName = interpreter.context.stackPop().toString();
		SmallJavaObject smallJavaObject = ( SmallJavaObject ) interpreter.context.stackPop();
		SmallObject smallClass = interpreter.context.stackPop();

		try {
			return smallJavaObject.invokeMethodTyped( javaMethodName, javaArgs, smallClass );
		} catch( Exception e ) {
			throw new SmallException( "Error invoking Java method: " + javaMethodName +
					", on: " + smallJavaObject.getClass().toString() + ", exception: " + e, interpreter.context );
		}
	}

	// < 39 returnClass javaClassName javaMethodName [ arg1 arg2 ... ] >
	// Invokes static method on Java class.
	// Returns the Java return value converted tot returnClass.
	// If returnClass is nil, then then returned Java value is ignored and nil is returned.
	// The args are the values to invoke the method of the java object with.
	// The Java types for the args are derived from their classes.

	SmallObject javaClassInvokeStaticMethod()
			throws SmallException
	{
		if( argCount < 3 )
			throw new SmallException( "javaInvokeStaticMethod: Invalid argument count: " + argCount, interpreter.context );

		int javaArgCount = argCount - 3;     // Minus return class, java class name, java method name.
		Object[] javaArgs = javaParseSmalltalkArgs( javaArgCount );

		String javaMethodName = interpreter.context.stackPop().toString();
		String javaClassName = interpreter.context.stackPop().toString();
		SmallObject returnClass = interpreter.context.stackPop();

		try {
			return SmallJavaObject.invokeStaticMethod( javaClassName, javaMethodName, javaArgs, returnClass );
		} catch( Exception e ) {
			throw new SmallException( "Error invoking static Java method: " + javaMethodName +
					", on: " + javaClassName + ", exception: " + e, interpreter.context );
		}
	}

	// < 45 returnClass javaClassName javaMethodName [ argType1 argValue1 argType2 argValue2 ... ] >
	// Invokes static method on Java class using Java argument types for exact matching method to be invoked .
	// Returns the Java return value converted tot returnClass.
	// If returnClass is nil, then then returned Java value is ignored and nil is returned.

	SmallObject javaClassInvokeStaticMethodTyped()
			throws SmallException
	{
		if( argCount < 3 || ( argCount - 3 ) % 2 != 0 )
			throw new SmallException( "javaInvokeStaticMethod: Invalid argument count: " + argCount, interpreter.context );

		// javaArgCount is minus return class, java class name, java method name and and has pairs for argType, argValue.
		int javaArgCount = ( argCount - 3 ) / 2;

		Class<?>[] javaArgTypes = new Class[ javaArgCount ];
		Object[] javaArgValues = new Object[ javaArgCount ];

		try {
			for( int argIndex = javaArgCount - 1; argIndex >= 0; argIndex-- ) {
				SmallObject smallObject = interpreter.context.stackPop();
				javaArgValues[ argIndex ] = SmallJavaObject.smalltalkToJava( smallObject, interpreter.context );
				String javaClassName = interpreter.context.stackPop().toString();
				javaArgTypes[ argIndex ] = SmallJavaObject.loadClass( javaClassName );
			}
		} catch( Exception e ) {
			throw new SmallException( "javaClassInvokeStaticMethodTyped: Exception parsing arguments: " + e, interpreter.context );
		}

		String javaMethodName = interpreter.context.stackPop().toString();
		String javaClassName = interpreter.context.stackPop().toString();
		SmallObject returnClass = interpreter.context.stackPop();

		try {
			return SmallJavaObject.invokeStaticMethodTyped( javaClassName, javaMethodName, javaArgValues, javaArgTypes, returnClass );
		} catch( Exception e ) {
			throw new SmallException( "Error invoking static Java method: " + javaMethodName +
					", on: " + javaClassName + ", exception: " + e, interpreter.context );
		}
	}

	// < 40 returnClass javaObject javaFieldName >
	// Read field form Java object.
	// Returns the Java return value converted tot returnClass.

	SmallObject javaObjectReadField()
			throws SmallException
	{
		String javaFieldName = interpreter.context.stackPop().toString();
		SmallJavaObject javaObject = ( SmallJavaObject ) interpreter.context.stackPop();
		SmallObject returnClass = interpreter.context.stackPop();

		try {
			return javaObject.readField( javaFieldName, returnClass );
		} catch( Exception e ) {
			throw new SmallException( "Error reading Java field: " + javaFieldName +
					", on: " + javaObject + ", exception: " + e, interpreter.context );
		}
	}

	// < 41 returnClass javaClassName javaFieldName >
	// Read field form Java object.
	// Returns the Java return value converted tot returnClass.

	SmallObject javaClassReadStaticField()
			throws SmallException
	{
		String javaFieldName = interpreter.context.stackPop().toString();
		String javaClassName = interpreter.context.stackPop().toString();
		SmallObject returnClass = interpreter.context.stackPop();

		try {
			return SmallJavaObject.readStaticField( javaClassName, javaFieldName, returnClass );
		} catch( Exception e ) {
			throw new SmallException( "Error reading Java field: " + javaFieldName +
					", on: " + javaClassName + ", exception: " + e, interpreter.context );
		}
	}

	// Read Smalltalk arguments from stack and return Java values for them in an array.

	Object[] javaParseSmalltalkArgs( int javaArgCount )
			throws SmallException
	{
		Object[] javaArgs = new Object[ javaArgCount ];

		for( int argIndex = javaArgCount - 1; argIndex >= 0; argIndex-- ) {
			SmallObject smallObject = interpreter.context.stackPop();
			javaArgs[ argIndex ] = SmallJavaObject.smalltalkToJava( smallObject, interpreter.context );
		}

		return javaArgs;
	}

	// Parse java-typed parameters from the stack and return Java types and values, to be used for invocation.
	// The stack is formed in pairs: [ javaTypeName1 smalltalkValue1 javaTypeName2 smalltalkValue2 ... ]
	// The parsed result is returned in an Object array of with 2 elements:
	// First Class[] for the java types, second Object[] for the java values.

	JavaArgs javaParseTypedSmalltalkArgs( int javaArgCount )
			throws SmallException
	{
		Class<?>[] javaArgTypes = new Class[ javaArgCount ];
		Object[] javaArgValues = new Object[ javaArgCount ];

		try {
			for( int argIndex = javaArgCount - 1; argIndex >= 0; argIndex-- ) {
				SmallObject smallObject = interpreter.context.stackPop();
				javaArgValues[ argIndex ] = SmallJavaObject.smalltalkToJava( smallObject, interpreter.context );
				String javaClassName = interpreter.context.stackPop().toString();
				javaArgTypes[ argIndex ] = SmallJavaObject.loadClass( javaClassName );
			}
		} catch( Exception e ) {
			throw new SmallException( "javaClassInvokeStaticMethodTyped: Exception parsing arguments: " + e, interpreter.context );
		}

		return new JavaArgs( javaArgTypes, javaArgValues );
	}

	// < 42 javaObject eventType block eventClass >
	// Set block as listener for certain event types on javaObject.
	// eventType: 2 = buttonActionEvent.
	// When an event is triggered:
	// 		- A new instance of eventClass is created as a SmallJavaObject.
	//		- The Java event object is set as the value of the created object.
	//		- The block is invoked with this object as its argument.

	SmallObject javaAddEventListener()
			throws SmallException
	{
		if( argCount != 4 )
			throw new SmallException( "javaAddEventListener: Invalid argument count: " + argCount, interpreter.context );

		SmallObject smallEventClass = interpreter.context.stackPop();
		SmallObject smallBlock = interpreter.context.stackPop();
		int eventType = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		SmallJavaObject smallJavaObject = ( SmallJavaObject ) interpreter.context.stackPop();

		if( ! smallJavaObject.addEventListener( eventType, smallBlock, smallEventClass, interpreter.myThread ) )
			throw new SmallException( "Can't add Java event listener type: " + eventType, interpreter.context );

		return smallJavaObject;
	}

	// < 46 returnClass javaClassName >
	// Loads Java class as SmallJavaObject.

	SmallObject javaLoadClass()
			throws SmallException
	{
		if( argCount < 2 )
			throw new SmallException( "LoadClass: Invalid argument count: " + argCount, interpreter.context );

		String javaClassName = interpreter.context.stackPop().toString();
		SmallObject smallClass = interpreter.context.stackPop();

		try {
			return SmallJavaObject.loadClass( smallClass, javaClassName );
		} catch( Exception e ) {
			throw new SmallException( "Error creating Java object: " + javaClassName + ", exception: " + e, interpreter.context );
		}
	}

	// < 47 class methodText >
	// Compile method source text for class with the Java compiler (SmallCompiler).
	// Called from Class>>parseMethod:.
	// Returns a new Method, or a String with the error message if compilation fails.

	SmallObject methodCompile()
			throws SmallException
	{
		if( argCount != 2 )
			throw new SmallException( "methodCompile: Invalid argument count: " + argCount, interpreter.context );

		String methodText = interpreter.context.stackPop().toString();
		SmallObject aClass = interpreter.context.stackPop();

		try {
			return new SmallCompiler( interpreter.image ).compileMethod( aClass, methodText );
		} catch( RuntimeException e ) {
			return new SmallByteArray( interpreter.image.stringClass, "Compile error: " + e.getMessage() );
		}
	}

	// < 50 floatClass smallInt >

	SmallObject floatFromSmallInt()
	{
		int smallInt = ( ( SmallInt ) interpreter.context.stackPop() ).value;
		SmallObject floatClass = interpreter.context.stackPop();

		return new SmallFloat( floatClass, smallInt );
	}

	// < 51 self arg >

	SmallObject floatAdd()
	{
		double arg = ( ( SmallFloat ) interpreter.context.stackPop() ).value;
		SmallFloat selfObject = ( SmallFloat ) interpreter.context.stackPop();
		double self = selfObject.value;
		SmallObject floatClass = selfObject.objClass;

		return new SmallFloat( floatClass, self + arg );
	}

	// < 52 self arg >

	SmallObject floatSubtract()
	{
		double arg = ( ( SmallFloat ) interpreter.context.stackPop() ).value;
		SmallFloat selfObject = ( SmallFloat ) interpreter.context.stackPop();
		double self = selfObject.value;
		SmallObject floatClass = selfObject.objClass;

		return new SmallFloat( floatClass, self - arg );
	}

	// < 53 self arg >

	SmallObject floatMultiply()
	{
		double arg = ( ( SmallFloat ) interpreter.context.stackPop() ).value;
		SmallFloat selfObject = ( SmallFloat ) interpreter.context.stackPop();
		double self = selfObject.value;
		SmallObject floatClass = selfObject.objClass;

		return new SmallFloat( floatClass, self * arg );
	}

	// < 54 self arg >

	SmallObject floatDivide()
	{
		double arg = ( ( SmallFloat ) interpreter.context.stackPop() ).value;
		SmallFloat selfObject = ( SmallFloat ) interpreter.context.stackPop();
		double self = selfObject.value;
		SmallObject floatClass = selfObject.objClass;

		return new SmallFloat( floatClass, self / arg );
	}

	// < 55 self arg >

	SmallObject floatLessThan()
	{
		double arg = ( ( SmallFloat ) interpreter.context.stackPop() ).value;
		double self = ( ( SmallFloat ) interpreter.context.stackPop() ).value;

		return ( self < arg ) ? interpreter.image.trueObject : interpreter.image.falseObject;
	}

	// < 56 self arg >

	SmallObject floatEquals()
	{
		double arg = ( ( SmallFloat ) interpreter.context.stackPop() ).value;
		double self = ( ( SmallFloat ) interpreter.context.stackPop() ).value;

		return ( self == arg ) ? interpreter.image.trueObject : interpreter.image.falseObject;
	}

	// < 57 self >

	SmallObject floatAsInteger()
	{
		double self = ( ( SmallFloat ) interpreter.context.stackPop() ).value;

		return interpreter.image.newInteger( ( int ) self );
	}
}
