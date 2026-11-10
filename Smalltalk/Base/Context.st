CLASS Object subclass: 'Context' variables: 'method arguments temporaries stack bytePointer stackTop previousContext' classVariables: ''
CLASSMETHODS
current
   ^ < 35 >.
!
METHODS
backtrace
  ^  method name +
  		( arguments inject: '[' into: [ :r :a | r + a class printString + ',' ] ) +
        ']' + Char newline asString +
		( previousContext notNil ifTrue: [ previousContext backtrace ] ifFalse: [ ' ' ] ).
!
errorBlock
	"Return the error block of the nearest Block>>onError: on the call stack below self, or nil if there is none.
	 Called by Object>>error: on its own context. Returns nil when the method of self is found again on the
	 call stack, which means an error was raised inside an error block, to prevent endless recursion."
	| aContext |
	aContext := previousContext.
	[ aContext notNil ] whileTrue: [
		aContext method == method ifTrue: [ ^ nil ].
		( aContext method name = 'onError:' and: [ ( aContext arguments at: 1 ) isKindOf: Block ] ) ifTrue: [
			^ aContext arguments at: 2 ].
		aContext := aContext previousContext ].
	^ nil.
!
method: aMethod arguments: aAgruments
	method := aMethod.
	arguments := aAgruments.
	temporaries := Array new: aMethod tempSize.
	bytePointer := 0.
	stack := Array new: method stackSize.
	stackTop := 0.
!
perform: aMethod withArguments: aAgruments
	method := aMethod.
	arguments := aAgruments.
	temporaries := Array new: aMethod tempSize.
	bytePointer := 0.
	stack := Array new: method stackSize.
	stackTop := 0.
	^ < 6 self >.
!
method
	^ method.
!
arguments
	^ arguments.
!
temporaries
	^ temporaries.
!
stack
	^ stack.
!
bytePointer
	^ bytePointer.
!
stackTop
	^ stackTop.
!
previousContext
	^ previousContext.
!
