package smallj.core;

import java.io.*;

/**
    Maintains Smalltalk image.

    Holds references to specific objects in the system:
    nil, true, false, Array, Block, Context, Integer and the numbers 0-9.

    From these references, you can get to Class, which holds
    references to all the classes in the system in Class#classes.

    Performs loading and saving from and to a file.
    Only the basic objects above, all classes and their instance variables are saved in the image.
    SmallJavaObjects are not saved.
*/

public class SmallImage
{
    public static SmallImage current;

    static final int magic = 0x534A494D ;    // "SJIM"
    static final int version = 0;

    // Object types in image
    static final int smallObjectType = 0;
    static final int smallIntType = 1;
    static final int smallByteArrayType = 2;
	static final int smallFloatType = 3;

    String fileName;

    public int smallIntsLength = 10;

    // Global constants, in order of location in image.
    public SmallObject nilObject;
    public SmallObject trueObject;
    public SmallObject falseObject;
    public SmallInt[] smallInts;
    public SmallObject arrayClass;
    public SmallObject blockClass;
    public SmallObject contextClass;
    public SmallObject integerClass;
	public SmallObject stringClass;
	public SmallObject floatClass;
	public SmallObject charClass;
	public SmallObject longClass;

    SmallImage()
    {
        current = this;
    }

    // Load image from file.

    public void load( String aFileName )
            throws Exception
    {
        fileName = aFileName;

        new SmallImageReader( this ).load( fileName );
    }

    public void saveAs( String aFileName )
        throws IOException
    {
        fileName = aFileName;
        save();
    }
    public void save()
        throws IOException
    {
        new SmallImageWriter( this ).save( fileName );
    }

    SmallInt newInteger( int value )
    {
        // Optimized case for integers [ 0 .. 9 ].
        if( value >= 0 && value < smallIntsLength )
            return smallInts[ value ];

        return new SmallInt( integerClass, value );
    }

	SmallLong newLong( long value )
	{
		return new SmallLong( longClass, value );
	}

    // Smalltalk Float class is implemented with Java double type.

	SmallFloat newFloat( double value )
	{
		return new SmallFloat( floatClass, value );
	}
}
