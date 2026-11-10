// Encapsulated access to smalltalk Bock instances.

// Smalltalk definitions:
// Context variables: 'method arguments temporaries stack bytePointer stackTop previousContext '
// Block variables, after Context: 'argumentLocation creatingContext oldBytePointer'

public class SmallBlock extends SmallContext
{

    public static final int objectSize = 10;

    // Block variable indices, after Context
    public final static int argumentLocationIndex = 7;
    public final static int creatingContextIndex = 8;
    public final static int oldCodesPointerIndex = 9;

    SmallBlock( SmallImage aImage )
    {
        image = aImage;
        objClass = image.blockClass;
        data = new SmallObject[ objectSize ];
    }

    SmallBlock( SmallContext context, int argumentLocation )
    {
        image = context.image;
        objClass = image.blockClass;
        data = new SmallObject[ objectSize ];

        data[ methodIndex ] = context.data[ methodIndex ];
        data[ argumentVarsIndex ] = context.data[ argumentVarsIndex ];
        data[ temporaryVarsIndex ] = context.data[ temporaryVarsIndex ];
        data[ stackIndex ] = context.data[ stackIndex ];    // later replaced
        data[ codesPointerIndex ] = image.newInteger( context.codesPointer );
        data[ stackTopIndex ] = image.smallInts[ 0 ];
        data[ previousContextIndex ] = context.data[ previousContextIndex ];
        data[ argumentLocationIndex ] = image.newInteger( argumentLocation );
        data[ creatingContextIndex ] = context;
        data[ oldCodesPointerIndex ] = image.newInteger( context.codesPointer );
    }

    // Prepare self as invokable context, with arguments from the stack.
    // Also saves argument context for later return.
    // Returns this.

    // Stack: < 8 self > or < 8 arg1 self >  or < 8 arg1 arg2 self >
    //        The stack order is non-standard here to be able to determine the variable number of arguments.

    SmallBlock invoke( int argCount, SmallContext context )
    {
        // Save context.
        context.data[ stackTopIndex ] = image.newInteger( context.stackTop );
        context.data[ codesPointerIndex ] = image.newInteger( context.codesPointer );

        // Retrieve arguments.
        int argBase = ( ( SmallInt ) data[ argumentLocationIndex ] ).value;
        int blockArgCount = argCount - 2;
        if( blockArgCount >= 0 ) {
            SmallObject[] _temporaryVars = data[ temporaryVarsIndex ].data;
            while( blockArgCount >= 0 ) {
                _temporaryVars[ argBase + blockArgCount-- ] = context.stackPop();
            }
        }

        data[ previousContextIndex ] = context.data[ previousContextIndex ];
        data[ stackTopIndex ] = image.smallInts[ 0 ];
        data[ codesPointerIndex ] = data[ oldCodesPointerIndex ]; // starting address
        int stackSize = data[ stackIndex ].data.length;
        data[ stackIndex ] = new SmallObject( image.arrayClass, stackSize );

        return this;
    }

    // Set single argument for self.

    void setOneArg( SmallObject arg1 )
    {
        int argLoc = ( ( SmallInt ) data[ argumentLocationIndex ] ).value;
        data[ temporaryVarsIndex ].data[ argLoc ] = arg1;
    }

    // Set two arguments for self.

    void setTwoArgs( SmallObject arg1, SmallObject arg2 )
    {
        int argLoc = ( ( SmallInt ) data[ argumentLocationIndex ] ).value;
        data[ temporaryVarsIndex ].data[ argLoc ] = arg1;
        data[ temporaryVarsIndex ].data[ argLoc + 1 ] = arg2;
    }

    void prepareRun()
    {
        int stackSize = data[ SmallContext.stackIndex ].data.length;
        data[ stackIndex ] = new SmallObject( image.arrayClass, stackSize );
        data[ stackTopIndex ] = image.newInteger( 0 );
        data[ codesPointerIndex ] = data[ oldCodesPointerIndex ];
        data[ previousContextIndex ] = image.nilObject;
    }

    void copyDataFrom( SmallObject sourceBlock )
    {
        System.arraycopy( sourceBlock.data, 0, data, 0, objectSize );
    }
}
