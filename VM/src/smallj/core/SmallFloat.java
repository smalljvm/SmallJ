package smallj.core;

class SmallFloat extends SmallObject
{
	// Smalltalk float is represented as a Java double precision floating point number.
	public double value;

	public SmallFloat( SmallObject floatClass, double aValue )
	{
		super( floatClass, 0 );
		value = aValue;
	}

	@Override
	public String toString()
	{
		return "SmallFloat: " + value;
	}
}
