package smallj.test;

import javax.swing.*;
import java.awt.*;
import java.beans.*;
import java.util.EventObject;
import java.awt.event.MouseEvent;

// This class is for generic event handling in stead of hard coded.
// Is not used at the moment.

public class EventBrokerNew
{
	public static void main( String[] args )
	{
		new EventBrokerNew().start();
	}

	void start()
	{
		JButton button = new JButton( "Click Me" );
		listenToAllEvents( button, this, "myEventHandler" );

		JFrame frame = new JFrame( "Generic Event Listener" );
		frame.getContentPane().add( button, BorderLayout.PAGE_START );
		frame.pack();
		frame.setVisible( true );
	}

	void listenToAllEvents( Object component, Object listener, String methodName )
	{
		BeanInfo beanInfo;
		try {
			beanInfo = Introspector.getBeanInfo( component.getClass() );
		} catch ( IntrospectionException ex ) {
			System.err.println( ex );
			return;
		}

		for ( EventSetDescriptor eventSetDescriptor : beanInfo.getEventSetDescriptors() ) {
			try {
				Class listenerClass = eventSetDescriptor.getListenerType();
				Object eventHandler = EventHandler.create( listenerClass, listener, methodName, "" );
				eventSetDescriptor.getAddListenerMethod().invoke( component, eventHandler );
			} catch ( ReflectiveOperationException ex ) {
				System.err.println( ex );
			}
		}
	}

	public void myEventHandler( EventObject event )
	{
		if( event instanceof MouseEvent )
			System.out.println( event );
	}
}
