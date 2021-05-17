// Some encapsulation for Smalltalk class: Class
// Object subclass: 'Class'
//      variables: 'name parentClass methods size variables sourceFileName'
//      classVariables: 'classes Parser'

public class SmallClass extends SmallObject
{
	// Number of instance variables in de Smalltalk Class class.
	// It is important that this is set correctly.
	public final static int instVarCount = 6;

    // Instance variable indices
    public final static int nameIndex = 0;
    public final static int parentClassIndex = 1;
    public final static int methodsIndex = 2;
    public final static int sizeIndex = 3;
    public final static int variablesIndex = 4;

    // Class variable indices
    public final static int classesIndex = 0;
}
