class SmallByteArray extends SmallObject
{
    public byte[] values;

    public SmallByteArray( SmallObject aClass, int size )
    {
        super( aClass, 0 );
        values = new byte[ size ];
    }

    public SmallByteArray( SmallObject aClass, String text )
    {
        super( aClass, 0 );
        int size = text.length();
        values = new byte[ size ];
        for( int i = 0; i < size; i++ )
            values[ i ] = ( byte ) text.charAt( i );
    }

    @Override
    public SmallObject copy( SmallObject aClass )
    {
        SmallByteArray newObj = new SmallByteArray( aClass, values.length );
        for( int i = 0; i < values.length; i++ ) {
            newObj.values[ i ] = values[ i ];
        }
        return newObj;
    }

    @Override
    public String toString()
    {
        // we assume its a string, tho not always true...
        return new String( values );
    }
}
