// Recursively writes basic objects, their classes and their member variables to the image.
// All classes can be found this way because the Class object is the parent of all meta classes,
// and it has a member variable than contains all classes.

import java.io.DataOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

class SmallImageWriter
{
    SmallImage image;

    // Variables used while saving.
    DataOutputStream stream;
    private int objectCount;
    private TreeMap< Integer, SmallObject > indexToObjectMap;
    private HashMap< SmallObject, Integer > objectToIndexMap;
    private ArrayList< Integer > rootIds;

    public SmallImageWriter( SmallImage aImage )
    {
        image = aImage;
    }

    // Main method: Save image to named file.

    public void save( String fileName )
            throws IOException
    {
        // Fill Id maps.
        initialize();
        mapRootObjects();

        // Write out file
        stream = new DataOutputStream( new FileOutputStream( fileName ) );

        writeHeader();
        writeObjectTypes();
        writeObjectValues();
        writeRootObjects();

        stream.close();
    }

    // Initialize for a new image save.

    private void initialize()
    {
        objectToIndexMap = new HashMap<>();
        indexToObjectMap = new TreeMap<>();
        rootIds = new ArrayList<>();
        objectCount = 0;
    }

    // Map image objects and classes to IDs.

    private void mapRootObjects()
    {
        mapRootObject( image.nilObject );
        mapRootObject( image.trueObject );
        mapRootObject( image.falseObject );
        for( SmallInt smallInt : image.smallInts )
            mapRootObject( smallInt );
        mapRootObject( image.arrayClass );
        mapRootObject( image.blockClass );
        mapRootObject( image.contextClass );
        mapRootObject( image.integerClass );
        mapRootObject( image.stringClass );
		mapRootObject( image.floatClass );
		mapRootObject( image.longClass );
    }

    private void mapRootObject( SmallObject obj )
    {
        mapObjectAndChildren( obj );
        rootIds.add( objectToIndexMap.get( obj ) );
    }

    private void mapObjectAndChildren( SmallObject obj )
    {
        if( ! objectToIndexMap.containsKey( obj ) ) {
            objectToIndexMap.put( obj, objectCount );
            indexToObjectMap.put( objectCount, obj );
            objectCount++;
            mapObjectAndChildren( obj.objClass );
            if( obj.data != null ) {
                for( SmallObject child : obj.data ) {
                    mapObjectAndChildren( child );
                }
            }
        }
    }

    // Write out objects in internal tables to output stream.

    private void writeHeader()
            throws IOException
    {
        // Write header: magic number, version and object count
        stream.writeInt( SmallImage.magic );
        stream.writeInt( SmallImage.version );
        stream.writeInt( objectCount );
    }

    private void writeObjectTypes()
            throws IOException
    {
        for( Map.Entry< Integer, SmallObject > entry : indexToObjectMap.entrySet() ) {
            SmallObject obj = entry.getValue();
            if( obj instanceof SmallByteArray ) {
                stream.writeByte( SmallImage.smallByteArrayType );
			} else if( obj instanceof SmallInt ) {
				stream.writeByte( SmallImage.smallIntType );
			} else if( obj instanceof SmallFloat ) {
				stream.writeByte( SmallImage.smallFloatType );
            } else if( obj instanceof SmallJavaObject ) {
                throw new RuntimeException( "JavaObject serialization not supported." );
            } else {
                stream.writeByte( SmallImage.smallObjectType );
            }
        }
    }

    private void writeObjectValues()
            throws IOException
    {
        for( Map.Entry< Integer, SmallObject > entry : indexToObjectMap.entrySet() ) {
            SmallObject obj = entry.getValue();
            stream.writeInt( objectToIndexMap.get( obj.objClass ) );
            // data (-1 if none)
            if( obj.data == null ) {
                stream.writeInt( - 1 );
            } else {
                stream.writeInt( obj.data.length );
                for( SmallObject child : obj.data ) {
                    stream.writeInt( objectToIndexMap.get( child ) );
                }
            }
            if( obj instanceof SmallInt ) {
                stream.writeInt( ( ( SmallInt ) obj ).value );
            }
			if( obj instanceof SmallFloat ) {
				stream.writeDouble( ( ( SmallFloat ) obj ).value );
			}
            if( obj instanceof SmallByteArray ) {
                SmallByteArray smallByteArray = ( SmallByteArray ) obj;
                stream.writeInt( smallByteArray.values.length );
                stream.write( smallByteArray.values );
            }
        }
    }

    private void writeRootObjects()
            throws IOException
    {
        // Write the count of small integers (special case)
        stream.writeInt( image.smallIntsLength );

        for( Integer rootId : rootIds ) {
            stream.writeInt( rootId );
        }
    }
}
