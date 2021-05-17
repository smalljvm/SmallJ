import javax.swing.*;
import java.awt.*;

public class SmallJApp
{
	public SmallImage image;
	public SmallInterpreter interpreter;

	public static void main( String[] args )
	{
		new SmallJApp().run( args );
	}

	// First argument is image filename.
	// Second argument is Smalltalk startup expression.

	void run( String[] args )
	{
		// setDefaultFont();
		String defaultImageFileName = "image.sjim";
		String defaultStartupExpression = "SystemBrowser show";

		if( args.length >= 1 && ( args[ 0 ].equals( "-?" ) || args[ 0 ].equals( "/?" ) ) ) {
			System.out.println( "Usage: SmallJ [ image filename ] [ \"startup expression\" ]" );
			System.out.println( "    Default image filename: " + defaultImageFileName );
			System.out.println( "    Default startup expression: \"" + defaultStartupExpression + "\"" );
			System.out.println( "    Remember to quote the startup expression to make it a single string." );
			System.exit( 0 );
		}
		String imageFileName = args.length >= 1 ? args[ 0 ] : defaultImageFileName;
		if( ! loadImage( imageFileName ) )
			System.exit( 1 );

		String expression = args.length >= 2 ? args[ 1 ] : defaultStartupExpression;
		startInterpreter( expression );
	}

	// Set default for for easier code reading.
	// Todo? Move to Smalltalk.

	public void setDefaultFont()
	{
		System.out.println(javax.swing.UIManager.getDefaults().getFont("Dialog.font"));

		Font defaultFont = new Font( "Consolas", Font.PLAIN, 14 );
		Font defaultBoldFont = defaultFont.deriveFont( Font.BOLD );

		UIManager.getLookAndFeelDefaults().put( "defaultFont", defaultFont );

		java.util.Enumeration<Object> keys = UIManager.getDefaults().keys();
		while( keys.hasMoreElements() ) {
			Object key = keys.nextElement();
			Object object = UIManager.get( key );
			if( object instanceof javax.swing.plaf.FontUIResource ) {
				Font currentFont = ( Font ) object;
				Font newFont = currentFont.isBold() ? defaultBoldFont : defaultFont;
				UIManager.put( key, newFont );
			}
		}
	}

	// Load image in filename. Return true
	boolean loadImage( String imageFileName )
	{
		image = new SmallImage();
		try {
			image.load( imageFileName );
		} catch( Exception e ) {
			System.err.println( "SmallJ: Error reading image: " + imageFileName );
			return false;
		}
		return true;
	}

	void startInterpreter( String expression )
	{
		interpreter = new SmallInterpreter( image );
		try {
			interpreter.executeExpression( expression );
		} catch( Exception e ) {
			System.err.println( "SmallJ: Error executing startup expression: " + expression + ": " + e );
		}
	}
}
