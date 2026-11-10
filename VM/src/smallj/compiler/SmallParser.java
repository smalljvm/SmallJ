// The SmallJ parser: lexes and parses Smalltalk method source text into a parse tree.
// The parse tree nodes are defined in SmallNodes; SmallCompiler generates byte codes from them.
// Literals (numbers, characters, strings) and class names are resolved to image objects while parsing.

import java.util.ArrayList;
import java.util.List;

class SmallParser
{
	// Result of parsing one method.
	record ParsedMethod( String name, SmallNodes.Node body, int maxTemps ) {}

	SmallImage image;
	SmallObject charClass;

	// Parser state.
	String text;
	int index;			// 1-based, as in Smalltalk.
	int tokenType;		// First character of token.
	String token;		// null at end of input.
	List< String > argNames;
	List< String > tempNames;
	List< String > instNames;
	List< String > classVarNames;
	int maxTemps;

	// Not thread safe: use one parser per thread.
	// Classes are looked up by name in Class>>classes, so that must be filled before parsing.

	SmallParser( SmallImage aImage )
	{
		image = aImage;
		charClass = image.findClass( "Char" );
		if( charClass == null )
			throw new RuntimeException( "Class not found: Char" );
	}

	// Parse method source text. Instance and class variable names are needed to resolve names.
	// Throws RuntimeException on parse errors.

	ParsedMethod parse( String aText, List< String > instanceVariables, List< String > classVariables )
	{
		text = aText;
		index = 1;
		argNames = new ArrayList<>();
		argNames.add( "self" );
		instNames = instanceVariables;
		tempNames = new ArrayList<>();
		classVarNames = classVariables;
		maxTemps = 0;

		nextLex();
		String name = readMethodName();
		readMethodVariables();
		SmallNodes.Node body = readBody();
		return new ParsedMethod( name, body, maxTemps );
	}

	void error( String message )
	{
		throw new RuntimeException( message );
	}

	// ============================================= Characters

	static boolean isBlank( int c ) { return c == 32 || c == 9 || c == 10; }
	static boolean isDigit( int c ) { return c >= '0' && c <= '9'; }
	static boolean isAlphabetic( int c ) { return ( c >= 'a' && c <= 'z' ) || ( c >= 'A' && c <= 'Z' ); }
	static boolean isAlphanumeric( int c ) { return isAlphabetic( c ) || isDigit( c ); }
	static boolean charIsSyntax( int c ) { return ".( )[ ]#^$'".indexOf( c ) >= 0; }

	// Character at 1-based position, or -1 (nil) if absent.

	int charAt( int position )
	{
		return position >= 1 && position <= text.length() ? text.charAt( position - 1 ) : -1;
	}

	int currentChar()
	{
		return charAt( index );
	}

	int nextChar()
	{
		index++;
		int c = charAt( index );
		return c < 0 ? ' ' : c;
	}

	// Same semantics as Array>>from:to:, 1-based and inclusive.

	String from( int low, int high )
	{
		int start = Math.max( low, 1 );
		int size = Math.max( Math.min( high, text.length() ) + 1 - start, 0 );
		return text.substring( start - 1, start - 1 + size );
	}

	// ============================================= Lexer

	void nextLex()
	{
		skipBlanks();
		tokenType = currentChar();
		if( tokenType < 0 ) {
			tokenType = ' ';
			token = null;
			return;
		}
		if( isDigit( tokenType ) )
			lexInteger();
		else if( isAlphabetic( tokenType ) )
			lexAlphabetic();
		else
			lexBinary();
	}

	void skipBlanks()
	{
		int cc;
		while( ( cc = currentChar() ) >= 0 && isBlank( cc ) )
			index++;
		if( cc == '"' )
			skipComment();
	}

	void skipComment()
	{
		int cc;
		do {
			index++;
			cc = currentChar();
			if( cc < 0 )
				error( "unterminated comment" );
		} while( cc != '"' );
		nextChar();
		skipBlanks();
	}

	void lexInteger()
	{
		// Also lexes floats.
		int start = index;
		while( isDigit( nextChar() ) )
			;
		int next = charAt( index + 1 );
		if( currentChar() == '.' && isDigit( next < 0 ? ' ' : next ) )
			while( isDigit( nextChar() ) )
				;
		token = from( start, index - 1 );
	}

	void lexAlphabetic()
	{
		int start = index;
		int cc;
		while( isAlphanumeric( cc = nextChar() ) )
			;
		// Add any trailing colon.
		if( cc == ':' )
			nextChar();
		token = from( start, index - 1 );
	}

	void lexBinary()
	{
		int c = currentChar();
		token = String.valueOf( ( char ) c );
		int d = nextChar();
		if( charIsSyntax( c ) )
			return;
		if( isBlank( d ) || isDigit( d ) || isAlphabetic( d ) || charIsSyntax( d ) )
			return;
		token = token + ( char ) d;
		nextChar();
	}

	boolean tokenIsName()
	{
		return isAlphabetic( tokenType ) && isAlphanumeric( token.charAt( token.length() - 1 ) );
	}

	boolean tokenIsKeyword()
	{
		return isAlphabetic( tokenType ) && token.charAt( token.length() - 1 ) == ':';
	}

	boolean tokenIsBinary()
	{
		return ! ( token == null || tokenIsName() || tokenIsKeyword() || charIsSyntax( tokenType ) );
	}

	boolean tokenIsAssign()
	{
		return ":=".equals( token );
	}

	// ============================================= Parser

	void addArgName( String name )
	{
		if( instNames.contains( name ) || argNames.contains( name ) )
			error( "Doubly defined argument name." );
		argNames.add( name );
	}

	void addTempName( String name )
	{
		if( argNames.contains( name ) || instNames.contains( name ) || tempNames.contains( name ) )
			error( "Doubly defined temp name." );
		tempNames.add( name );
		maxTemps = Math.max( maxTemps, tempNames.size() );
	}

	String readMethodName()
	{
		if( tokenIsName() ) {	// Unary method
			String name = token;
			nextLex();
			return name;
		}
		if( tokenIsBinary() ) {	// Binary method
			String name = token;
			nextLex();
			if( ! tokenIsName() )
				error( "missing argument" );
			addArgName( token );
			nextLex();
			return name;
		}
		if( ! tokenIsKeyword() )
			error( "invalid method header" );
		String name = "";
		while( tokenIsKeyword() ) {
			name = name + token;
			nextLex();
			if( ! tokenIsName() )
				error( "missing argument" );
			addArgName( token );
			nextLex();
		}
		return name;
	}

	void readMethodVariables()
	{
		if( tokenType != '|' )
			return;
		nextLex();
		while( tokenIsName() ) {
			addTempName( token );
			nextLex();
		}
		if( tokenType == '|' )
			nextLex();
		else
			error( "illegal method variable declaration" );
	}

	SmallNodes.Node readBody()
	{
		return new SmallNodes.BodyNode( readStatementList() );
	}

	List< SmallNodes.Node > readStatementList()
	{
		List< SmallNodes.Node > list = new ArrayList<>();
		while( true ) {
			list.add( readStatement() );
			if( tokenType != '.' )
				return list;
			nextLex();
			if( token == null || tokenType == ']' )
				return list;
		}
	}

	SmallNodes.Node readStatement()
	{
		if( tokenType == '^' ) {
			nextLex();
			return new SmallNodes.ReturnNode( readExpression() );
		}
		return readExpression();
	}

	SmallNodes.Node readExpression()
	{
		if( ! tokenIsName() )
			return keywordContinuation( readTerm() );
		SmallNodes.Node node = nameNode( token );
		nextLex();
		if( tokenIsAssign() ) {
			if( ! node.assignable() )
				error( "Illegal assignment." );
			nextLex();
			return new SmallNodes.AssignNode( node, readExpression() );
		}
		return keywordContinuation( node );
	}

	SmallNodes.Node keywordContinuation( SmallNodes.Node base )
	{
		SmallNodes.Node receiver = binaryContinuation( base );
		if( ! tokenIsKeyword() )
			return receiver;
		String name = "";
		List< SmallNodes.Node > args = new ArrayList<>();
		while( tokenIsKeyword() ) {
			name = name + token;
			nextLex();
			args.add( binaryContinuation( readTerm() ) );
		}
		return new SmallNodes.MessageNode( receiver, name, args );
	}

	SmallNodes.Node binaryContinuation( SmallNodes.Node base )
	{
		SmallNodes.Node receiver = unaryContinuation( base );
		while( tokenIsBinary() ) {
			String name = token;
			nextLex();
			List< SmallNodes.Node > args = new ArrayList<>();
			args.add( unaryContinuation( readTerm() ) );
			receiver = new SmallNodes.MessageNode( receiver, name, args );
		}
		return receiver;
	}

	SmallNodes.Node unaryContinuation( SmallNodes.Node base )
	{
		SmallNodes.Node receiver = base;
		while( tokenIsName() ) {
			receiver = new SmallNodes.MessageNode( receiver, token, new ArrayList<>() );
			nextLex();
		}
		return receiver;
	}

	SmallNodes.Node readTerm()
	{
		if( token == null )
			error( "unexpected end of input" );
		if( tokenType == '(' ) {
			nextLex();
			SmallNodes.Node node = readExpression();
			if( tokenType != ')' )
				error( "unbalanced parenthesis" );
			nextLex();
			return node;
		}
		if( tokenType == '[' )
			return readBlock();
		if( tokenType == '<' )
			return readPrimitive();
		if( tokenType == '#' )
			return readArray();
		if( tokenIsName() ) {
			SmallNodes.Node node = nameNode( token );
			nextLex();
			return node;
		}
		return new SmallNodes.LiteralNode( readLiteral() );
	}

	SmallNodes.Node readBlock()
	{
		int saveTempsSize = tempNames.size();
		nextLex();
		if( tokenType == ':' )
			readBlockTemporaries();
		List< SmallNodes.Node > statements = readStatementList();
		// Block temporaries go out of scope, but keep their slots.
		for( int i = saveTempsSize; i < tempNames.size(); i++ )
			tempNames.set( i, " " );
		if( tokenType != ']' )
			error( "Unterminated block" );
		nextLex();
		return new SmallNodes.BlockNode( statements, saveTempsSize );
	}

	void readBlockTemporaries()
	{
		while( tokenType == ':' ) {
			if( ! isAlphabetic( currentChar() ) )
				error( "Ill formed block argument" );
			nextLex();
			if( tokenIsName() )
				addTempName( token );
			else
				error( "Invalid block argument list" );
			nextLex();
		}
		if( tokenType == '|' )
			nextLex();
		else
			error( "Invalid block argument list" );
	}

	SmallNodes.Node readPrimitive()
	{
		nextLex();
		SmallObject number = readInteger();
		if( ! ( number instanceof SmallInt ) )
			error( "primitive number expected" );
		List< SmallNodes.Node > args = new ArrayList<>();
		while( tokenType != '>' )
			args.add( readTerm() );
		nextLex();
		return new SmallNodes.PrimitiveNode( ( ( SmallInt ) number ).value, args );
	}

	SmallNodes.Node readArray()
	{
		if( currentChar() != '(' )
			error( ( char ) currentChar() + "SmallJ does not support symbols." );
		nextChar();
		nextLex();
		List< SmallNodes.Node > args = new ArrayList<>();
		while( tokenType != ')' )
			args.add( readTerm() );
		nextLex();
		return new SmallNodes.PrimitiveNode( 36, args );
	}

	SmallObject readLiteral()
	{
		if( tokenType == '$' ) {
			int c = currentChar();
			if( c < 0 )
				error( "character expected" );
			nextChar();
			nextLex();
			return newChar( c );
		}
		if( isDigit( tokenType ) )
			return readInteger();
		if( tokenType == '-' ) {
			nextLex();
			SmallObject value = readInteger();
			if( value instanceof SmallFloat smallFloat )
				return image.newFloat( - smallFloat.value );
			return image.newInteger( - ( ( SmallInt ) value ).value );
		}
		if( tokenType == '\'' )
			return newString( readString() );
		error( "invalid literal:" + token );
		return null;
	}

	SmallObject readInteger()
	{
		if( ! isDigit( tokenType ) )
			error( "integer expected" );
		long value = 0;
		Long divisor = null;
		for( char c : token.toCharArray() ) {
			if( isDigit( c ) ) {
				value = value * 10 + ( c - '0' );
				if( divisor != null )
					divisor = divisor * 10;
			}
			if( c == '.' )
				divisor = 1L;
		}
		nextLex();
		if( divisor != null )
			return image.newFloat( ( double ) value / divisor );
		if( value > Integer.MAX_VALUE )
			error( "integer literal too large: " + value );
		return image.newInteger( ( int ) value );
	}

	String readString()
	{
		int first = index;
		int cc;
		while( ( cc = currentChar() ) != '\'' ) {
			if( cc < 0 )
				error( "unterminated string constant" );
			index++;
		}
		int last = index - 1;
		if( nextChar() == '\'' ) {
			// Doubled quote: keep one and continue.
			nextChar();
			return from( first, index - 2 ) + readString();
		}
		nextLex();
		return from( first, last );
	}

	SmallNodes.Node nameNode( String name )
	{
		if( name.equals( "super" ) )
			return new SmallNodes.ArgumentNode( 0 );
		int position;
		if( ( position = tempNames.indexOf( name ) ) >= 0 )
			return new SmallNodes.TemporaryNode( position + 1 );
		if( ( position = argNames.indexOf( name ) ) >= 0 )
			return new SmallNodes.ArgumentNode( position + 1 );
		if( ( position = instNames.indexOf( name ) ) >= 0 )
			return new SmallNodes.InstNode( position + 1 );
		if( ( position = classVarNames.indexOf( name ) ) >= 0 )
			return new SmallNodes.ClassVarNode( position + 1 );
		return new SmallNodes.LiteralNode( findName( name ) );
	}

	SmallObject findName( String name )
	{
		switch( name ) {
			case "true": return image.trueObject;
			case "false": return image.falseObject;
			case "nil": return image.nilObject;
		}
		SmallObject aClass = image.findClass( name );
		if( aClass == null )
			error( "Unrecognized name: " + name );
		return aClass;
	}

	SmallObject newString( String value )
	{
		return new SmallByteArray( image.stringClass, value );
	}

	SmallObject newChar( int value )
	{
		SmallObject aChar = new SmallObject( charClass, 1 );
		aChar.data[ 0 ] = image.newInteger( value );
		return aChar;
	}
}
