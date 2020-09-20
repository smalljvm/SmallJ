CLASS Object subclass: 'Class' variables: 'name parentClass methods size variables sourceFileName' classVariables: 'classes'
META addClass: aClass
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
META at: aName ifAbsent: noValue
	classes do: [ :class |
		class name = aName ifTrue: [ ^ class ] ].
	^ noValue value.
!
META classes
	^ classes
!
META classes: aClasses
	"Dangerous - Set classes variable. Use only for repairing image."
	classes := aClasses.
!
META recompileAllMethods
	"This is done to remove references to updated classes."
	 classes do: [ :class |
		class class recompileMethods.
	 	class recompileMethods ].
!
META removeClass: className
	classes := ( classes reject: [ :class | class name = className ] ) asArray.
!
META resetAllSizes
	"Recalculate and reset size variable of all classes,
	 to repair a former bug and to accomodate for changed instance vars"
	classes do: [ :class |
		class class resetSize.
		class resetSize ].
!
METHOD addClassVariable: n
	"Dangereous - Put new class variable in class."
	Object in: self add: nil.
	Object in: self class at: 5 put: ( self class variables add: n ).
	size := size + 1
!
METHOD addInstanceVariable: n
	variables := variables add: n.
	size := size + 1
!
METHOD allMethods
	^ parentClass isNil
		ifTrue: [ methods asList ]
		ifFalse: [ methods asList addAll: parentClass allMethods ].
!
METHOD compileMethod: aString
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
METHOD fileIn
	ClassParser fileIn: sourceFileName.
!
METHOD hierarchy
	^ self hierarchy: 0.
!
METHOD hierarchy: level
	| result |
	result := ''.
	level timesRepeat: [
		result := result + Char tab asString ].
	result := result + name + Char newline asString.
	self subclasses do: [ :class |
		result := result + ( class hierarchy: level + 1 ) ].
	^ result.
!
METHOD instanceVariables
	"Return variable names and those of our superclasses."
	| names |
	parentClass notNil
		ifTrue: [ names := parentClass instanceVariables ]
		ifFalse: [ names := Array new: 0 ].
	variables notNil
		ifTrue: [ names := names + variables ].
	^ names.
!
METHOD methods
	^ methods
!
METHOD methods: aMethods
	methods := aMethods.
!
METHOD name
	^ name
!
METHOD name: aName
	name := aName.
!
METHOD name: aName parent: aParent variables: aVariables
	" private method used for initialization "
	name := aName.
	parentClass := aParent.
	variables := aVariables asWords.
	methods := Array new: 0.
	size := parentClass size + variables size
!
METHOD new
	"Return a new instance of ourselves."
	^ < 7 self size >.
!
METHOD parent: aParent
	parentClass := aParent.
!
METHOD parseMethod: text
   ^ ( Parser new text: text instanceVars: self instanceVariables classVars: self class variables ) parse: self.
!
METHOD printString
	^ name printString
!
METHOD recompileMethods
	"This is done to remove references to old, now replaced classes."
	 self methods do: [ :method |
	 	self compileMethod: method text ].
!
METHOD removeMethod: aMethodName
	methods := ( methods select: [ :method | method name ~= aMethodName ] ) asArray.
!
METHOD resetSize
	"Recalculate and reset size variable of this class and parent classes."
	| parent parentSize variablesSize |
	parent := self superclass.
	parentSize := parent isNil ifTrue: [ 0 ] ifFalse: [ parent resetSize ].
	variablesSize := variables isNil ifTrue: [ 0 ] ifFalse: [ variables size ].
	size := parentSize + variablesSize.
	< 25 self ( self class size ) >.
	^ size.
!
METHOD resetSizeAndSubs
	"Reset self size and size of subsclasses
	 and also for self metaclass and its subclasses."
	self resetSize.
	self subclasses do: [ :class |
		class class resetSizeAndSubs.
		class resetSizeAndSubs ].
!
METHOD size
	^ size.
!
METHOD sourceFileName
	^ sourceFileName.
!
METHOD sourceFileName: aSourceFileName
	sourceFileName := File forwardSlashes: aSourceFileName.
!
METHOD subclass: aName variables: aVariables classVariables: aClassVariables
	| metaClass class |
	metaClass := Class new name: 'Meta' + aName printString parent: self class variables: aClassVariables.
	class := metaClass new name: aName parent: self variables: aVariables.
	^ Class addClass: class.
!
METHOD subclasses
	^ Class classes select: [ :class | class superclass = self ].
!
METHOD superclass
	^ parentClass
!
METHOD updateFrom: aClass
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
METHOD variables
	^ variables
!
METHOD sourceFolderName
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
