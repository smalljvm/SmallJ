package smallj.core;

class SmallException extends Exception
{
	// Unique number for serializing. Unused but prevents VSCode warning.
	private static final long serialVersionUID = 750551701695347665L;

	public SmallObject context;

    SmallException( String errorMessage, SmallObject aContext )
    {
        super( errorMessage );
        context = aContext;
    }
}
