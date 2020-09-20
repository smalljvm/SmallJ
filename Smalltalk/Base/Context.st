CLASS Object subclass: 'Context' variables: 'method arguments temporaries stack bytePointer stackTop previousContext' classVariables: ''
META current
   ^ < 35 >.
!
METHOD backtrace
  ^  method name +
  		( arguments inject: '[' into: [ :r :a | r + a class printString + ',' ] ) +
        ']' + Char newline asString +
		( previousContext notNil ifTrue: [ previousContext backtrace ] ifFalse: [ ' ' ] ).
!
METHOD method: aMethod arguments: aAgruments
	method := aMethod.
	arguments := aAgruments.
	temporaries := Array new: aMethod tempSize.
	bytePointer := 0.
	stack := Array new: method stackSize.
	stackTop := 0.
!
METHOD perform: aMethod withArguments: aAgruments
	method := aMethod.
	arguments := aAgruments.
	temporaries := Array new: aMethod tempSize.
	bytePointer := 0.
	stack := Array new: method stackSize.
	stackTop := 0.
	^ < 6 self >.
!
METHOD method
	^ method.
!
METHOD arguments
	^ arguments.
!
METHOD temporaries
	^ temporaries.
!
METHOD stack
	^ stack.
!
METHOD bytePointer
	^ bytePointer.
!
METHOD stackTop
	^ stackTop.
!
METHOD previousContext
	^ previousContext.
!
