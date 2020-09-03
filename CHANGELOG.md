# Changes in release 0.9 - 31-Aug-2020

- Started with a fork of Eric Scharff's SmallWorld version on GitHub: ericscharff/SmallWorld
- Created IntelliJ file based project. Removed Gradle build settings.
- Various renaming (refactoring) improvements.
    Less single letter variables and standard capitalization.
    Reformatted code using IntelliJ.
- Removed "unnecessary boxing" (casting) in SmallInterpreter.
- SmallWorld renamed to SmallJApp.
	- Replaced doItListener class with direct method calls to app on events.
	- Moved GUI operations to new class SmallWorldView.
- SmallImage: Made static final ints for hard coded constants.
- Renamed Smalltalk source files to *.st.
- Removed interfacing abstraction layer from ui. We only support one GUI: Swing.
- Removed UIFactory. Components are now created directly from their classes.
- Window: Replaced use of JDialog with JFrame to make opened windows accessible from the taskbar.
- Created icon for app window from Timothy Budd's book cover. Hope / expect he won't mind this usage. :-)
- Created class SmallImage split off from SmallInterpreter.
    - Moved image read and writing methods and classes to it.
    - Moved method SmallInterpreter.newInteger to SmallImage.
- Removed functionality loading image from resources because it confuses saving.
    Default is loading image with name "image.sjim" from current directory.
- Image remembers its file name for saving.
- Set max cached smallInts of 10 to static final variable smallIntsLength.
    Replaced 0..9 cases of switch statements with if( <in between> ).
- Replaced listener temporary classes with lambda functions.
    Shortened names of most listener interfaces in contained classes to just Listener.
- TextArea: Set tab size to 1, hardcoded.
- Moved Smalltalk image operations from interpreter to new class SmallImage.
- SmallInterpreter: Moved basic operations to new contained class Operations.
- SmallInterpreter: Replaced switch() for basic bytecode operations array of functions with the bytecode as index.
- SmallInterpreter: Merged special operations with basic operations.
- SmallInterpreter: Moved primitives to new contained class Primitives.
- SmallInterpreter: Refactored code for all primitives
    to do standard argument handling and use temporary variables with meaningful names.
- SmallInterpreter: Replaced switch() for primitive operations array of functions with the bytecode as index.
- SmallInterpreter: Clarified error messages and improved comments.
- Changed several primitives to standard stack ordering convention: <num self arg1 arg2 ...>
- Merged 'special' operations (code 16+) with basic operations in single jump table.
- Float primitives: Find Float class from self parameter. Removed passing it as hard coded argument.
- Primitives: Find String class on loading image. Removed passing it as a hard coded argument.
- SmallInt: Moved primitive #50 asFloat to new method Float>>fromSmallInt.
- Window: setVisible now returns self, not argument.
- Renamed GUI Picture class to Image, to more closely match both the Java SDK and Smalltalk.
    Even though is has some unwanted overload with the system image.
- Changed most hardcoded integer constants tot static final int variables.
- Converted method cache form sendMessage to separate class.
- Created SmallContext subclass class for encapsulating Smalltalk Context and Block operations.
    Replaced hardcoded constants for member access with named static variables.
- Created SmallBlock class encapsulating Smalltalk block usages.
- Refactored interpreter execute() function:
    Replaced double interpreter loop with single loop detecting context changes.
    Replaced continue and break for loops with standard loop while condition.
    Made member variables as local as possible.
    Moved variables to classes Operations and Primitives where possible.
- Moved image reader and writer classes out of SmallImage to reduce scope sharing.
    Made everything private except the load() and save() functions.
    Moved functions for loading and saving root objects to reader and writer classes.
- Broke up image reader and writer functions in smaller part functions.
- Added Smalltalk String class as a root object in image because this class must be accessible by Java.
- Image load/save: Read and write whole byte arrays at once, in stead of 1 byte at a time.
- Created new primitive #28: exit with status.
- Increased default opening size for some windows.
- Set first letter of menu items to be the default shortcut key.
- Made class browser application startup window.
    Added menu for exit and image save.
    Removed Java startup window class.
- Created new primitive #28: add actions to window OnClosing event.
- Add exit dialog behaviour:
    Exiting. Save? Yes / No / Cancel.
    Routed the close button of the class browser window to this dialog.
- Created primitive #27 for querying the current image file name.
    So Smalltalk could now save image under a different name. No menu option made yet.
- Set default fileOut extension to *.st.
- Fixed semantic bug so that "o ifTrue: [ 42 ]" returns 42 *only* if x is true.
    If x false *or any other object*, this now returns nil.
    Did same fix done for "ifFalse:".
- Added "title:" parameter to Window>>question: dialog.
    - Updated all usages to add tile.
    - Made Cancel option return nil in stead of calling a more destructive Object halt.
- Set center of screen as default placement for all windows.
- Removed close buttons from Class Browser and Class Editor windows,
  because they are redundant with the default windows close button on the top right.
- BugFix: ListPane should call primitive 83 to get selected index.
- Un-hid all hidden classes (Compiler). We want to see then and learn from them :-).
- Created foreign function interface (FFI) primitives to Java framework:
    - #37 construct any Java object using its class name and constructor parameters.
    - #38 invoke any Java method on an object using its method name and parameters.
    - #39 invoke any static Java method on class using its method name and parameters.
    - #40 access any Java class field (member) of an object.
    - #41 access any static Java class field (member) of a class.
    Return values are converted to a Smalltalk object of the specified class.
    So now, almost all of the Java framework can be accessed directly from Smalltalk without modifying the VM!
- Expanded FFI with primitives #43, #44 and #45
	to have exactly typed Java parameters with then invoking Java constructors and (typed) methods.
- Added Apache Commons libraries to project for use of classes:
	ConstructorUtils, MethodUtils and FieldUtils
	for easier and inheritance-aware handling in reflection.
- Removed VM primitives for file operations.
	Replaced them in Smalltalk with the Java FFI.
- Made Smalltalk coding style more verbose, easier to read and understand:
	Added method comments.
	Temporary method vars on separate line.
	Expanded single letter abbreviations in variable names.
	Inserted spaces after opening and before closing brackets of all types: ( [ < > ] ).
	Put Smalltalk statement, ending with a period, on a separate line.
	Inserted an occasional blank line for grouping statements.
    Used tabs (not spaces) for indent.
- BugFix: Size of filed-in class now correctly calculated as count of instance + class vars + parent vars.
	The character length of the strings containing the vars was used, erroneously.
- Refactored Color class to store color as separate red, green, blue components.
	Previously it stored the combined value of the RGB component in a single integer, requiring split-ups.
- Moved class browser to separate class.
	BugFix: Class list is refreshed after deleting class.
- Increased hardcoded minimum stack size from 5 to 20 to support primitives with up to 20 args.
	Finding the correct max number of args due to primitives should really be handled in the compiler...
- Changed default app font to Calibri for easier code reading.
	Is hard coded for now. Could be moved to Smalltalk.
- Added Smalltalk class Component, implementing Java class JComponent.
	Added mouse event handling should go here.
	Remove Widget wrapper class and associated primitives from VM.
- Added primitive #42 for central event handling.
	Implemented Java event classes in Smalltalk:
		ActionEvent, WindowsEvent, MouseEvent, AdjustmentEvent.
	Removed event handling in VM from Java GUI wrapper classes.
- Added Smalltalk class Frame implementing Java JFrame.
 	Removed Window wrapper class and associated primitives  from the VM.
- Added Smalltalk class ScrollBar implementing Java JScrollbar.
 	Removed Slider wrapper class and associated primitives  from the VM.
- Refactored Color class
 	Made it mutable.
 	Store color value as separate red, green and blue components.
 	Added javaColor member for storing the Java color. Is immutable.
- Added Smalltalk class ScrollBar implementing Java JScrollbar.
 	Removed Slider wrapper class and associated primitives  from the VM.
- Reimplemented Smalltalk class Image implementing Java BufferedImage.
	Removed Image wrapper class and associated primitives from the VM.
- Moved SmallThread out of SmallInterpreter class to global level.
	Was also needed for event handling.
- Added convenience methods ifNil: [ block ] ifNotNil: [ block ] to Object.
- Added Smalltalk class Panel implementing Java JPanel class.
 	Removed Pane wrapper class and associated primitives from VM.
- Added Smalltalk class Button implementing Java JButton class.
 	Removed Panel wrapper class and associated primitives from VM.
- Added Smalltalk classes TextComponent TextField, TextArea implementing Java corresponding classes.
- Added Smalltalk class GridPanel and BorderPanel implementing Java JPanel with grid and border layouts.
 	Removed Panel, GridPanel and BorderPanel wrapper class and associated primitives from VM.
- Added class ColorEditor using new GUI framework, replacing Color edit method.
	ColorEditor actually now uses the input color as a start value.
- Added class ImageEditor using new GUI framework, replacing Image edit method.
- Added Smalltalk class OptionPane, implementing Java JOptionPane,
	replacing Window class methods: getString:, question: and notify:.
	Message dialogs are now modal and look better.
- Reimplemented Smalltalk class Menu implementing Java class JMenu.
 	Removed Menu wrapper class and associated primitives from VM.
- Created FFI primitive #46 for loading Java class object.
	Used for Java methods that take that as a parameter, e.g. in Array.
- Created class JavaArray implementing java.lang.reflect.Array.
	Used for calling Java methods that have array argument types.
- Visual Studio Code support
	Added extension to implement SmallWorld syntax coloring for *.st files.
- Removed used GUI Class.subclass creation window.
- BugFix: Prevent Class.addNewClass from creating duplicate classes when a class is filed in more than once.
- Made Class.subclass:... method always add class to main list.
	So adding hidden classes is nog longer supported.
	Automatically generated Meta* classes are still hidden.
	Removed now redundant "Class addNewClass: ( X )" statements from all class source files.
- Removed Class.fileOut and .fileTo: methods in stead of fixing them,
	because we're moving to file-based development.
- BugFix: Reimplemented primitive #13 smallInLessThan,
	even though the compiler optimizes common use of < with operation #11.
- Display exception in message dialog in stead of on std.err, for now...
- Created System class
	Implemented Java System.in, .out and .err.
	Implemented exit with FFI.
		Removed primitive.
	Moved image saving to System class.
	Reimplemented SmallInt.sleep as System.sleep using FFI.
		Removed primitive #33.
- Removed primitive #18 'objectDebug'.
	Printing debug information on stdout can now be done directly from Smalltalk using the System class.
- Reimplemented Smalltalk class Semaphore as a JavaObject implementing java.util.concurrent.Semaphore.
	Removed custom Semaphore class and 3 primitives operating on it.
- Created method MetaClass.recompileAllMethods
	It recompiles all classes to remove (hidden) retained references to previous versions of newly filed-in classes.
	Fixed a couple of syntax errors in in the existing source code that were exposed by this.
- Removed all class variables from Parser
  and removed Parser class variable from Class.
	They were only used to retain references to formerly hidden classes (now un-hidden),
	preventing their modification.
- Updated Class.addNewClass to modify existing classes in stead of creating new ones.
	Otherwise the image was corrupted then filing in an existing class!
- Created class ClassParser that implements a stricter file-in format,
	allowing only to file-in one class per source file.
	First line must be: "CLASS <(sub)class creating expression>"
	Removed now redundant class name after META and METHOD keywords everywhere.
	After META and METHOD keywords replaced now redundant class name
	with method header from next line (method name and arguments).
	File-in now updates classes if they exist, instead of creating new ones.
	After class file-in, its member size is recalculated, also of its meta-class.
	The class object (MetaClass instance) data[] is resized to possible new size.
		New primitive #25 is implemented for this.
	The 2 operations above are also done for subclasses of the filed-in class,
		because their sizes depend on the size of their base class.
	Removed File.fileIn.
	(The old behavior created corrupt images because references to old classes were kept in compiled methods.)
- Reimplemented Float.random to call Java Math.random using FFI.
	Removed primitive #58 from VM.
- Reimplemented Float.toString to call Java Double.toString using FFI.
	Removed primitive #59 from VM.
- Implemented Float.sqrt calling Java Math.sqrt using FFI.
	Just to see if double arguments work in the FFI. They do. :)
- Removed Application base class.
	The editor classes can serve as examples to implement user applications.
- Removed method text search functionality.
	This can be done better in the IDE, eg: VSCode.
- Removed GUI to show / edit class variables.
	Class variables are now edited in source files.
	BTW, there is currently only one class variable: Class.classes. (But it's important! :)
- Added SmallInt.timesRepeat: aBlock method for looping
	to repeatedly value a block without having to use the count at parameter, as in to:do:.
- Added sourceFileName instance variable in Class, storing the path to the source file for compilation.
- Added lineNum instance variable to Method, storing the starting line number of the method within the source file.
	To be able to place the cursor to the correct line in the source file after selecting a method.
- Removed unused primitive #9 reading a character from System.in.
	If needed, implement it in the System class using the FFI.
- Reimplemented floating point numbers in the VM with SmallDouble class with a value of double type.
	Replacing use of JavaObject with an object of the class Double.
	Enabled storing and loading of doubles in the image using this class,
	specifically to allow floats constants in compiled methods.
	Added SmallFloat as new new root class in the image, so it can be used by the VM everywhere.
- Create class JavaObject subclasses JPoint, Rectangle and Viewport for GUI support.
- Removed unused primitive #17 intAsString.
- Re-implemented ClassBrowser as new SystemBrowser!
	The top part selects a folder (package), class and method (instance or class) within the class source.
	The middle part edits the source code of a class and has a Compile (file-in) button for the whole class.
	The source font is hard-coded to 'Consolas' size 12, for now.
	In the bottom an expression can be evaluated with a single line result shown
	or the result can be inspected in a window.
	Source is compiled from its file, so it can be modified by an external editor like VSCode.
	Menu options:
		File: Save Image & Exit.
		Class:
			Compile all: Recompile all sources from source files.
			File-in: File in new class from source file using file selector.
			Delete: Delete class from image.
- Removed, now redundant, source code from Method, making the image much smaller.
- Made generic object (variable) inspector
	Objects are displayed in separate tabs.
	Object value string is shown.
	Object variables and their values are shown in a table.
	Double clicking on a variable opens a new tab on that object.
= Implemented Smalltalk Font class for Java equivalent.
- Set ListComponent default font style to regular (was bold).
- Re-implemented error 'debugger' message with new Debugger class.
	Error message is shown separately from the call stack.
	Methods in the call stack can be selected to show self and their argument variables in a list.
	Clicking a variable opens an inspector tab in the current window.
- Finally removed old, now redundant, GUI framework from Smalltalk and all GUI primitives from VM:
	Removed remaining old-style GUIs, mainly object editors with questionable use.
	Removed old component classes from Smalltalk.
	Removed all GUI classes from the VM.
	Removed all GUI primitives from the VM.
	Removed old-style event handling.
- Created GitHub *organization* called "smalljvm".
	Initial skeleton commit without source code yet.
- Created very simple single page website with static HTML, hosted on new domain: smallj.org.
- Made new SmallJ logo.
	Made icon file that looks better in small sizes
- Publication of SmallJ on GitHub with small support website

	-
    - Put SmallJ on gitHub, under smallJ account.
    - Made SmallJ website smallj.org with some hand coded HTML.
  - Hosted website somewhere on bought domain: SmallJ.org..
  - Upload to GitHub.
