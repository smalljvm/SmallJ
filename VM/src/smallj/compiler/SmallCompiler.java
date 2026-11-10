// The SmallJ compiler: compiles Smalltalk method source text to byte codes and Method objects.
// Parsing is done by SmallParser, into a tree of SmallNodes, which generate byte codes using a SmallEncoder.
// Used by SmallImageBuilder to compile methods when there is no image yet,
// and by primitive 47 (methodCompile) to compile methods in a running image, as called from Class>>parseMethod:.
// Originally ported from the Smalltalk compiler classes (Parser, Encoder and *Node) that were removed from the image.
// The byte codes generated must match the operations in SmallInterpreter.

import java.util.ArrayList;
import java.util.List;

class SmallCompiler
{
	// Result of compiling one method.
	record CompiledMethod( String name, byte[] byteCodes, List< SmallObject > literals, int stackSize, int temporarySize ) {}

	SmallImage image;
	SmallParser parser;

	// Not thread safe: use one compiler per thread.
	// Classes are looked up by name in Class>>classes, so that must be filled before compiling.

	SmallCompiler( SmallImage aImage )
	{
		image = aImage;
		parser = new SmallParser( image );
	}

	// Compile method source text for aClass into a new Method object,
	// as in Class>>parseMethod: plus Method class>>name:byteCodes:literals:stackSize:temporarySize:class:.
	// The lineNum of the method is left nil. Throws RuntimeException on compile errors.

	SmallObject compileMethod( SmallObject aClass, String methodText )
	{
		CompiledMethod compiled = compile( methodText,
			instanceVariables( aClass ), stringList( aClass.objClass.data[ SmallClass.variablesIndex ] ) );

		SmallByteArray byteCodes = new SmallByteArray( findClass( "ByteArray" ), 0 );
		byteCodes.values = compiled.byteCodes();

		SmallObject methodClass = findClass( "Method" );
		SmallObject method = new SmallObject( methodClass, ( ( SmallInt ) methodClass.data[ SmallClass.sizeIndex ] ).value );
		method.data[ 0 ] = newString( compiled.name() );
		method.data[ 1 ] = byteCodes;
		method.data[ 2 ] = newArray( compiled.literals() );
		method.data[ 3 ] = image.newInteger( compiled.stackSize() );
		method.data[ 4 ] = image.newInteger( compiled.temporarySize() );
		method.data[ 5 ] = aClass;
		return method;
	}

	// Same as Class>>instanceVariables: inherited variable names first.

	List< String > instanceVariables( SmallObject aClass )
	{
		if( aClass == image.nilObject )
			return new ArrayList<>();
		List< String > names = instanceVariables( aClass.data[ SmallClass.parentClassIndex ] );
		names.addAll( stringList( aClass.data[ SmallClass.variablesIndex ] ) );
		return names;
	}

	List< String > stringList( SmallObject array )
	{
		List< String > strings = new ArrayList<>();
		if( array != image.nilObject )
			for( SmallObject string : array.data )
				strings.add( string.toString() );
		return strings;
	}

	SmallObject findClass( String name )
	{
		SmallObject aClass = image.findClass( name );
		if( aClass == null )
			throw new RuntimeException( "Class not found: " + name );
		return aClass;
	}

	// Compile method source text into byte codes and literals.

	CompiledMethod compile( String methodText, List< String > instanceVariables, List< String > classVariables )
	{
		SmallParser.ParsedMethod parsed = parser.parse( methodText, instanceVariables, classVariables );
		SmallEncoder encoder = new SmallEncoder( image, parsed.name() );
		parsed.body().compile( encoder, false );
		return encoder.method( parsed.maxTemps() );
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
}
