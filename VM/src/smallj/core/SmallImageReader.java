package smallj.core;

import java.io.*;

// Load image file indicated by argument.

public class SmallImageReader
{
    private SmallImage image;
    private DataInputStream stream;

    int objCount;
    private SmallObject[] objArray;

    public SmallImageReader( SmallImage aImage )
    {
        image = aImage;
    }

    void load( String fileName )
            throws IOException
    {
        stream = new DataInputStream( new FileInputStream( fileName ) );

        readHeader();
        readObjectTypes();
        readObjectValues();
        readRootObjects();

        stream.close();
    }

    private void readHeader()
            throws IOException
    {
        if( stream.readInt() != SmallImage.magic )
            throw new RuntimeException( "Bad magic number." );

        if( stream.readInt() != SmallImage.version )
            throw new RuntimeException( "Bad version number." );

        objCount = stream.readInt();
    }

    // Construct placeholder objects in objArray.
    // Index is used for object references.

    private void readObjectTypes()
            throws IOException
    {
        objArray = new SmallObject[ objCount ];

        for( int index = 0; index < objCount; index++ ) {
            int objType = stream.readByte();
            switch( objType ) {
                case SmallImage.smallObjectType:
                    objArray[ index ] = new SmallObject();
                    break;
                case SmallImage.smallIntType:
                    objArray[ index ] = new SmallInt( null, 0 );
                    break;
                case SmallImage.smallByteArrayType:
                    objArray[ index ] = new SmallByteArray( null, 0 );
                    break;
				case SmallImage.smallFloatType:
					objArray[ index ] = new SmallFloat( null, 0 );
					break;
                default:
                    throw new RuntimeException( "Unknown object type: " + objType );
            }
        }
    }

    // Create data members in objects
    // and point them to the correct objects in objArray using the index as ids.

    private void readObjectValues()
            throws IOException
    {
        for( int index = 0; index < objCount; index++ ) {
            SmallObject obj = objArray[ index ];
            obj.objClass = objArray[ stream.readInt() ];
            int dataLength = stream.readInt();
            if( dataLength == - 1 ) {
                obj.data = null;
            } else {
                obj.data = new SmallObject[ dataLength ];
                for( int dataIndex = 0; dataIndex < dataLength; dataIndex++ ) {
                    obj.data[ dataIndex ] = objArray[ stream.readInt() ];
                }
            }

            // Set type specific data in value member of objects
            if( obj instanceof SmallInt ) {
                SmallInt smallInt = ( SmallInt ) obj;
                smallInt.value = stream.readInt();
            }
			else if( obj instanceof SmallFloat ) {
				SmallFloat smallFloat = ( SmallFloat ) obj;
				smallFloat.value = stream.readDouble();
			}
            else if( obj instanceof SmallByteArray ) {
                SmallByteArray smallByteArray = ( SmallByteArray ) obj;
                int arrayLength = stream.readInt();
                smallByteArray.values = new byte[ arrayLength ];
                stream.read( smallByteArray.values );
            }
        }
    }

    private void readRootObjects()
            throws IOException
    {
        // Number of small integers with fixed allocation in image, normally 10.
        image.smallIntsLength = stream.readInt();

        // Read root objects
        image.nilObject = readNextRoot();
        image.trueObject = readNextRoot();
        image.falseObject = readNextRoot();
        image.smallInts = new SmallInt[ image.smallIntsLength ];
        for( int index = 0; index < image.smallIntsLength; index++ )
            image.smallInts[ index ] = ( SmallInt ) readNextRoot();
        image.arrayClass = readNextRoot();
        image.blockClass = readNextRoot();
        image.contextClass = readNextRoot();
        image.integerClass = readNextRoot();
        image.stringClass = readNextRoot();
		image.floatClass = readNextRoot();
		image.longClass = readNextRoot();
    }

    SmallObject readNextRoot()
            throws IOException
    {
        return objArray[ stream.readInt() ];
    }
}
