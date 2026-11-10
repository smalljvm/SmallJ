public class SmallInterpreter
{
	public SmallImage image;
	SmallOperations operations = new SmallOperations( this );
	SmallPrimitives primitives = new SmallPrimitives( this );

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
}
