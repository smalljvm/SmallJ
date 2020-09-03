package smallj.core;

class SmallLong extends SmallObject
{
	public long value;

	public SmallLong( SmallObject longClass, long aValue )
	{
		super( longClass, 0 );
		value = aValue;
	}

	@Override
	public String toString()
	{
		return "SmallLong: " + value;
	}
}
