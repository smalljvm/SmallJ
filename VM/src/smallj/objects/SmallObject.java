public class SmallObject
{
	public SmallObject[] data;
	public SmallObject objClass;

	public SmallObject()
	{
		objClass = null;
		data = null;
	}

	public SmallObject( SmallObject smallObject )
	{
		objClass = smallObject.objClass;
		data = smallObject.data;
	}

	public SmallObject( SmallObject aClass, int size )
	{
		objClass = aClass;
		data = new SmallObject[ size ];
		while( size > 0 )
			data[ -- size ] = SmallImage.current.nilObject;
	}

	public SmallObject copy( SmallObject aClass )
	{
		return this;
	}

	// Resize data array to new size.
	// Copy old data as much as possible.
	// New empty slots are set to nilObject.

	public void resize( int newSize )
	{
		SmallObject[] newData = new SmallObject[ newSize ];

		int copySize = Math.min( newSize, data.length );
		System.arraycopy( data, 0, newData, 0, copySize );

		// Fill remaining part with nil objects
		for( int index = copySize; index < newSize; ++ index )
			newData[ index ] = SmallImage.current.nilObject;

		data = newData;
	}
}
