CLASS Array subclass: 'ByteArray' variables: '' classVariables: ''
META new: aSize
    "Create a new byte array of given size."
    ^ < 20 ByteArray aSize >
!
METHOD asCode
	| result |
	result := '( '.
	self do: [ :element |
		result := result + ( element quo: 16 ) + ':' + ( element rem: 16 ) + ' ' ].
	^ result + ')'.
!
METHOD at: index ifAbsent: exceptionBlock
	( self includesKey: index ) ifFalse: [
		^ exceptionBlock value ].
	^ < 21 self index >.
!
METHOD at: index put: value
	( self includesKey: index )	ifFalse: [
		self error: 'Byte array indexing error: ' + index ].
	( value between: 0 and: 255 ) ifFalse: [
		self error: 'Illegal value insertion into byte array.' + value ].
	^ < 22 self index value >.
!
