CLASS Object subclass: 'Class' variables: 'name parentClass methods size variables sourceFileName' classVariables: 'classes'
CLASSMETHODS
addClass: aClass
	"Add new class or update existing one.
	 Returns updated existing class or otherwise (new) argument class."
	| existingClass |
	existingClass := classes find: [ :class | class name = aClass name ] ifAbsent: [
		"Not found, add new class."
		classes := ( ( classes add: aClass ) asOrdered: [ :a :b | a name < b name ] ) asArray.
		^ aClass ].

	"Update existing class."
	existingClass updateFrom: aClass.
	existingClass class updateFrom: aClass class.
	existingClass resetSizeAndSubs.
	^ existingClass.
!
at: aName ifAbsent: noValue
	classes do: [ :class |
		class name = aName ifTrue: [ ^ class ] ].
	^ noValue value.
!
classes
	^ classes
!
classes: aClasses
	"Dangerous - Set classes variable. Use only for repairing image."
	classes := aClasses.
!
recompileAllMethods
	"This is done to remove references to updated classes."
	 classes do: [ :class |
		class class recompileMethods.
	 	class recompileMethods ].
!
removeClass: className
	classes := ( classes reject: [ :class | class name = className ] ) asArray.
!
resetAllSizes
	"Recalculate and reset size variable of all classes,
	 to repair a former bug and to accomodate for changed instance vars"
	classes do: [ :class |
		class class resetSize.
		class resetSize ].
!
METHODS
addClassVariable: n
	"Dangereous - Put new class variable in class."
	Object in: self add: nil.
	Object in: self class at: 5 put: ( self class variables add: n ).
	size := size + 1
!
addInstanceVariable: n
	variables := variables add: n.
	size := size + 1
!
allMethods
	^ parentClass isNil
		ifTrue: [ methods asList ]
		ifFalse: [ methods asList addAll: parentClass allMethods ].
!
compileMethod: aString
	"Compile aString into method.
	 Return new method on success, otherwise raise error."
	| method |
	( method := self parseMethod: aString ) ifNil: [
		self error: 'Compile method failed.' ].

	methods := ( ( ( methods select: [ :m | m name ~= method name ] ) add: method )
		asOrdered: [ :a :b | a name < b name ] ) asArray.
	System out println: 'Compiled method: ' + self name + '.' + method name.
	^ method.
!
fileIn
	ClassParser fileIn: sourceFileName.
!
hierarchy
	^ self hierarchy: 0.
!
hierarchy: level
	| result |
	result := ''.
	level timesRepeat: [
		result := result + Char tab asString ].
	result := result + name + Char newline asString.
	self subclasses do: [ :class |
		result := result + ( class hierarchy: level + 1 ) ].
	^ result.
!
instanceVariables
	"Return variable names and those of our superclasses."
	| names |
	parentClass notNil
		ifTrue: [ names := parentClass instanceVariables ]
		ifFalse: [ names := Array new: 0 ].
	variables notNil
		ifTrue: [ names := names + variables ].
	^ names.
!
methods
	^ methods
!
methods: aMethods
	methods := aMethods.
!
name
	^ name
!
name: aName
	name := aName.
!
name: aName parent: aParent variables: aVariables
	" private method used for initialization "
	name := aName.
	parentClass := aParent.
	variables := aVariables asWords.
	methods := Array new: 0.
	size := parentClass size + variables size
!
new
	"Return a new instance of ourselves."
	^ < 7 self size >.
!
parent: aParent
	parentClass := aParent.
!
parseMethod: text
	"Compile text into a new method of this class, using the Java compiler in the VM.
	 Raise error on compile failure."
	| result |
	result := < 47 self text >.
	( result isKindOf: String ) ifTrue: [ self error: result ].
	^ result.
!
printString
	^ name printString
!
recompileMethods
	"This is done to remove references to old, now replaced classes."
	 self methods do: [ :method |
	 	self compileMethod: method text ].
!
removeMethod: aMethodName
	methods := ( methods select: [ :method | method name ~= aMethodName ] ) asArray.
!
resetSize
	"Recalculate and reset size variable of this class and parent classes."
	| parent parentSize variablesSize |
	parent := self superclass.
	parentSize := parent isNil ifTrue: [ 0 ] ifFalse: [ parent resetSize ].
	variablesSize := variables isNil ifTrue: [ 0 ] ifFalse: [ variables size ].
	size := parentSize + variablesSize.
	< 25 self ( self class size ) >.
	^ size.
!
resetSizeAndSubs
	"Reset self size and size of subsclasses
	 and also for self metaclass and its subclasses."
	self resetSize.
	self subclasses do: [ :class |
		class class resetSizeAndSubs.
		class resetSizeAndSubs ].
!
size
	^ size.
!
sourceFileName
	^ sourceFileName.
!
sourceFileName: aSourceFileName
	sourceFileName := File forwardSlashes: aSourceFileName.
!
subclass: aName variables: aVariables classVariables: aClassVariables
	| metaClass class |
	metaClass := Class new name: 'Meta' + aName printString parent: self class variables: aClassVariables.
	class := metaClass new name: aName parent: self variables: aVariables.
	^ Class addClass: class.
!
subclasses
	^ Class classes select: [ :class | class superclass = self ].
!
superclass
	^ parentClass
!
updateFrom: aClass
	"Private - Set class attributes of self to those of argument class.
	 This is for changing existing classes on fileIn without."

	"Class name should be same already.
	 So not: name := aClass name."
	parentClass := aClass superclass.
	"Leave current methods to enable filing-in critical base classes.
	 So not: methods := aClass methods."
	size := aClass size.
	variables := aClass variables.
!
variables
	^ variables
!
sourceFolderName
	"Return the folder part of the source file of this class.
	 Return '.' if the file is stored locally.
	 Return nil if the source file name is not set."
	| position |
	sourceFileName ifNil: [ ^ nil ].
	"sourceFileName must be stored using forward slashes."
	position := sourceFileName indexOfLast: $/ ifAbsent: [ ^ '.' ].
	position = 1 ifTrue: [ position := 2 ].		"If root folder, keep separator char."
	^ sourceFileName from: 1 to: position - 1.
!
