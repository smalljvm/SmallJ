// Parse tree nodes, as produced by SmallParser.
// Each node generates its own byte codes with compile(), using the SmallEncoder.

import java.util.List;

class SmallNodes
{
	static abstract class Node
	{
		boolean isSuper() { return false; }
		boolean isBlock() { return false; }
		boolean assignable() { return false; }
		void assign( SmallEncoder encoder ) { throw new RuntimeException( "Illegal assignment." ); }
		abstract void compile( SmallEncoder encoder, boolean inBlock );
	}

	static class ArgumentNode extends Node
	{
		int position;
		ArgumentNode( int aPosition ) { position = aPosition; }
		@Override boolean isSuper() { return position == 0; }
		@Override void compile( SmallEncoder encoder, boolean inBlock )
		{
			encoder.genHigh( 2, position == 0 ? 0 : position - 1 );
		}
	}

	static class TemporaryNode extends Node
	{
		int position;
		TemporaryNode( int aPosition ) { position = aPosition; }
		@Override boolean assignable() { return true; }
		@Override void compile( SmallEncoder encoder, boolean inBlock ) { encoder.genHigh( 3, position - 1 ); }
		@Override void assign( SmallEncoder encoder ) { encoder.genHigh( 7, position - 1 ); }
	}

	static class InstNode extends Node
	{
		int position;
		InstNode( int aPosition ) { position = aPosition; }
		@Override boolean assignable() { return true; }
		@Override void compile( SmallEncoder encoder, boolean inBlock ) { encoder.genHigh( 1, position - 1 ); }
		@Override void assign( SmallEncoder encoder ) { encoder.genHigh( 6, position - 1 ); }
	}

	static class ClassVarNode extends Node
	{
		int position;
		ClassVarNode( int aPosition ) { position = aPosition; }
		@Override void compile( SmallEncoder encoder, boolean inBlock ) { encoder.genHigh( 14, position - 1 ); }
	}

	static class LiteralNode extends Node
	{
		SmallObject value;
		LiteralNode( SmallObject aValue ) { value = aValue; }
		@Override void compile( SmallEncoder encoder, boolean inBlock )
		{
			if( value == encoder.image.nilObject ) { encoder.genHigh( 5, 10 ); return; }
			if( value == encoder.image.trueObject ) { encoder.genHigh( 5, 11 ); return; }
			if( value == encoder.image.falseObject ) { encoder.genHigh( 5, 12 ); return; }
			if( value instanceof SmallInt smallInt && value.objClass == encoder.image.integerClass
					&& smallInt.value >= 0 && smallInt.value <= 9 ) {
				encoder.genHigh( 5, smallInt.value );
				return;
			}
			encoder.genHigh( 4, encoder.genLiteral( value ) );
		}
	}

	static class AssignNode extends Node
	{
		Node target;
		Node expression;
		AssignNode( Node aTarget, Node aExpression ) { target = aTarget; expression = aExpression; }
		@Override void compile( SmallEncoder encoder, boolean inBlock )
		{
			expression.compile( encoder, inBlock );
			target.assign( encoder );
		}
	}

	static class ReturnNode extends Node
	{
		Node expression;
		ReturnNode( Node aExpression ) { expression = aExpression; }
		@Override void compile( SmallEncoder encoder, boolean inBlock )
		{
			expression.compile( encoder, inBlock );
			encoder.genHigh( 15, inBlock ? 3 : 2 );		// Block return : stack return
		}
	}

	static class PrimitiveNode extends Node
	{
		int number;
		List< Node > arguments;
		PrimitiveNode( int aNumber, List< Node > aArguments ) { number = aNumber; arguments = aArguments; }
		@Override void compile( SmallEncoder encoder, boolean inBlock )
		{
			for( Node argument : arguments )
				argument.compile( encoder, inBlock );
			encoder.genHigh( 13, arguments.size() );
			encoder.genCode( number );
		}
	}

	static class BodyNode extends Node
	{
		List< Node > statements;
		BodyNode( List< Node > aStatements ) { statements = aStatements; }
		@Override void compile( SmallEncoder encoder, boolean inBlock )
		{
			for( Node statement : statements ) {
				statement.compile( encoder, inBlock );
				encoder.genHigh( 15, 5 );	// Pop
			}
			encoder.genHigh( 15, 1 );		// Return self
		}
	}

	static class BlockNode extends Node
	{
		List< Node > statements;
		int temporaryLocation;
		BlockNode( List< Node > aStatements, int aTemporaryLocation ) { statements = aStatements; temporaryLocation = aTemporaryLocation; }
		@Override boolean isBlock() { return true; }

		void compileInLine( SmallEncoder encoder, boolean inBlock )
		{
			for( Node statement : statements ) {
				statement.compile( encoder, inBlock );
				encoder.genHigh( 15, 5 );	// Pop top
			}
			encoder.backUp();
		}

		@Override void compile( SmallEncoder encoder, boolean inBlock )
		{
			encoder.genHigh( 12, temporaryLocation );
			int patchLocation = encoder.genCode( 0 );
			compileInLine( encoder, true );
			encoder.genHigh( 15, 2 );		// Return top of stack
			encoder.patch( patchLocation );
		}
	}

	static class MessageNode extends Node
	{
		Node receiver;
		String name;
		List< Node > arguments;
		MessageNode( Node aReceiver, String aName, List< Node > aArguments ) { receiver = aReceiver; name = aName; arguments = aArguments; }

		@Override void compile( SmallEncoder encoder, boolean inBlock )
		{
			if( receiver.isBlock() && argumentsAreBlock() && ( name.equals( "whileTrue:" ) || name.equals( "whileFalse:" ) ) ) {
				optimizeWhile( encoder, inBlock );
				return;
			}
			receiver.compile( encoder, inBlock );
			if( receiver.isSuper() ) {
				sendToSuper( encoder, inBlock );
				return;
			}
			if( name.equals( "isNil" ) ) { encoder.genHigh( 10, 0 ); return; }
			if( name.equals( "notNil" ) ) { encoder.genHigh( 10, 1 ); return; }
			compile2( encoder, inBlock );
		}

		void compile2( SmallEncoder encoder, boolean inBlock )
		{
			if( argumentsAreBlock() ) {
				switch( name ) {
					case "ifTrue:": compileTest( encoder, 8, 10, inBlock ); return;
					case "ifFalse:": compileTest( encoder, 7, 10, inBlock ); return;
					case "and:": compileTest( encoder, 8, 12, inBlock ); return;
					case "or:": compileTest( encoder, 7, 11, inBlock ); return;
					case "ifTrue:ifFalse:": optimizeIf( encoder, inBlock ); return;
				}
			}
			evaluateArguments( encoder, inBlock );
			switch( name ) {
				case "<": encoder.genHigh( 11, 0 ); return;
				case "<=": encoder.genHigh( 11, 1 ); return;
				case "+": encoder.genHigh( 11, 2 ); return;
			}
			sendMessage( encoder );
		}

		void sendToSuper( SmallEncoder encoder, boolean inBlock )
		{
			evaluateArguments( encoder, inBlock );
			encoder.genHigh( 8, 1 + arguments.size() );
			encoder.genHigh( 15, 11 );
			encoder.genCode( encoder.genLiteral( encoder.newString( name ) ) );
		}

		void evaluateArguments( SmallEncoder encoder, boolean inBlock )
		{
			encoder.pushArgs( 1 + arguments.size() );
			for( Node argument : arguments )
				argument.compile( encoder, inBlock );
		}

		void sendMessage( SmallEncoder encoder )
		{
			encoder.popArgs( arguments.size() );
			// Mark arguments, then send message.
			encoder.genHigh( 8, 1 + arguments.size() );
			encoder.genHigh( 9, encoder.genLiteral( encoder.newString( name ) ) );
		}

		boolean argumentsAreBlock()
		{
			for( Node argument : arguments )
				if( ! argument.isBlock() )
					return false;
			return true;
		}

		void optimizeWhile( SmallEncoder encoder, boolean inBlock )
		{
			int start = encoder.currentLocation();
			( ( BlockNode ) receiver ).compileInLine( encoder, inBlock );
			encoder.genHigh( 15, name.equals( "whileTrue:" ) ? 8 : 7 );		// Branch if false / true
			int save = encoder.genCode( 0 );
			( ( BlockNode ) arguments.get( 0 ) ).compileInLine( encoder, inBlock );
			encoder.genHigh( 15, 5 );		// Pop from stack
			encoder.genHigh( 15, 6 );		// Branch
			encoder.genCode( start );		// Branch target
			encoder.patch( save );
			encoder.genHigh( 5, 10 );		// Push nil
		}

		void compileTest( SmallEncoder encoder, int test, int constant, boolean inBlock )
		{
			encoder.genHigh( 15, test );	// Branch test
			int save = encoder.genCode( 0 );
			( ( BlockNode ) arguments.get( 0 ) ).compileInLine( encoder, inBlock );
			encoder.genHigh( 15, 6 );		// Branch
			int ssave = encoder.genCode( 0 );
			encoder.patch( save );
			encoder.genHigh( 5, constant );	// Push constant
			encoder.patch( ssave );
		}

		void optimizeIf( SmallEncoder encoder, boolean inBlock )
		{
			encoder.genHigh( 15, 8 );		// Branch if false test
			int save = encoder.genCode( 0 );
			( ( BlockNode ) arguments.get( 0 ) ).compileInLine( encoder, inBlock );
			encoder.genHigh( 15, 6 );		// Branch
			int ssave = encoder.genCode( 0 );
			encoder.patch( save );
			( ( BlockNode ) arguments.get( 1 ) ).compileInLine( encoder, inBlock );
			encoder.patch( ssave );
		}
	}
}
