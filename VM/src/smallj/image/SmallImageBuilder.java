// Builds a new Smalltalk image from the *.st source files, without needing an existing image.
//
// Mirrors what happens in Smalltalk when classes are filed in (see ClassParser.st and Class.st):
// - Every class X is an instance of its metaclass 'MetaX', which is an instance of Class.
// - The metaclass of Object has Class as its parent; Object has no parent.
// - Class variables of X are instance variables of MetaX, so their values are stored in the X class object.
// - Class>>classes holds all (non-meta) classes, sorted by name.
// Methods are compiled with SmallCompiler.
//
// Usage from the command line, in the Smalltalk folder:
//     java -cp smallj.jar SmallImageBuilder [ sourceFolder [ imageFileName ] ]

import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

public class SmallImageBuilder
{
	// Source definition of one class, from its CLASS line.
	static class ClassSource
	{
		String name;
		String parentName;		// null for Object
		List< String > variables;	// null for Object
		List< String > classVariables;
		String fileName;		// Relative to source folder, with forward slashes.
		List< String > lines;
		SmallObject classObject;
		SmallObject metaClassObject;
		int metaClassSize;		// Number of variables in class object.
	}

	static final Pattern subclassPattern = Pattern.compile(
		"(\\w+)\\s+subclass:\\s*'(\\w+)'\\s+variables:\\s*'([^']*)'\\s+classVariables:\\s*'([^']*)'\\s*\\.?" );

	SmallImage image;
	Map< String, ClassSource > classSources = new LinkedHashMap<>();
	SmallObject classClass;

	public static void main( String[] args )
			throws IOException
	{
		String sourceFolder = args.length >= 1 ? args[ 0 ] : ".";
		String imageFileName = args.length >= 2 ? args[ 1 ] : "new.sjim";
		build( sourceFolder, imageFileName );
	}

	// Main function: build image from all *.st files in (subfolders of) sourceFolder and save it.
	// Source file names are stored relative to sourceFolder,
	// so SmallJ should be started from sourceFolder when using the new image.

	public static SmallImage build( String sourceFolder, String imageFileName )
			throws IOException
	{
		SmallImageBuilder builder = new SmallImageBuilder();
		builder.readSources( Paths.get( sourceFolder ) );
		builder.createClasses();
		builder.compileMethods();
		builder.image.saveAs( imageFileName );
		System.out.println( "SmallImageBuilder: Saved image with " + builder.classSources.size() + " classes: " + imageFileName );
		return builder.image;
	}

	// ============================================= Reading sources

	void readSources( Path sourceFolder )
			throws IOException
	{
		List< Path > files;
		try( Stream< Path > stream = Files.walk( sourceFolder ) ) {
			files = stream.filter( path -> path.toString().endsWith( ".st" ) ).sorted().toList();
		}
		for( Path file : files ) {
			ClassSource source = parseClassLine( file, readLines( file ) );
			source.fileName = sourceFolder.relativize( file ).toString().replace( '\\', '/' );
			if( classSources.containsKey( source.name ) )
				throw new RuntimeException( "Class " + source.name + " defined twice, in: " + classSources.get( source.name ).fileName + " and " + source.fileName );
			classSources.put( source.name, source );
		}
		if( ! classSources.containsKey( "Object" ) || ! classSources.containsKey( "Class" ) )
			throw new RuntimeException( "Source files for Object and Class not found in: " + sourceFolder.toAbsolutePath() );
	}

	// Read lines the same way the Smalltalk File class does, with java.io.DataInputStream.
	// This maps each byte to one character, as Smalltalk strings are byte arrays.

	@SuppressWarnings( "deprecation" )
	static List< String > readLines( Path file )
			throws IOException
	{
		List< String > lines = new ArrayList<>();
		try( DataInputStream stream = new DataInputStream( new FileInputStream( file.toFile() ) ) ) {
			String line;
			while( ( line = stream.readLine() ) != null )
				lines.add( line );
		}
		return lines;
	}

	// Parse the first line of a source file:
	//     CLASS Parent subclass: 'Name' variables: 'a b' classVariables: 'c'
	// or, for the root class only:
	//     CLASS Object

	ClassSource parseClassLine( Path file, List< String > lines )
	{
		String keyword = "CLASS";
		if( lines.isEmpty() || ! lines.get( 0 ).startsWith( keyword ) )
			throw new RuntimeException( file + ": CLASS keyword not found on start of first line" );
		String definition = lines.get( 0 ).substring( keyword.length() ).trim();

		ClassSource source = new ClassSource();
		source.lines = lines;
		if( definition.equals( "Object" ) ) {
			source.name = "Object";
			source.classVariables = List.of();
			return source;
		}
		Matcher matcher = subclassPattern.matcher( definition );
		if( ! matcher.matches() )
			throw new RuntimeException( file + ": Cannot parse class definition: " + definition );
		source.parentName = matcher.group( 1 );
		source.name = matcher.group( 2 );
		source.variables = asWords( matcher.group( 3 ) );
		source.classVariables = asWords( matcher.group( 4 ) );
		return source;
	}

	// Same as String>>asWords: split on spaces.

	static List< String > asWords( String text )
	{
		return Arrays.stream( text.split( " " ) ).filter( word -> ! word.isEmpty() ).toList();
	}

	// ============================================= Creating classes

	void createClasses()
	{
		image = new SmallImage();

		// Basic objects first, because new SmallObjects are filled with nilObject.
		image.nilObject = new SmallObject();
		image.nilObject.data = new SmallObject[ 0 ];
		image.trueObject = new SmallObject( null, 0 );
		image.falseObject = new SmallObject( null, 0 );
		image.smallInts = new SmallInt[ image.smallIntsLength ];
		for( int value = 0; value < image.smallIntsLength; value++ )
			image.smallInts[ value ] = new SmallInt( null, value );

		// Create class and metaclass objects, parents before children.
		for( ClassSource source : classSources.values() )
			createClass( source, new ArrayList<>() );

		classClass = classObject( "Class" );
		image.arrayClass = classObject( "Array" );
		image.blockClass = classObject( "Block" );
		image.contextClass = classObject( "Context" );
		image.integerClass = classObject( "SmallInt" );
		image.stringClass = classObject( "String" );
		image.floatClass = classObject( "Float" );
		image.charClass = classObject( "Char" );
		image.longClass = classObject( "SmallLong" );
		classObject( "Method" );		// Check classes needed by the compiler.
		classObject( "ByteArray" );

		image.nilObject.objClass = classObject( "Undefined" );
		image.trueObject.objClass = classObject( "True" );
		image.falseObject.objClass = classObject( "False" );
		for( SmallInt smallInt : image.smallInts )
			smallInt.objClass = image.integerClass;

		// Now that String and Array exist, fill in the class variables of all classes.
		for( ClassSource source : classSources.values() )
			initializeClass( source );

		// Class variable 'classes' of Class: all classes sorted by name.
		List< SmallObject > classes = classSources.values().stream()
			.sorted( ( a, b ) -> compareStrings( a.name, b.name ) )
			.map( source -> source.classObject ).toList();
		classClass.data[ SmallClass.instVarCount + SmallClass.classesIndex ] = newArray( classes );
	}

	// Create class and metaclass objects, after creating parent classes.
	// The size of a class object depends on the number of (inherited) class variables.
	// Size fields are set later, in initializeClass, because the SmallInt class is not known yet.

	void createClass( ClassSource source, List< String > path )
	{
		if( source.classObject != null )
			return;
		if( path.contains( source.name ) )
			throw new RuntimeException( "Circular class hierarchy: " + path );
		path.add( source.name );

		int metaClassSize;
		if( source.parentName == null ) {
			// Object metaclass inherits from Class.
			metaClassSize = SmallClass.instVarCount + source.classVariables.size();
		} else {
			ClassSource parent = classSources.get( source.parentName );
			if( parent == null )
				throw new RuntimeException( source.fileName + ": Unknown parent class: " + source.parentName );
			createClass( parent, path );
			metaClassSize = parent.metaClassSize + source.classVariables.size();
		}
		source.metaClassObject = new SmallObject( null, SmallClass.instVarCount );
		source.classObject = new SmallObject( source.metaClassObject, metaClassSize );
		source.metaClassSize = metaClassSize;
	}

	int instanceSize( ClassSource source )
	{
		if( source.parentName == null )
			return source.variables == null ? 0 : source.variables.size();
		return instanceSize( classSources.get( source.parentName ) ) + source.variables.size();
	}

	// Set instance variables of class and metaclass objects, as in Class>>name:parent:variables:.

	void initializeClass( ClassSource source )
	{
		SmallObject metaClass = source.metaClassObject;
		SmallObject aClass = source.classObject;
		boolean isRoot = source.parentName == null;

		metaClass.objClass = classClass;
		metaClass.data[ SmallClass.nameIndex ] = newString( "Meta" + source.name );
		metaClass.data[ SmallClass.parentClassIndex ] = isRoot ? classClass : classSources.get( source.parentName ).metaClassObject;
		metaClass.data[ SmallClass.methodsIndex ] = newArray( List.of() );
		metaClass.data[ SmallClass.sizeIndex ] = image.newInteger( source.metaClassSize );
		metaClass.data[ SmallClass.variablesIndex ] = newStringArray( source.classVariables );

		aClass.data[ SmallClass.nameIndex ] = newString( source.name );
		aClass.data[ SmallClass.parentClassIndex ] = isRoot ? image.nilObject : classSources.get( source.parentName ).classObject;
		aClass.data[ SmallClass.methodsIndex ] = newArray( List.of() );
		aClass.data[ SmallClass.sizeIndex ] = image.newInteger( instanceSize( source ) );
		aClass.data[ SmallClass.variablesIndex ] = isRoot ? image.nilObject : newStringArray( source.variables );
		aClass.data[ SmallClass.sourceFileNameIndex ] = newString( source.fileName );
	}

	// ============================================= Compiling methods

	void compileMethods()
	{
		SmallCompiler compiler = new SmallCompiler( image );
		for( ClassSource source : classSources.values() )
			compileClass( source, compiler );
	}

	// Compile all methods in a source file, as in ClassParser>>fileIn:.
	// After the CLASS line and class comment, keyword lines CLASSMETHODS and METHODS
	// start sections of class methods and instance methods.
	// Each method is a header line followed by the body, ending with a line containing only "!".

	void compileClass( ClassSource source, SmallCompiler compiler )
	{
		List< SmallObject > instanceMethods = new ArrayList<>();
		List< SmallObject > classMethods = new ArrayList<>();
		List< String > lines = source.lines;

		SmallObject methodClassObject = null;	// null until the first keyword line.
		List< SmallObject > methods = null;

		int lineIndex = 1;	// Skip CLASS line.
		while( lineIndex < lines.size() ) {
			String line = lines.get( lineIndex++ ).trim();
			if( line.equals( "CLASSMETHODS" ) ) {
				methodClassObject = source.metaClassObject;
				methods = classMethods;
				continue;
			}
			if( line.equals( "METHODS" ) ) {
				methodClassObject = source.classObject;
				methods = instanceMethods;
				continue;
			}
			if( methods == null || line.isEmpty() )
				continue;	// Class comment, or blank line between methods.

			int methodLineNum = lineIndex;	// 1-based line number of method header line.
			StringBuilder methodText = new StringBuilder( line ).append( '\n' );
			while( true ) {
				if( lineIndex >= lines.size() )
					throw new RuntimeException( source.fileName + ": Line: " + methodLineNum + ": Failed to find method end marker: \"!\"" );
				String bodyLine = lines.get( lineIndex++ );
				if( bodyLine.equals( "!" ) )
					break;
				methodText.append( bodyLine ).append( '\n' );
			}

			SmallObject method;
			try {
				method = compiler.compileMethod( methodClassObject, methodText.toString() );
			} catch( RuntimeException e ) {
				throw new RuntimeException( source.fileName + ": Line: " + methodLineNum + ": " + e.getMessage(), e );
			}
			method.data[ 6 ] = image.newInteger( methodLineNum );		// lineNum, as set by ClassParser.
			methods.add( method );
		}

		source.classObject.data[ SmallClass.methodsIndex ] = newArray( sortMethods( instanceMethods ) );
		source.metaClassObject.data[ SmallClass.methodsIndex ] = newArray( sortMethods( classMethods ) );
	}

	List< SmallObject > sortMethods( List< SmallObject > methods )
	{
		List< SmallObject > sorted = new ArrayList<>( methods );
		sorted.sort( Comparator.comparing( ( SmallObject method ) -> method.data[ 0 ].toString(), SmallImageBuilder::compareStrings ) );
		return sorted;
	}

	// ============================================= Helpers

	SmallObject findClass( String name )
	{
		ClassSource source = classSources.get( name );
		return source == null ? null : source.classObject;
	}

	SmallObject classObject( String name )
	{
		SmallObject aClass = findClass( name );
		if( aClass == null )
			throw new RuntimeException( "Required class not found in sources: " + name );
		return aClass;
	}

	// Same ordering as String>>< (primitive 26): compare signed bytes, then length.

	static int compareStrings( String a, String b )
	{
		int length = Math.min( a.length(), b.length() );
		for( int i = 0; i < length; i++ ) {
			int result = ( byte ) a.charAt( i ) - ( byte ) b.charAt( i );
			if( result != 0 )
				return result;
		}
		return a.length() - b.length();
	}

	SmallObject newString( String value )
	{
		return new SmallByteArray( image.stringClass, value );
	}

	SmallObject newArray( List< SmallObject > elements )
	{
		SmallObject array = new SmallObject( image.arrayClass, elements.size() );
		for( int i = 0; i < elements.size(); i++ )
			array.data[ i ] = elements.get( i );
		return array;
	}

	SmallObject newStringArray( List< String > strings )
	{
		return newArray( strings.stream().map( this::newString ).toList() );
	}
}
