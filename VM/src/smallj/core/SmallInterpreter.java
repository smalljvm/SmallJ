public class SmallInterpreter
{
	public SmallImage image;
	Operations operations = new Operations();
	Primitives primitives = new Primitives();

	// Execute() arguments for access by operations and primitives
	SmallContext context;
	Thread myThread;
	Thread parentThread;
	boolean killThread;

	public SmallInterpreter( SmallImage aImage )
	{
		image = aImage;
	}

	// execution method
	SmallObject execute( SmallContext aContext, final Thread aMyThread, final Thread aParentThread )
			throws SmallException
	{
		myThread = aMyThread;
		parentThread = aParentThread;
		context = aContext;
		SmallObject cachedContext = null;

		killThread = false;
		SmallObject returnedValue = null;

		while( ! context.isNil() && ! killThread ) {
			if( context != cachedContext ) {
				context.setCachedValues();
				cachedContext = context;
			}

			int code = context.nextCode();
			int low = code & 0xF;
			int high = code >> 4 & 0xF;
			if( high == 0 ) {
				high = low;
				low = context.nextCode();
			}

			returnedValue = operations.perform( high, low );
		}

		return returnedValue;
	}

	// Execute Smalltalk expression.
	// Implemented by calling the doIt method on the String class, that calls the compiler.

	protected void executeExpression( String expression )
			throws SmallException
	{
		// Find the doIt method in the String class
		String doItMethodName = "doIt";
		SmallObject doItMethod = findMethod( image.stringClass, doItMethodName );
		if( doItMethod == null )
			throw new SmallException( "Can't find expression evaluation method in String class: " + doItMethodName, context );

		SmallObject args = new SmallObject( image.arrayClass, 1 );
		args.data[ 0 ] = new SmallByteArray( image.stringClass, expression );
		SmallContext aContext = new SmallContext( image, image.nilObject, args, doItMethod );

		execute( aContext, null, null );
	}

	SmallObject findMethod( SmallObject aClass, String aMethodName )
	{
		SmallObject methods = aClass.data[ 2 ];
		for( int i = 0; i < methods.data.length; i++ ) {
			SmallObject method = methods.data[ i ];
			if( ( method.data[ 0 ].toString() ).equals( aMethodName ) )
				return method;
		}

		return null;    // Not found.
	}

	// ============================================= Operations

	interface Operation
	{
		SmallObject perform( int param ) throws SmallException;
	}

	class Operations
	{
		MethodCache methodCache = new MethodCache();

		static final int doSpecialOperation = 15;
		int maxOperation = 25;
		Operation[] operations = new Operation[ maxOperation + 1 ];

		Operations()
		{
			operations[ 1 ] = this::pushInstanceVar;
			operations[ 2 ] = this::pushArgumentVar;
			operations[ 3 ] = this::pushTemporaryVar;
			operations[ 4 ] = this::pushLiteral;
			operations[ 5 ] = this::pushConstant;
			operations[ 6 ] = this::assignInstance;
			operations[ 7 ] = this::assignTemporary;
			operations[ 8 ] = this::markArguments;
			operations[ 9 ] = this::sendMessage;
			operations[ 10 ] = this::sendUnary;
			operations[ 11 ] = this::sendBinary;
			operations[ 12 ] = this::pushBlock;
			operations[ 13 ] = this::doPrimitive;
			operations[ 14 ] = this::pushClassVariable;
			// Below are the "special" operations, encoded with bytecode high = 15 and low = code [ 1 .. 11 ].
			// Now routed through the same operations table.
			operations[ 15 ] = this::returnSelf;
			operations[ 16 ] = this::returnStackTop;
			operations[ 17 ] = this::returnBlock;
			operations[ 18 ] = this::duplicateStackTop;
			operations[ 19 ] = this::popStackTop;
			operations[ 20 ] = this::branch;
			operations[ 21 ] = this::branchIfNotFalse;
			operations[ 22 ] = this::branchIfNotTrue;
			operations[ 25 ] = this::sendToSuper;
		}

		SmallObject perform( int operationNum, int param )
				throws SmallException
		{
			if( operationNum == doSpecialOperation )
				operationNum = doSpecialOperation + param - 1;     // Point to second part of operations table

			if( operationNum < 1 || operationNum > maxOperation )
				throw new SmallException( "Unrecognized operation code: " + operationNum, context );

			Operation operation = operations[ operationNum ];
			if( operation == null )
				throw new SmallException( "Unrecognized operation code: " + operationNum, context );

			return operation.perform( param );
		}

		// ==================================== Byte code operations

		// Operation# 1

		SmallObject pushInstanceVar( int index )
		{
			context.stackPush( context.getInstanceVars()[ index ] );
			return null;
		}

		// Operation# 2

		SmallObject pushArgumentVar( int index )
		{
			context.stackPush( context.getArgumentVars().data[ index ] );
			return null;
		}

		// Operation# 3

		SmallObject pushTemporaryVar( int index )
		{
			context.stackPush( context.getTemporaryVars()[ index ] );
			return null;
		}

		// Operation# 4

		SmallObject pushLiteral( int index )
		{
			context.stackPush( context.getLiteralVars()[ index ] );
			return null;
		}

		// Operation# 5

		SmallObject pushConstant( int param )
				throws SmallException
		{
			if( param >= 0 && param < image.smallIntsLength ) {
				context.stackPush( image.smallInts[ param ] );
			} else {
				switch( param ) {
					case 10:
						context.stackPush( image.nilObject );
						break;
					case 11:
						context.stackPush( image.trueObject );
						break;
					case 12:
						context.stackPush( image.falseObject );
						break;
					default:
						throw new SmallException( "Unknown constant: " + param, context );
				}
			}
			return null;
		}

		// Operation# 6

		SmallObject assignInstance( int param )
		{
			context.getInstanceVars()[ param ] = context.stackGetTop();
			return null;
		}

		// Operation# 7

		SmallObject assignTemporary( int param )
		{
			context.getTemporaryVars()[ param ] = context.stackGetTop();
			return null;
		}

		// Operation# 8
		// Pop arguments form stack, put them in array, push that array on the stack.

		SmallObject markArguments( int param )
		{
			SmallObject newArguments = new SmallObject( image.arrayClass, param );
			SmallObject[] tempArgs = newArguments.data; // direct access to array
			while( param > 0 ) {
				tempArgs[ -- param ] = context.stackPop();
			}
			context.stackPush( newArguments );
			return null;
		}

		// Operation# 9

		SmallObject sendMessage( int messageSelectorIndex )
				throws SmallException
		{
			// save old context
			context.argumentVars = context.stackPop();
			context.saveCodesPointer();
			context.saveStackTop();

			// build new context
			SmallObject messageSelector = context.getLiteralVars()[ messageSelectorIndex ];
			SmallObject method = methodCache.lookupOrSave( context, messageSelector );

			context = new SmallContext( image, context, context.argumentVars, method );
			return null;
		}

		// Operation# 10
		// < self >
		// param: 0: isNil, 1: notNil

		SmallObject sendUnary( int param )
				throws SmallException
		{
			SmallObject self = context.stackPop();
			SmallObject result;

			if( param == 0 )    // isNil
				result = self == image.nilObject ? image.trueObject : image.falseObject;
			else if( param == 1 )   // notNil
				result = self != image.nilObject ? image.trueObject : image.falseObject;
			else
				throw new SmallException( "Illegal sendUnary: " + param, context );

			context.stackPush( result );
			return null;
		}

		// Operation# 11
		// < self arg >
		// param: 0: "<", 1: "<=", 2: "+"
		// If self and arg are both a SmallInt, then an optimized version is done.

		SmallObject sendBinary( int param )
				throws SmallException
		{
			SmallObject arg = context.stackPop();
			SmallObject self = context.stackPop();

			if( self instanceof SmallInt && arg instanceof SmallInt ) {
				int selfInt = ( ( SmallInt ) self ).value;
				int argInt = ( ( SmallInt ) arg ).value;

				switch( param ) {
					case 0:     // <
						return context.stackPush( selfInt < argInt ? image.trueObject : image.falseObject );
					case 1:     // <=
						return context.stackPush( selfInt <= argInt ? image.trueObject : image.falseObject );
					case 2: {   // +
						int intSum = selfInt + argInt;
						long longSum = ( long ) selfInt + ( long ) argInt;
						if( intSum == longSum )
							return context.stackPush( image.newInteger( intSum ) );
					}
					default:
						throw new SmallException( "Illegal sendBinary int param : " + param, context );
				}
			}

			// Mon optimized binary message.
			context.argumentVars = new SmallObject( image.arrayClass, 2 );
			context.argumentVars.data[ 0 ] = self;
			context.argumentVars.data[ 1 ] = arg;
			context.saveCodesPointer();
			context.saveStackTop();

			String messageSelector;
			switch( param ) {
				case 0:
					messageSelector = "<";
					break;
				case 1:
					messageSelector = "<=";
					break;
				case 2:
					messageSelector = "+";
					break;
				default:
					throw new SmallException( "Illegal sendBinary param : " + param, context );
			}
			SmallByteArray messageSelectorObj = new SmallByteArray( null, messageSelector );
			context.method = context.lookupMethod( context.getSelf().objClass, messageSelectorObj );
			context = new SmallContext( image, context, context.argumentVars, context.method );

			return null;
		}

		// Operation# 12: < block >

		SmallObject pushBlock( int argumentLocation )
		{
			int gotoIndex = context.nextCode();
			SmallBlock result = new SmallBlock( context, argumentLocation );
			context.stackPush( result );
			context.codesPointer = gotoIndex;
			return result;
		}

		// Operation# 13: < arg1 arg2 ... >
		// Next byte code is primitive number.

		SmallObject doPrimitive( int argCount )
				throws SmallException
		{
			int primitiveNum = context.nextCode();

			SmallObject result = primitives.perform( primitiveNum, argCount );
			context.stackPush( result );
			return result;
		}

		// Operation# 14: < >
		// param is index of class variable

		SmallObject pushClassVariable( int param )
		{
			context.stackPush( context.getSelf().objClass.data[ SmallClass.instVarCount + param ] );
			return null;
		}

		// Operation# 15: < >
		// param is not used.

		SmallObject returnSelf( int param )
		{
			SmallObject result = context.getSelf();
			context = context.castOrConvert( context.getPreviousContext() );

			if( ! context.isNil() ) {
				context.stackPush( result );
				context.saveStackTop();
			}

			return result;
		}

		// Operation# 16: < arg >
		// param is not used.

		SmallObject returnStackTop( int param )
		{
			SmallObject result = context.stackPop();
			context = context.castOrConvert( context.getPreviousContext() );

			if( ! context.isNil() ) {
				context.stackPush( result );
				context.saveStackTop();
			}

			return result;
		}

		// Operation# 17: < block >
		// param is not used.

		SmallObject returnBlock( int param )
		{
			SmallObject result = context.stackPop();
			context = context.castOrConvert( context.getCreatingPreviousContext() );

			if( ! context.isNil() ) {
				context.stackPush( result );
				context.saveStackTop();
			}

			return result;
		}

		// Operation# 18: < self >
		// param is not used.

		SmallObject duplicateStackTop( int param )
		{
			SmallObject result = context.stackGetTop();
			context.stackPush( result );
			return result;
		}

		// Operation# 19: < arg >
		// param is not used.

		SmallObject popStackTop( int param )
		{
			context.stackPop();
			return null;
		}

		// Operation# 20: < >
		// param is not used.
		// Next code is branch location.

		SmallObject branch( int param )
		{
			context.codesPointer = context.nextCode();
			return null;
		}

		// Operation# 21: < bool >
		// param is not used.
		// Next code is branch location.
		// This is called by 'bool ifFalse: [ block ]'.
		// *Only* if bool is false, the block will be evaluated, otherwise it is branched over.

		SmallObject branchIfNotFalse( int param )
		{
			int branchCodesPointer = context.nextCode();
			SmallObject result = context.stackPop();
			if( result != image.falseObject )
				context.codesPointer = branchCodesPointer;

			return null;
		}

		// Operation# 22: < bool >
		// param is not used.
		// Next code is branch location.
		// This is called by 'bool ifTrue: [ block ]'.
		// *Only* if bool is true, the block will be evaluated, otherwise it is branched over.

		SmallObject branchIfNotTrue( int param )
		{
			int branchCodesPointer = context.nextCode();
			SmallObject result = context.stackPop();
			if( result != image.trueObject )
				context.codesPointer = branchCodesPointer;

			return null;
		}

		// Operation# 23: < self? >
		// param is not used.
		// Next code message selector index.

		SmallObject sendToSuper( int param )
				throws SmallException
		{
			int messageSelectorIndex = context.nextCode();

			// save old context
			context.argumentVars = context.stackPop();
			context.saveStackTop();
			context.saveCodesPointer();

			// build new context
			SmallObject[] oldLiteralVars = context.getLiteralVars();
			SmallObject methodClass = context.getMethodClass();
			SmallObject parentClass = methodClass.data[ 1 ];
			SmallObject method = context.lookupMethod( parentClass, ( SmallByteArray ) oldLiteralVars[ messageSelectorIndex ] );
			context = new SmallContext( image, context, context.argumentVars, method );
			return null;
		}
	}

	// ============================================= Primitives

	interface Primitive
	{
		SmallObject perform() throws SmallException;
	}

	class Primitives
	{
		int argCount = 0;
		static final int maxPrimitive = 65;
		public Primitive[] primitives = new Primitive[ maxPrimitive + 1 ];

		Primitives()
		{
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
				throw new SmallException( "Unrecognized primitive: " + primitiveNum, context );

			Primitive primitive = primitives[ primitiveNum ];
			if( primitive == null )
				throw new SmallException( "Unrecognized primitive: " + primitiveNum, context );

			// The argument count is kept in a global variable and is not passed
			// because it is only used for primitives with a variable number of arguments.
			argCount = aArgCount;
			return primitive.perform();
		}

		// ============================================ All primitives below

		// < 1 self arg >

		SmallObject objectEquals()
		{
			SmallObject self = context.stackPop();
			SmallObject argument = context.stackPop();

			return argument == self ? image.trueObject : image.falseObject;
		}

		// < 2 self >

		SmallObject objectClass()
		{
			SmallObject self = context.stackPop();

			return self.objClass;
		}

		// < 3 self class >
		// Set the class of an object.
		// Should normally not be necessary, put can be used to repair the image.

		SmallObject objectSetClass()
		{
			SmallObject newClass = context.stackPop();
			SmallObject self = context.stackPop();

			self.objClass = newClass;
			return self;
		}

		// < 4 self >
		// Return size of data members of self.

		SmallObject objectSize()
		{
			SmallObject self = context.stackPop();
			int size;
			if( self instanceof SmallByteArray )
				size = ( ( SmallByteArray ) self ).values.length;
			else
				size = self.data.length;

			return image.newInteger( size );
		}

		// < 25 self newSize >
		// Resize self to fit new size.
		// Should be called for instances when object class variable count is (possibly) modified.

		SmallObject objectResize()
		{
			int newSize = ( ( SmallInt ) context.stackPop() ).value;
			SmallObject self = context.stackPop();

			self.resize( newSize );

			return self;
		}

		// < 18 self index value >

		SmallObject objectAtPut()
		{
			SmallObject value = context.stackPop();
			int index = ( ( SmallInt ) context.stackPop() ).value;
			SmallObject self = context.stackPop();

			self.data[ index - 1 ] = value;
			return self;
		}

		// < 6 self >

		SmallObject contextExecute()
				throws SmallException
		{
			SmallContext aContext = context.castOrConvert( context.stackPop() );

			return new SmallInterpreter( image ).execute( aContext, myThread, parentThread );
		}

		// < 7 class size >

		SmallObject objectNew()
		{
			int size = ( ( SmallInt ) context.stackPop() ).value;
			SmallObject classObj = context.stackPop();

			return new SmallObject( classObj, size );
		}

		// < 8 self > or < 8 arg1 self >  or < 8 arg1 arg2 self >
		// The stack order is non-standard here to be able to determine the variable number of arguments.

		SmallObject blockInvoke()
		{
			SmallBlock block = ( SmallBlock ) context.stackPop();
			context = block.invoke( argCount, context );
			context.setCachedValues();

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
			int arg = ( ( SmallInt ) context.stackPop() ).value;
			int self = ( ( SmallInt ) context.stackPop() ).value;
			int sum = self + arg;
			long longSum = ( long ) self + ( long ) arg;

			if( sum != longSum )
				return image.nilObject;     // Overflow.

			return image.newInteger( sum );
		}

		// < 11 self arg >

		SmallObject intDivide()
		{
			int arg = ( ( SmallInt ) context.stackPop() ).value;
			int self = ( ( SmallInt ) context.stackPop() ).value;
			int quotient = self / arg;
			return image.newInteger( quotient );
		}

		// < 12 self arg >

		SmallObject intRemainder()
		{
			int divider = ( ( SmallInt ) context.stackPop() ).value;
			int self = ( ( SmallInt ) context.stackPop() ).value;
			int remainder = self % divider;
			return image.newInteger( remainder );
		}

		// < 13 self arg >
		// Note: This is currently not used because the compiler optimizes it in operation #11

		SmallObject intLessThan()
		{
			int arg = ( ( SmallInt ) context.stackPop() ).value;
			int self = ( ( SmallInt ) context.stackPop() ).value;
			return self < arg ? image.trueObject : image.falseObject;
		}

		// < 14 self arg >

		SmallObject intEquals()
		{
			int arg = ( ( SmallInt ) context.stackPop() ).value;
			int self = ( ( SmallInt ) context.stackPop() ).value;
			return self == arg ? image.trueObject : image.falseObject;
		}

		// < 15 self arg >
		// Returns nil on overflow.

		SmallObject intMultiply()
		{
			int arg = ( ( SmallInt ) context.stackPop() ).value;
			int self = ( ( SmallInt ) context.stackPop() ).value;

			int product = self * arg;
			long longProduct = ( long ) self * ( long ) arg;
			if( product != longProduct )
				return image.nilObject;         // Overflow

			return image.newInteger( product );
		}

		// < 16 self arg >

		SmallObject intSubtract()
		{
			int arg = ( ( SmallInt ) context.stackPop() ).value;
			int self = ( ( SmallInt ) context.stackPop() ).value;

			int subtraction = self - arg;
			long longSubtraction = ( long ) self - ( long ) arg;
			if( subtraction != longSubtraction )
				return image.nilObject;        // Overflow

			return image.newInteger( subtraction );
		}

		// ===================================== Long


		// < 58 self arg >
		// Long integer addition. Returns nil on overflow.

		SmallObject longAdd()
		{
			long arg = ( ( SmallLong ) context.stackPop() ).value;
			long self = ( ( SmallLong ) context.stackPop() ).value;

			long sum;
			try {
				sum = Math.addExact( self, arg );
			}
			catch( ArithmeticException e )
			{
				return image.nilObject;     // Overflow.
			}

			return new SmallLong( image.longClass, sum );
		}

		// < 59 self arg >

		SmallObject longDivide()
		{
			long arg = ( ( SmallLong ) context.stackPop() ).value;
			long self = ( ( SmallLong ) context.stackPop() ).value;

			long  quotient = self / arg;

			return new SmallLong( image.longClass, quotient );
		}

		// < 60 self arg >

		SmallObject longRemainder()
		{
			long arg = ( ( SmallLong ) context.stackPop() ).value;
			long self = ( ( SmallLong ) context.stackPop() ).value;

			long remainder = self % arg;

			return new SmallLong( image.longClass, remainder );
		}

		// < 61 self arg >
		// Note: This is currently not used because the compiler optimizes it in operation #11

		SmallObject longLessThan()
		{
			long arg = ( ( SmallLong ) context.stackPop() ).value;
			long self = ( ( SmallLong ) context.stackPop() ).value;

			return self < arg ? image.trueObject : image.falseObject;
		}

		// < 62 self arg >

		SmallObject longEquals()
		{
			long arg = ( ( SmallLong ) context.stackPop() ).value;
			long self = ( ( SmallLong ) context.stackPop() ).value;

			return self == arg ? image.trueObject : image.falseObject;
		}

		// < 63 self arg >
		// Returns nil on overflow.

		SmallObject longMultiply()
		{
			long arg = ( ( SmallLong ) context.stackPop() ).value;
			long self = ( ( SmallLong ) context.stackPop() ).value;

			long product;
			try {
				product = Math.multiplyExact( self, arg );
			}
			catch( ArithmeticException e )
			{
				return image.nilObject;     // Overflow.
			}

			return new SmallLong( image.longClass, product );
		}

		// < 64 self arg >

		SmallObject longSubtract()
		{
			long arg = ( ( SmallLong ) context.stackPop() ).value;
			long self = ( ( SmallLong ) context.stackPop() ).value;

			long subtraction;
			try {
				subtraction = Math.subtractExact( self, arg );
			}
			catch( ArithmeticException e )
			{
				return image.nilObject;     // Underflow.
			}

			return new SmallLong( image.longClass, subtraction );
		}

		// < 65 smallInt >
		// Return new Smalltalk long with value of smallInt.
		// So the range is limited for now. Should have Smalltalk compiler support for longs.

		SmallObject longNew()
		{
			int value = ( ( SmallInt ) context.stackPop() ).value;

			return image.newLong( value );
		}

		// =========================================== Block

		// < 19 self >
		// Block may not have arguments

		SmallObject blockFork()
		{
			SmallObject self = context.stackPop();
			new SmallThread( self, myThread ).start();
			return self;
		}

		// < 20 arrayClass size >
		// arrayClass is ByteArray or String

		SmallObject byteArrayNew()
		{
			int size = ( ( SmallInt ) context.stackPop() ).value;
			SmallObject arrayClass = context.stackPop();
			return new SmallByteArray( arrayClass, size );
		}

		// < 21 self index >

		SmallObject stringAt()
		{
			int index = ( ( SmallInt ) context.stackPop() ).value;
			SmallByteArray self = ( SmallByteArray ) context.stackPop();
			int aChar = self.values[ index - 1 ] & 0xFF;
			return image.newInteger( aChar );
		}

		// < 22 self index value >
		// Note: Self is returned, not the value.

		SmallObject stringAtPut()
		{
			byte value = ( byte ) ( ( ( SmallInt ) context.stackPop() ).value & 0xFF );
			int index = ( ( SmallInt ) context.stackPop() ).value;
			SmallByteArray string = ( SmallByteArray ) context.stackPop();

			string.values[ index - 1 ] = value;

			return string;
		}

		// < 23 self >

		SmallObject stringCopy()
		{
			SmallObject self = context.stackPop();

			return self.copy( self.objClass );
		}

		// < 24 self arg >

		SmallObject stringAppend()
		{
			SmallByteArray arg = ( SmallByteArray ) context.stackPop();
			SmallByteArray self = ( SmallByteArray ) context.stackPop();
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
			byte[] arg = ( ( SmallByteArray ) context.stackPop() ).values;
			byte[] self = ( ( SmallByteArray ) context.stackPop() ).values;

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

			return image.newInteger( result );
		}

		// < 27 >
		// Return the current SmallJ image file name as a string.

		SmallObject imageFileName()
		{
			return new SmallByteArray( image.stringClass, String.valueOf( image.fileName ) );
		}

		// < 29 fileName >

		SmallObject imageSave()
				throws SmallException
		{
			SmallByteArray smallFileName = ( SmallByteArray ) context.stackPop();
			String fileName = smallFileName.toString();
			try {
				image.saveAs( fileName );
			} catch( Exception e ) {
				throw new SmallException( "Error saving image: " + e, context );
			}

			return smallFileName;
		}

		// < 30 self index >

		SmallObject arrayAt()
		{
			int index = ( ( SmallInt ) context.stackPop() ).value;
			SmallObject self = context.stackPop();
			return self.data[ index - 1 ];
		}

		// < 31 self arg >
		// Returns a *new* array with argument added at the end.

		SmallObject arrayAdd()
		{
			SmallObject arg = context.stackPop();
			SmallObject self = context.stackPop();

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
			SmallObject arg = context.stackPop();
			SmallObject self = context.stackPop();

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
			if( parentThread != null )
				parentThread.interrupt();

			if( myThread != null )
				myThread.interrupt();

			killThread = true;

			return image.nilObject;
		}

		// < 35 >

		SmallObject contextCurrent()
		{
			return context;
		}

		// < 36 >
		// Size argument is passed in bytecode low bits.

		SmallObject arrayFastNew()
		{
			int newArraySize = argCount;
			SmallObject newArray = new SmallObject( image.arrayClass, newArraySize );
			for( int i = newArraySize - 1; i >= 0; i-- )
				newArray.data[ i ] = context.stackPop();
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
				throw new SmallException( "javaObjectCreateInstance: Invalid argument count: " + argCount, context );

			int javaArgCount = argCount - 2;     // Minus return class, java object, java method name.
			Object[] javaArgs = javaParseSmalltalkArgs( javaArgCount );

			String javaClassName = context.stackPop().toString();
			SmallObject smallClass = context.stackPop();

			try {
				return new SmallJavaObject( smallClass, javaClassName, javaArgs );
			} catch( Exception e ) {
				throw new SmallException( "Error creating Java object: " + javaClassName + ", exception: " + e, context );
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
				throw new SmallException( "javaObjectNewTyped: Invalid argument count: " + argCount, context );

			// java arg count is primitive arg count minus fixed args and every pairs for argType, argValue counts as 1.
			int javaArgCount = ( argCount - 2 ) / 2;
			JavaArgs javaArgs = javaParseTypedSmalltalkArgs( javaArgCount );

			String javaClassName = context.stackPop().toString();
			SmallObject smallClass = context.stackPop();

			try {
				return new SmallJavaObject( smallClass, javaClassName, javaArgs );
			} catch( Exception e ) {
				throw new SmallException( "Error creating Java object: " + javaClassName + ", exception: " + e, context );
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
				throw new SmallException( "javaObjectInvokeMethod: Invalid argument count: " + argCount, context );

			int javaArgCount = argCount - 3;     // Minus return class, java object, java method name.
			Object[] javaArgs = javaParseSmalltalkArgs( javaArgCount );

			String javaMethodName = context.stackPop().toString();
			SmallJavaObject smallJavaObject = ( SmallJavaObject ) context.stackPop();
			SmallObject smallClass = context.stackPop();

			try {
				return smallJavaObject.invokeMethod( javaMethodName, javaArgs, smallClass );
			} catch( Exception e ) {
				throw new SmallException( "Error invoking Java method: " + javaMethodName +
						", on: " + smallJavaObject.getClass().toString() + ", exception: " + e, context );
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
				throw new SmallException( "javaObjectNewTyped: Invalid argument count: " + argCount, context );

			// The Java arg count is primitive arg count minus fixed args.
			// Every pair of argType, argValue counts as 1.
			int javaArgCount = ( argCount - 3 ) / 2;
			JavaArgs javaArgs = javaParseTypedSmalltalkArgs( javaArgCount );

			String javaMethodName = context.stackPop().toString();
			SmallJavaObject smallJavaObject = ( SmallJavaObject ) context.stackPop();
			SmallObject smallClass = context.stackPop();

			try {
				return smallJavaObject.invokeMethodTyped( javaMethodName, javaArgs, smallClass );
			} catch( Exception e ) {
				throw new SmallException( "Error invoking Java method: " + javaMethodName +
						", on: " + smallJavaObject.getClass().toString() + ", exception: " + e, context );
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
				throw new SmallException( "javaInvokeStaticMethod: Invalid argument count: " + argCount, context );

			int javaArgCount = argCount - 3;     // Minus return class, java class name, java method name.
			Object[] javaArgs = javaParseSmalltalkArgs( javaArgCount );

			String javaMethodName = context.stackPop().toString();
			String javaClassName = context.stackPop().toString();
			SmallObject returnClass = context.stackPop();

			try {
				return SmallJavaObject.invokeStaticMethod( javaClassName, javaMethodName, javaArgs, returnClass );
			} catch( Exception e ) {
				throw new SmallException( "Error invoking static Java method: " + javaMethodName +
						", on: " + javaClassName + ", exception: " + e, context );
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
				throw new SmallException( "javaInvokeStaticMethod: Invalid argument count: " + argCount, context );

			// javaArgCount is minus return class, java class name, java method name and and has pairs for argType, argValue.
			int javaArgCount = ( argCount - 3 ) / 2;

			Class<?>[] javaArgTypes = new Class[ javaArgCount ];
			Object[] javaArgValues = new Object[ javaArgCount ];

			try {
				for( int argIndex = javaArgCount - 1; argIndex >= 0; argIndex-- ) {
					SmallObject smallObject = context.stackPop();
					javaArgValues[ argIndex ] = SmallJavaObject.smalltalkToJava( smallObject, context );
					String javaClassName = context.stackPop().toString();
					javaArgTypes[ argIndex ] = SmallJavaObject.loadClass( javaClassName );
				}
			} catch( Exception e ) {
				throw new SmallException( "javaClassInvokeStaticMethodTyped: Exception parsing arguments: " + e, context );
			}

			String javaMethodName = context.stackPop().toString();
			String javaClassName = context.stackPop().toString();
			SmallObject returnClass = context.stackPop();

			try {
				return SmallJavaObject.invokeStaticMethodTyped( javaClassName, javaMethodName, javaArgValues, javaArgTypes, returnClass );
			} catch( Exception e ) {
				throw new SmallException( "Error invoking static Java method: " + javaMethodName +
						", on: " + javaClassName + ", exception: " + e, context );
			}
		}

		// < 40 returnClass javaObject javaFieldName >
		// Read field form Java object.
		// Returns the Java return value converted tot returnClass.

		SmallObject javaObjectReadField()
				throws SmallException
		{
			String javaFieldName = context.stackPop().toString();
			SmallJavaObject javaObject = ( SmallJavaObject ) context.stackPop();
			SmallObject returnClass = context.stackPop();

			try {
				return javaObject.readField( javaFieldName, returnClass );
			} catch( Exception e ) {
				throw new SmallException( "Error reading Java field: " + javaFieldName +
						", on: " + javaObject + ", exception: " + e, context );
			}
		}

		// < 41 returnClass javaClassName javaFieldName >
		// Read field form Java object.
		// Returns the Java return value converted tot returnClass.

		SmallObject javaClassReadStaticField()
				throws SmallException
		{
			String javaFieldName = context.stackPop().toString();
			String javaClassName = context.stackPop().toString();
			SmallObject returnClass = context.stackPop();

			try {
				return SmallJavaObject.readStaticField( javaClassName, javaFieldName, returnClass );
			} catch( Exception e ) {
				throw new SmallException( "Error reading Java field: " + javaFieldName +
						", on: " + javaClassName + ", exception: " + e, context );
			}
		}

		// Read Smalltalk arguments from stack and return Java values for them in an array.

		Object[] javaParseSmalltalkArgs( int javaArgCount )
				throws SmallException
		{
			Object[] javaArgs = new Object[ javaArgCount ];

			for( int argIndex = javaArgCount - 1; argIndex >= 0; argIndex-- ) {
				SmallObject smallObject = context.stackPop();
				javaArgs[ argIndex ] = SmallJavaObject.smalltalkToJava( smallObject, context );
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
					SmallObject smallObject = context.stackPop();
					javaArgValues[ argIndex ] = SmallJavaObject.smalltalkToJava( smallObject, context );
					String javaClassName = context.stackPop().toString();
					javaArgTypes[ argIndex ] = SmallJavaObject.loadClass( javaClassName );
				}
			} catch( Exception e ) {
				throw new SmallException( "javaClassInvokeStaticMethodTyped: Exception parsing arguments: " + e, context );
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
				throw new SmallException( "javaAddEventListener: Invalid argument count: " + argCount, context );

			SmallObject smallEventClass = context.stackPop();
			SmallObject smallBlock = context.stackPop();
			int eventType = ( ( SmallInt ) context.stackPop() ).value;
			SmallJavaObject smallJavaObject = ( SmallJavaObject ) context.stackPop();

			if( ! smallJavaObject.addEventListener( eventType, smallBlock, smallEventClass, myThread ) )
				throw new SmallException( "Can't add Java event listener type: " + eventType, context );

			return smallJavaObject;
		}

		// < 46 returnClass javaClassName >
		// Loads Java class as SmallJavaObject.

		SmallObject javaLoadClass()
				throws SmallException
		{
			if( argCount < 2 )
				throw new SmallException( "LoadClass: Invalid argument count: " + argCount, context );

			String javaClassName = context.stackPop().toString();
			SmallObject smallClass = context.stackPop();

			try {
				return SmallJavaObject.loadClass( smallClass, javaClassName );
			} catch( Exception e ) {
				throw new SmallException( "Error creating Java object: " + javaClassName + ", exception: " + e, context );
			}
		}

		// < 50 floatClass smallInt >

		SmallObject floatFromSmallInt()
		{
			int smallInt = ( ( SmallInt ) context.stackPop() ).value;
			SmallObject floatClass = context.stackPop();

			return new SmallFloat( floatClass, smallInt );
		}

		// < 51 self arg >

		SmallObject floatAdd()
		{
			double arg = ( ( SmallFloat ) context.stackPop() ).value;
			SmallFloat selfObject = ( SmallFloat ) context.stackPop();
			double self = selfObject.value;
			SmallObject floatClass = selfObject.objClass;

			return new SmallFloat( floatClass, self + arg );
		}

		// < 52 self arg >

		SmallObject floatSubtract()
		{
			double arg = ( ( SmallFloat ) context.stackPop() ).value;
			SmallFloat selfObject = ( SmallFloat ) context.stackPop();
			double self = selfObject.value;
			SmallObject floatClass = selfObject.objClass;

			return new SmallFloat( floatClass, self - arg );
		}

		// < 53 self arg >

		SmallObject floatMultiply()
		{
			double arg = ( ( SmallFloat ) context.stackPop() ).value;
			SmallFloat selfObject = ( SmallFloat ) context.stackPop();
			double self = selfObject.value;
			SmallObject floatClass = selfObject.objClass;

			return new SmallFloat( floatClass, self * arg );
		}

		// < 54 self arg >

		SmallObject floatDivide()
		{
			double arg = ( ( SmallFloat ) context.stackPop() ).value;
			SmallFloat selfObject = ( SmallFloat ) context.stackPop();
			double self = selfObject.value;
			SmallObject floatClass = selfObject.objClass;

			return new SmallFloat( floatClass, self / arg );
		}

		// < 55 self arg >

		SmallObject floatLessThan()
		{
			double arg = ( ( SmallFloat ) context.stackPop() ).value;
			double self = ( ( SmallFloat ) context.stackPop() ).value;

			return ( self < arg ) ? image.trueObject : image.falseObject;
		}

		// < 56 self arg >

		SmallObject floatEquals()
		{
			double arg = ( ( SmallFloat ) context.stackPop() ).value;
			double self = ( ( SmallFloat ) context.stackPop() ).value;

			return ( self == arg ) ? image.trueObject : image.falseObject;
		}

		// < 57 self >

		SmallObject floatAsInteger()
		{
			double self = ( ( SmallFloat ) context.stackPop() ).value;

			return image.newInteger( ( int ) self );
		}
	}
}
