import javax.swing.*;
import java.util.EventObject;

import static javax.swing.JOptionPane.ERROR_MESSAGE;

public class SmallThread extends Thread
{
	private final SmallBlock block;
	private final Thread myThread;

	public SmallThread( SmallObject aBlock, Thread aMyThread )
	{
		myThread = aMyThread;
		block = new SmallBlock( SmallImage.current );
		block.copyDataFrom( aBlock );
	}

	public SmallThread( SmallObject aBlock, Thread aMyThread, SmallObject smallEventClass, EventObject event )
	{
		this( aBlock, aMyThread );
		SmallJavaObject smallEventObject = new SmallJavaObject( smallEventClass, event );
		block.setOneArg( smallEventObject );
	}

	@Override
	public void run()
	{
		block.prepareRun();
		try {
			new SmallInterpreter( SmallImage.current ).execute( block, this, myThread );
		} catch( Exception e ) {
			JOptionPane.showMessageDialog( null, e, "Exception", ERROR_MESSAGE );
		}
	}
}
