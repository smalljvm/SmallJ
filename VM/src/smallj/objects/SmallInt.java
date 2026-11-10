class SmallInt extends SmallObject
{
	public int value;

	public SmallInt( SmallObject integerClass, int aValue )
	{
		super( integerClass, 0 );
		value = aValue;
	}

	@Override
	public String toString()
	{
		return "SmallInt: " + value;
	}
}
