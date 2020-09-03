package smallj.core;

class SmallException extends Exception
{
    public SmallObject context;

    SmallException( String errorMessage, SmallObject aContext )
    {
        super( errorMessage );
        context = aContext;
    }
}
