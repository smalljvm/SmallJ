package smallj.core;

// Smalltalk wrapper for Java objects.
// Dynamically loads Java classes, creates instances and invokes methods from Smalltalk primitives.

import java.awt.*;
import java.awt.event.*;
import java.util.HashMap;

import org.apache.commons.beanutils.ConstructorUtils;
import org.apache.commons.beanutils.MethodUtils;
import org.apache.commons.lang3.reflect.FieldUtils;

import javax.swing.*;
import javax.swing.event.ListSelectionListener;
import java.lang.reflect.InvocationTargetException;

class SmallJavaObject extends SmallObject
{
	public Object value;

	static HashMap< String, Class > classCache = new HashMap<>();

	SmallJavaObject( SmallObject aClass, Object aValue )
	{
		int size = ( ( SmallInt ) aClass.data[ SmallClass.sizeIndex ] ).value;
		objClass = aClass;
		data = new SmallObject[ size ];
		while( size > 0 )
			data[ -- size ] = SmallImage.current.nilObject;

		value = aValue;
	}

	// Create a new instance from the argument aClass using the constructor with argTypes.
	// Load class first if needed.

	SmallJavaObject( SmallObject aClass, String javaClassName, Object[] javaArgValues )
			throws Exception
	{
		super( aClass, ( ( SmallInt ) aClass.data[ SmallClass.sizeIndex ] ).value );
		Class javaClass = loadClass( javaClassName );
		value = ConstructorUtils.invokeConstructor( javaClass, javaArgValues );
	}

	SmallJavaObject( SmallObject aClass, String javaClassName, JavaArgs javaArgs )
			throws Exception
	{
		super( aClass, ( ( SmallInt ) aClass.data[ SmallClass.sizeIndex ] ).value );
		Class javaClass = loadClass( javaClassName );
		value = ConstructorUtils.invokeConstructor( javaClass, javaArgs.values, javaArgs.types );
	}

	// Load class by name, from cache if possible.

	public static Class loadClass( String className )
			throws ClassNotFoundException
	{
		Class aClass = classCache.get( className );

		if( aClass == null ) {
			ClassLoader classLoader = SmallJavaObject.class.getClassLoader();
			aClass = classLoader.loadClass( className );
			classCache.put( className, aClass );
		}

		return aClass;
	}

	// Invokes Java method on contained Java object in value member.
	// Java argument types are derived automatically from the types of the smalltalk argument values.
	// Returns a new SmallObject wrapping the return value with class set to smallClass.
	// Note: For basic types bool, int and String the class is set automatically, and smallClass is ignored.

	public SmallObject invokeMethod( String javaMethodName, Object[] javaArgValues, SmallObject returnClass )
			throws Exception
	{
		// Object returnValue = MethodUtils.invokeMethod( value, javaMethodName, javaArgValues );
		Object returnValue = fixedInvokeMethod( value, javaMethodName, javaArgValues );
		return javaToSmalltalk( returnValue, returnClass );
	}

	// Invokes Java method on contained Java object in value member.
	// Java argument types are explicitly passed in addition to the smalltalk argument values.
	// Returns a new SmallObject wrapping the return value with class set to smallClass.
	// Note: For basic types bool, int and String the class is set automatically, and smallClass is ignored.

	public SmallObject invokeMethodTyped( String javaMethodName, JavaArgs javaArgs, SmallObject returnClass )
			throws Exception
	{
		Object returnValue = MethodUtils.invokeMethod( value, javaMethodName, javaArgs.values, javaArgs.types );
		return javaToSmalltalk( returnValue, returnClass );
	}

	public static Object fixedInvokeMethod( Object object, String methodName, Object[] args )
			throws NoSuchMethodException, IllegalAccessException, InvocationTargetException
	{
		if( args == null )
			args = new Object[ 0 ];

		int argCount = args.length;
		Class< ? >[] argTypes = new Class[ argCount ];

		for( int index = 0; index < argCount; ++ index ) {
			Object arg = args[ index ];
			// Fix on Apache MethodUtils:
			// When a null pointer is passed as an argument, we treat it as a reference to an Object.
			// Note: Method overloading with different class types is not possible.
			// For that, all argument types need to be passed explicitly always. That's too much.
			argTypes[ index ] = arg == null ? object.getClass() : arg.getClass();
		}

		return MethodUtils.invokeMethod( object, methodName, args, argTypes );
	}

	// Invoke static method on Java class.

	static SmallObject invokeStaticMethod( String javaClassName, String javaMethodName, Object[] javaArgs, SmallObject returnClass )
			throws Exception
	{
		Class javaClass = loadClass( javaClassName );
		// Object returnValue = MethodUtils.invokeStaticMethod( javaClass, javaMethodName, javaArgs );
		Object returnValue = fixedInvokeStaticMethod( javaClass, javaMethodName, javaArgs );
		return javaToSmalltalk( returnValue, returnClass );
	}

	public static Object fixedInvokeStaticMethod( Class< ? > aClass, String methodName, Object[] args )
			throws NoSuchMethodException, IllegalAccessException, InvocationTargetException
	{
		if( args == null )
			args = new Object[ 0 ];

		int argCount = args.length;
		Class< ? >[] argTypes = new Class[ argCount ];

		for( int index = 0; index < argCount; ++ index ) {
			Object arg = args[ index ];
			// Fix on Apache MethodUtils:
			// When a null pointer is passed as an argument, we treat it as a reference to an Object.
			argTypes[ index ] = arg == null ? Object.class : arg.getClass();
		}

		return MethodUtils.invokeStaticMethod( aClass, methodName, args, argTypes );
	}

	static SmallObject invokeStaticMethodTyped( String className, String methodName, Object[] argValues, Class[] argTypes, SmallObject returnClass )
			throws Exception
	{
		Class javaClass = loadClass( className );
		Object returnValue = MethodUtils.invokeStaticMethod( javaClass, methodName, argValues, argTypes );
		return javaToSmalltalk( returnValue, returnClass );
	}

	// Reads Java field from contained Java object.
	// Returns a new SmallObject wrapping the return value with class set to smallClass.
	// Note: For basic types bool, int and String the class is set automatically, and smallClass is ignored.

	public SmallObject readField( String javaFieldName, SmallObject returnClass )
			throws Exception
	{
		Object returnValue = FieldUtils.readField( value, javaFieldName );
		return javaToSmalltalk( returnValue, returnClass );
	}

	// Reads Java static field from named Java class.
	// Returns a new SmallObject wrapping the return value with class set to smallClass.
	// Note: For basic types bool, int and String the class is set automatically, and smallClass is ignored.

	public static SmallObject readStaticField( String javaClassName, String javaFieldName, SmallObject returnClass )
			throws Exception
	{
		Class javaClass = loadClass( javaClassName );
		Object returnValue = FieldUtils.readStaticField( javaClass, javaFieldName );
		return javaToSmalltalk( returnValue, returnClass );
	}

	// Returns a new Java Object for Smalltalk object.
	// Note: For basic types bool, int and String the class is set automatically, and smallClass is ignored.

	static Object smalltalkToJava( SmallObject smallObject, SmallContext context )
			throws SmallException
	{
		if( smallObject.objClass == SmallImage.current.integerClass )
			return ( ( SmallInt ) smallObject ).value;

		if( smallObject.objClass == SmallImage.current.stringClass )
			return smallObject.toString();

		if( smallObject == SmallImage.current.nilObject )
			return null;

		if( smallObject == SmallImage.current.trueObject )
			return true;

		if( smallObject == SmallImage.current.falseObject )
			return false;

		if( smallObject.objClass == SmallImage.current.longClass )
			return ( ( SmallLong ) smallObject ).value;

		if( smallObject.objClass == SmallImage.current.floatClass )
			return ( ( SmallFloat ) smallObject ).value;

		if( smallObject instanceof SmallJavaObject )
			return ( ( SmallJavaObject ) smallObject ).value;

		// No supported Java parameter found.
		throw new SmallException( "smalltalkToJava: Invalid parameter: " + smallObject, context );
	}

	// Returns a new SmallObject wrapping the return value with class set to smallClass.
	// Note: For basic types bool, int and String the class is set automatically, and smallClass is ignored.

	static SmallObject javaToSmalltalk( Object javaObject, SmallObject smallClass )
	{
		if( javaObject == null || smallClass == null || smallClass == SmallImage.current.nilObject )
			return SmallImage.current.nilObject;

		if( javaObject instanceof Integer )
			return SmallImage.current.newInteger( ( Integer ) javaObject );

		if( javaObject instanceof Boolean )
			return ( Boolean ) javaObject ? SmallImage.current.trueObject : SmallImage.current.falseObject;

		if( javaObject instanceof String )
			return new SmallByteArray( SmallImage.current.stringClass, ( String ) javaObject );

		if( javaObject instanceof Long )
			return SmallImage.current.newLong( ( Long ) javaObject );

		if( javaObject instanceof Double )
			return SmallImage.current.newFloat( ( Double ) javaObject );

		// Chars are returned as ints for now...
		if( javaObject instanceof Character )
			return SmallImage.current.newInteger( ( Character ) javaObject );

		// Not a basic type, so create Java Object of desired class.
		return new SmallJavaObject( smallClass, javaObject );
	}

	static SmallJavaObject loadClass( SmallObject aClass, String javaClassName )
			throws ClassNotFoundException
	{
		Class javaClass = loadClass( javaClassName );
		return new SmallJavaObject( aClass, javaClass );
	}

	// Event types:
	// 1 = windowClosing, 2 = buttonAction, 3 = adjustment (scrollbar),
	// 4 = mousePressed, 4 = mouseReleased, 5 = mouseMoved (move & drag),
	// 7 = listSelection, 8 = mouseClicked

	boolean addEventListener( int eventType, SmallObject smallBlock, SmallObject smallEventClass, Thread myThread )
	{
		switch( eventType ) {
			case 1:
				addWindowCloseListener( smallBlock, smallEventClass, myThread );
				break;
			case 2:
				addButtonActionListener( smallBlock, smallEventClass, myThread );
				break;
			case 3:
				addAdjustmentListener( smallBlock, smallEventClass, myThread );
				break;
			case 4:
				addMousePressedListener( smallBlock, smallEventClass, myThread );
				break;
			case 5:
				addMouseReleasedListener( smallBlock, smallEventClass, myThread );
				break;
			case 6:
				addMouseMovedListener( smallBlock, smallEventClass, myThread );
				break;
			case 7:
				addListSelectionListener( smallBlock, smallEventClass, myThread );
				break;
			case 8:
				addMouseClickedListener( smallBlock, smallEventClass, myThread );
				break;
			default:
				return false;
		}
		return true;
	}

	void addWindowCloseListener( SmallObject smallBlock, SmallObject smallEventClass, Thread myThread )
	{
		WindowAdapter windowAdapter = new WindowAdapter()
		{
			@Override
			public void windowClosing( WindowEvent event )
			{
				new SmallThread( smallBlock, myThread, smallEventClass, event ).start();
			}
		};
		JFrame frame = ( JFrame ) value;
		frame.addWindowListener( windowAdapter );
		frame.setDefaultCloseOperation( WindowConstants.DO_NOTHING_ON_CLOSE );
	}

	// This handler is used for button press and menu select.

	void addButtonActionListener( SmallObject smallBlock, SmallObject smallEventClass, Thread myThread )
	{
		ActionListener actionListener =
				event -> new SmallThread( smallBlock, myThread, smallEventClass, event ).start();
		( ( AbstractButton ) value ).addActionListener( actionListener );
	}

	void addAdjustmentListener( SmallObject smallBlock, SmallObject smallEventClass, Thread myThread )
	{
		AdjustmentListener adjustmentListener =
				event -> new SmallThread( smallBlock, myThread, smallEventClass, event ).start();
		( ( Adjustable ) value ).addAdjustmentListener( adjustmentListener );
	}

	void addMousePressedListener( SmallObject smallBlock, SmallObject smallEventClass, Thread myThread )
	{
		MouseAdapter mouseAdapter = new MouseAdapter()
			{
				@Override
				public void mousePressed( MouseEvent event )
				{
					new SmallThread( smallBlock, myThread, smallEventClass, event ).start();
				}
			};
		( ( JComponent ) value ).addMouseListener( mouseAdapter );
	}

	void addMouseReleasedListener( SmallObject smallBlock, SmallObject smallEventClass, Thread myThread )
	{
		MouseAdapter mouseAdapter = new MouseAdapter()
		{
			@Override
			public void mouseReleased( MouseEvent event )
			{
				new SmallThread( smallBlock, myThread, smallEventClass, event ).start();
			}
		};
		( ( JComponent ) value ).addMouseListener( mouseAdapter );
	}

	void addMouseClickedListener( SmallObject smallBlock, SmallObject smallEventClass, Thread myThread )
	{
		MouseAdapter mouseAdapter = new MouseAdapter()
		{
			@Override
			public void mouseClicked( MouseEvent event )
			{
				new SmallThread( smallBlock, myThread, smallEventClass, event ).start();
			}
		};
		( ( JComponent ) value ).addMouseListener( mouseAdapter );
	}

	void addMouseMovedListener( SmallObject smallBlock, SmallObject smallEventClass, Thread myThread )
	{
		MouseMotionListener mouseMotionListener = new MouseMotionListener()
		{
			@Override
			public void mouseMoved( MouseEvent event )
			{
				new SmallThread( smallBlock, myThread, smallEventClass, event ).start();
			}

			@Override
			public void mouseDragged( MouseEvent event )
			{
				new SmallThread( smallBlock, myThread, smallEventClass, event ).start();
			}
		};
		( ( JComponent ) value ).addMouseMotionListener( mouseMotionListener );
	}

	void addListSelectionListener(  SmallObject smallBlock, SmallObject smallEventClass, Thread myThread )
	{
		ListSelectionListener listSelectionListener =
				event -> { if( event.getValueIsAdjusting() ) 	// Filter out double event on mouse-up.
					new SmallThread( smallBlock, myThread, smallEventClass, event ).start(); };
		( ( JList ) value ).addListSelectionListener( listSelectionListener );
	}
}
