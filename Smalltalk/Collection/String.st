CLASS Array subclass: 'String' variables: '' classVariables: ''
META new: aSize
	^ < 20 String aSize >.
!
METHOD + arg
	" optimized by primitive for speed "
	^ < 24 self ( arg printString ) >.
!
METHOD < arg
	^ < 26 self ( arg printString ) >  < 0.
!
METHOD = arg
	^ < 26 self ( arg printString ) >  = 0.
!
METHOD at: index ifAbsent: exceptionBlock
	( self includesKey: index )
	     ifTrue: [ ^ Char new: < 21 self index > ]
	     ifFalse: [ ^ exceptionBlock value ]
!
METHOD at: index put: char
	( self includesKey: index )	ifFalse: [
		^ self error: 'String indexing error: ' + index ].
	< 22 self index ( char value ) >.
!
METHOD asWords
	"Return array of strings containing the  words in self separated by spaces."
	^ ( self asWords: ' ' ) asArray.
!
METHOD asWords: separators
	"Return array of strings containing the  words in self,
	 separated by characters in separators string parameter."
	| words word |
	word <- ''.
	words <- List new.
	self do: [ :char |
		( separators includes: char )
			ifTrue: [
				( word size > 0 ) ifTrue: [
					"Found a word."
					words add: word.
					word <- '' ] ]
			ifFalse: [
				word <- word + char asString ] ].
	"Add possible last word."
	word size > 0 ifTrue: [
		words add: word ].
	^ words.
!
METHOD copy
	"Make a clone of ourself."
	^ < 23 self >.
!
METHOD doIt
	| method |
	method <- Object parseMethod: 'doItCommand ^ ' + self.
	method notNil ifTrue: [
		^ ( Context new perform: method withArguments: ( Array new: 1 ) ) ].
!
METHOD find: substr
	1 to: ( self size - substr size + 1 ) do: [ :i |
		( self from: i size: substr size ) = substr ifTrue: [ ^ i ] ].
   ^ nil.
!
METHOD last: n
	^ self from: self size - n + 1 to: self size.
!
METHOD printString
	^ self.
!
METHOD size
	^ < 4 self >.
!
METHOD trim
	"Answer new string with leading and trainling spaces removed."
	| startPos endPos |
	startPos <- 1.
	[ startPos <= self size and: [ ( self at: startPos ) isBlank ] ] whileTrue: [
		startPos <- startPos + 1 ].

	endPos <- self size.
	[ endPos > startPos and: [ ( self at: endPos ) isBlank ] ] whileTrue: [
		endPos <- endPos - 1 ].

	^ self from: startPos to: endPos.
!
METHOD asLowerCase
	"Return copy of string with uppercase characters converted tot lower case."
	| result |
	result <- String new: self size.
	1 to: self size do: [ :index |
		result at: index put: ( self at: index ) lowerCase ].
	^ result.
!
