# SmallJ high level todo list

- Create GitHub issues for TODO's below with tags
	Then remove this file.

- File: Break up te File class in separate File and stream classes.
	Give a decent error message on file not found.

- File: Add file existence test before file open,
  and give more readable error message in stead of Java primitive failure.

- VSCode: Make Generated SmallJ.jar file work.
  Starting from IDE works.

- VSCode: Implement Smalltalk debugging support (hard).

- SystemBrowser: better behaviour when source files are not present.

- Documentation: Create intro SmallJ tutorial, shamelessly reusing on Prof. Stef from Amber.

- Debugging: Make SmallError exception trigger Object.error: , showing Smalltalk debugger.

- Deploy: Make FileIn option for smalltalk commands (not being a class)
	To be used for image repairs.

- Base: Re-implement Char class as native type, like SmallInt.
	So not keeping it in a separate value field in Smalltalk.
	Also needs to be a root class in the image then.

- Base: Implement long integer constants in the compiler.
	Eg: 10000000000L

- Base: Implement Java Date class for date and time.

- Base: Implement String class as Java String.
	This is different from a ByteArray.

- Compiler: Report line number for compilation errors.

- Compiler: General overhaul of compiler code
	Maybe integrate mostly trivial *node clases in read* methods.

- Compiler: bugfix: In method compilation, an unbalanced extra closing parenthesis or bracket
  	should cause a compilation error.

- Compiler: Simplify up compiler bytecode encoding and expand branch limits.
	Encode in 16 bits words: [ Opcode / Primitive ( 8 bit ) | Param ( 8 bit ) ]
		Opcodes: 1 .. 31
		Primitives: 32 .. 255   (starting with #1)
		Param: 0 .. 254.
			If Param is 255, then param becomes next 16 bit word [ 0 .. 2^16 ].
		This expands param limit from 8 to 16 bit,
		specifically making branches possible in larger methods.


- ColorEditor: Add cancel option, returning the original color.

- ImageEditor: Add cancel option, returning the original image.

- Inspector: Enable object instance variable edititing.

- Tutorial: Create *my personal* reference app in SmallJ, that will require in SmallJ:
  - DateTime oject.
  - Timer
  - Import fileIn loader on existing image.

- Tutorial: Create example app using:
  - Strings, numbers, collections, GUI

- Inspector: Put tab close button on tabs in stead of in Window
	First import generic Java component for this.
	E.g.: https://gist.github.com/6dc/0c8926f85d701a869bb2

- SystemBrowser: Warn about discarding changed in methods before navigating away.

- GUI: Create separate workspace browser Window with:
  - Line expression
  - Multi line result
  - Evaluate button.

- VM: Make event handling completely dynamic (low)
	https://stackoverflow.com/questions/61459204/generic-jcomponent-event-handling-in-java

- Testing:
	- Create test class in ST with regression tests
    - Add tests for everything touched.
	- Add standard performance test.

- SystemBrowser: Enable more class browser Windows?
    Should only ask exit question on closing last one. Implement with counter als class var.
	Or make tabs for opened files.

- VSCode: Create icon for Smalltalk *.st files.
	Should be done be extending a known (GitHub) theme.

- Documentation: Image layout.

- Documentation: Bytecode encoding.

- Smalltalk language: Rename variable assignment operator from "<-" to ":="
    for more compatibility with other Smalltalk implementations.

- Report SmalltalkExceptions as error on thread level.

- Performance: Make benchmark(s) for measuring performance.

- Performance: Create Operations and Primitive tables only once.
  Is it opssible in Java?

- Performance: More efficient SmallContext and SmallBlock handling.
    Less new object creations.

- Performance: Have single stack, not one per context?

- Performance: Merge Operations and Primitives for single lookup table.

- Performance: Encode small integers in object pointer (hard, impossible?).
    Will require some C++ / dirty casting and make Java unsafe.

- Performance: Do GUI event handlers really need to start a new thread for every action?
    E.g. OnMouseMouse seems expensive...
