CLASS Array subclass: 'String' variables: '' classVariables: ''
CLASSMETHODS
new: aSize
	^ < 20 String aSize >.
!
METHODS
+ arg
	" optimized by primitive for speed "
	^ < 24 self ( arg printString ) >.
!
< arg
	^ < 26 self ( arg printString ) >  < 0.
!
= arg
	^ < 26 self ( arg printString ) >  = 0.
!
at: index ifAbsent: exceptionBlock
	( self includesKey: index )
	     ifTrue: [ ^ Char new: < 21 self index > ]
	     ifFalse: [ ^ exceptionBlock value ]
!
at: index put: char
	( self includesKey: index )	ifFalse: [
		^ self error: 'String indexing error: ' + index ].
	< 22 self index ( char value ) >.
!
asWords
	"Return array of strings containing the  words in self separated by spaces."
	^ ( self asWords: ' ' ) asArray.
!
asWords: separators
	"Return array of strings containing the  words in self,
	 separated by characters in separators string parameter."
	| words word |
	word := ''.
	words := List new.
	self do: [ :char |
		( separators includes: char )
			ifTrue: [
				( word size > 0 ) ifTrue: [
					"Found a word."
					words add: word.
					word := '' ] ]
			ifFalse: [
				word := word + char asString ] ].
	"Add possible last word."
	word size > 0 ifTrue: [
		words add: word ].
	^ words.
!
copy
	"Make a clone of ourself."
	^ < 23 self >.
!
doIt
	"Compile self as an expression, evaluate it and return its value.
	 The expression is compiled into a block that is evaluated here,
	 so it runs on the call stack of the sender and errors reach a Block>>onError: of the sender.
	 The receiver of the expression, self, is nil."
	| method block |
	method := Object parseMethod: 'doItCommand ^ [ ' + self + ' ]'.
	method notNil ifTrue: [
		block := Context new perform: method withArguments: ( Array new: 1 ).
		^ block value ].
!
find: substr
	1 to: ( self size - substr size + 1 ) do: [ :i |
		( self from: i size: substr size ) = substr ifTrue: [ ^ i ] ].
   ^ nil.
!
last: n
	^ self from: self size - n + 1 to: self size.
!
printString
	^ self.
!
size
	^ < 4 self >.
!
trim
	"Answer new string with leading and trainling spaces removed."
	| startPos endPos |
	startPos := 1.
	[ startPos <= self size and: [ ( self at: startPos ) isBlank ] ] whileTrue: [
		startPos := startPos + 1 ].

	endPos := self size.
	[ endPos > startPos and: [ ( self at: endPos ) isBlank ] ] whileTrue: [
		endPos := endPos - 1 ].

	^ self from: startPos to: endPos.
!
asLowerCase
	"Return copy of string with uppercase characters converted tot lower case."
	| result |
	result := String new: self size.
	1 to: self size do: [ :index |
		result at: index put: ( self at: index ) lowerCase ].
	^ result.
!
