package smallj.core;

// This class is for cached and encapsulated access to smalltalk Context and Bock instances.
// Data of the constructing context object is not copied but referred to.

// Smalltalk definitions:
// Context variables: 'method arguments temporaries stack bytePointer stackTop previousContext '
// Method variables: 'name byteCodes literals stackSize temporarySize class text'

public class SmallContext extends SmallObject
{
    SmallImage image;

    // Cashed values from Smalltalk objects within context.
    byte[] codes;
    int codesPointer;
    SmallObject[] stack;
    int stackTop;
    SmallObject[] temporaryVars;
    SmallObject[] instanceVars;
    SmallObject argumentVars;
    SmallObject[] literalVars;
    SmallObject method;

    static final int contextObjSize = 7;

    // Context variable indices
    public final static int methodIndex = 0;
    public final static int argumentVarsIndex = 1;
    public final static int temporaryVarsIndex = 2;
    public final static int stackIndex = 3;
    public final static int codesPointerIndex = 4;
    public final static int stackTopIndex = 5;
    public final static int previousContextIndex = 6;

    // Method data indices
    public final static int codesIndex = 1;
    public final static int literalVarsIndex = 2;
    public final static int stackSizeIndex = 3;
    public final static int temporarySizeIndex = 4;
    public final static int methodClassIndex = 5;

    // ArgumentVars indices
    public final static int instanceVarsIndex = 0;


    // Empty constructor is needed by SmallBlock

    SmallContext()
    {
    }

    // Attach to existing SmallObject context

    SmallContext( SmallImage aImage, SmallObject context )
    {
        super( context );
        image = aImage;
        setCachedValues();
    }

    // create new context

    SmallContext( SmallImage aImage, SmallObject oldContext, SmallObject aArgumentVars, SmallObject aMethod )
    {
        super( aImage.contextClass, contextObjSize );
        image = aImage;
        data[ methodIndex ] = aMethod;
        data[ argumentVarsIndex ] = aArgumentVars;

        // allocate temporaries
        int temporarySize = ( ( SmallInt ) ( aMethod.data[ temporarySizeIndex ] ) ).value;
        if( temporarySize > 0 ) {
            data[ temporaryVarsIndex ] = new SmallObject( image.arrayClass, temporarySize );
            temporaryVars = data[ temporaryVarsIndex ].data;
            for( int temporaryIndex = 0; temporaryIndex < temporarySize; ++ temporaryIndex )
                temporaryVars[ temporaryIndex ] = image.nilObject;
        }

        // allocate stack
        // todo: this should work...: int stackSize = ( ( SmallInt ) ( aMethod.data[ stackSizeIndex ] ) ).value;
        int stackSize = 20;
        data[ stackIndex ] = new SmallObject( image.arrayClass, stackSize );
        data[ codesPointerIndex ] = image.smallInts[ 0 ];
        data[ stackTopIndex ] = image.smallInts[ 0 ];
        data[ previousContextIndex ] = oldContext;

        setCachedValues();
    }

    void setCachedValues()
    {
        if( data.length == 0 )
            return;

        method = data[ methodIndex ];
        codes = ( ( SmallByteArray ) method.data[ codesIndex ] ).values;
        codesPointer = ( ( SmallInt ) data[ codesPointerIndex ] ).value;
        stack = data[ stackIndex ].data;
        stackTop = ( ( SmallInt ) data[ stackTopIndex ] ).value;

        // These are set lazily
        temporaryVars = null;
        instanceVars = null;
        argumentVars = null;
        literalVars = null;
    }

    boolean isNil()
    {
        return objClass == image.nilObject.objClass;
    }

    SmallObject getMethod()
    {
        if( method == null )
            method = data[ methodIndex ];

        return method;
    }

    SmallObject getMethodClass()
    {
        return method.data[ methodClassIndex ];
    }

    SmallObject getArgumentVars()
    {
		if( argumentVars == null )
            argumentVars = data[ argumentVarsIndex ];

        return argumentVars;
    }

    SmallObject[] getInstanceVars()
    {
		if( instanceVars == null )
            instanceVars = getArgumentVars().data[ instanceVarsIndex ].data;

        return instanceVars;
    }

    SmallObject getSelf()
    {
        return getArgumentVars().data[ instanceVarsIndex ];
    }

    SmallObject[] getTemporaryVars()
    {
		if( temporaryVars == null )
            temporaryVars = data[ temporaryVarsIndex ].data;

        return temporaryVars;
    }

    SmallObject[] getLiteralVars()
    {
        if( literalVars == null )
            literalVars = method.data[ literalVarsIndex ].data;

        return literalVars;
    }

    void saveCodesPointer()
    {
        data[ codesPointerIndex ] = image.newInteger( codesPointer );
    }

    void saveStackTop()
    {
        data[ stackTopIndex ] = image.newInteger( stackTop );
    }

    SmallObject getPreviousContext()
    {
        return data[ previousContextIndex ];
    }

    SmallObject getCreatingPreviousContext()
    {
        return data[ SmallBlock.creatingContextIndex ].data[ previousContextIndex ];
    }

    SmallObject stackPush( SmallObject smallObject )
    {
        return stack[ stackTop++ ] = smallObject;
    }

    SmallObject stackPop()
    {
        return stack[ -- stackTop ];
    }

    SmallObject stackGetTop()
    {
        return stack[ stackTop - 1 ];
    }

    SmallObject lookupMethod( SmallObject receiver, SmallByteArray messageSelector )
            throws SmallException
    {
        SmallObject aClass = receiver;
        String messageSelectorString = messageSelector.toString();
        while( aClass != image.nilObject ) {
            for( SmallObject aMethod : aClass.data[ 2 ].data )
                if( messageSelectorString.equals( aMethod.data[ 0 ].toString() ) )
                    return aMethod;
            aClass = aClass.data[ 1 ];    // Goto superclass
        }

        // try once to handle method in Smalltalk before giving up
        if( messageSelectorString.equals( "error:" ) )
            throw new SmallException( "Unrecognized message selector: " + messageSelector, this );

        SmallObject[] newArgs = new SmallObject[ 2 ];
        newArgs[ 0 ] = argumentVars.data[ 0 ]; // same receiver
        newArgs[ 1 ] = new SmallByteArray( messageSelector.objClass, "Unrecognized message selector: " + messageSelectorString );
        argumentVars.data = newArgs;

        return lookupMethod( receiver, new SmallByteArray( messageSelector.objClass, "error:" ) );
    }

    int nextCode()
    {
        return codes[ codesPointer++ ] & 0xFF;
    }

    // If argument is of type SmallContext, just cast it
    // Otherwise construct a new SmallContext object around the same data.
    // This is needed because some Context / Block objects are created in Smalltalk, not in Java.

    SmallContext castOrConvert( SmallObject aContextObj )
    {
        if( aContextObj instanceof SmallContext )
            return ( SmallContext ) aContextObj;

        return new SmallContext( image, aContextObj );
    }
}
