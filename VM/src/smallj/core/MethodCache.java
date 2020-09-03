package smallj.core;

// Caches for message sends

public class MethodCache
{
    static final int cacheSize = 197;
    SmallObject[] selectors = new SmallObject[ cacheSize ];
    SmallObject[] classes = new SmallObject[ cacheSize ];
    SmallObject[] methods = new SmallObject[ cacheSize ];;

    public static long hits = 0;
    public static long misses = 0;

    // Lookup and return method in the cache
    // If not found, lookup method in Smalltalk and add it to the cache.
    // If still not found throw SmallException.

    SmallObject lookupOrSave( SmallContext context, SmallObject aSelector )
            throws SmallException
    {
        SmallObject aClass = context.getSelf().objClass;

        // Hash lookup values to array index.
        int index = Math.abs( aClass.hashCode() + aSelector.hashCode() ) % cacheSize;
        SmallObject selector = selectors[ index ];
        SmallObject _class = classes[ index ];
        SmallObject method = methods[ index ];

        // If not found, lookup method in context and add it to cache
        if( selector == null || selector != aSelector || _class != aClass ) {
            ++misses;
            method = context.lookupMethod( aClass, ( SmallByteArray ) aSelector );
            selectors[ index ] = aSelector;
            classes[ index ] = aClass;
            methods[ index ] = method;
        }
        else
            ++hits;

        return method;
    }
}
