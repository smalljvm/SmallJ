CLASS Object subclass: 'JavaObject' variables: '' classVariables: ''
	"Abstract base helper class for Java objects, created with java primitives.
	 This class can be used for created Java objects for which there is no Smalltalk class yet.
	 Note: Any Smalltalk class can create paired Java objects. Inheritance from this class is not mandatory."
META new
	^ self error: 'JavaObject instances should be created with primitive 37 to pair them with Java objects.'.
!
