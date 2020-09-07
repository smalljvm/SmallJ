package smallj.core;

// Small helper class for pairing java argument types and values used with typed method invocation.

// @SuppressWarnings( "rawtypes" )
public class JavaArgs
{
	public Class<?>[] types;
	public Object[] values;

	JavaArgs( Class<?>[] aTypes, Object[] aValues )
	{
		types = aTypes;
		values = aValues;
	}
}
