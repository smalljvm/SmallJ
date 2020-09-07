# SmallJ high level todo list

When implementing these, GitHub issues should be made first.

- VSCode resource folder should be set, so logo is shown.

- VSCode generated JAR does not work. (Starting from IDE works)

- Create batch files compilation and deployment, outside of IntelliJ.
	For Windows for now, Mac / Lunix support later.

- SystemBrowser: better behaviour then there are no source files.

- Make SmallError exception trigger Object.error:, showing debugger.

- Make FileIn option for smalltalk commands (not being a class)
	To be used for image repairs.

- Break up te File class in separate File and stream classes.
	Give a decent error message on file not found.

- System.sleep should use SmallLong type.

- Re-implement Char class as native type, like SmallInt.
	So not keeping it in a separate value field in Smalltalk.
	Also needs to be a root class in the image then.

- Implement String class as Java String.
	This is different from a ByteArray.

- Simplify up compiler bytecode encoding and expand branch limits.
	Encode in 16 bits words: [ Opcode / Primitive ( 8 bit ) | Param ( 8 bit ) ]
		Opcodes: 1 .. 31
		Primitives: 32 .. 255   (starting with #1)
		Param: 0 .. 254.
			If Param is 255, then param becomes next 16 bit word [ 0 .. 2^16 ].
		This expands param limit from 8 to 16 bit,
		specifically making branches possible in larger methods.

- Compiler should not halt thread on compilation error but return failure to caller.

- Enable object edititing in the Inspector.

- Color editor: Add cancel option.

- Image editor: Add cancel option.


- Make site findable by linking on:
	Wikipedia Smalltalk.


- Inspector: Put tab close button on tabs in stead of in Window
	First import generic Java component for this.
	E.g.: https://gist.github.com/6dc/0c8926f85d701a869bb2

==== Visual Studio Code support

- Start VM from VSCode on project start.

==== Finish GUI refactoring and further.

- Remove next GUI wrapper classes and their primitives from interpreter.
	- ListWidget

- Add file existence test before file open, to get a nicer error message.

==== Refactor

- SmallObject should get object size from class in stead of passing it separately.
	See SmallJavaObject for details.
	Solve overloading conflict with object copy constructor, that same same signature now.

=====

- Report SmalltalkExceptions as error on thread level.

- Add line number for compilation errors.

- Change default text Pane font to something more readable than Arial.

- Create Smalltalk class JavaObject for storing Java objects without a specific wrapper class.
	It could have generic functionality for creating and invoking...

- Convert primitive 8 blockInvoke to standard argument order.

Bug fixes:
- In method compilation, and unbalanced extra closing parenthesis or brackets should cause a compilation error.

Features:
- Add DateTime class encapsulation Java ...

Compilation classes:
- Move compilation related methods to compiler classes
    Move fileIn from File to ...
    Move doIt from String to ...  (but need entry point)
- Warn about discarding changed in methods before navigating away.
- Make Windows Question. Modal dialogs.

Create separate workspace browser Window:
- Line expression
- Multi line result
- Evaluate button.

VM enhancement:
- Make event handling completely dynamic?
	https://stackoverflow.com/questions/61459204/generic-jcomponent-event-handling-in-java

Testing framework:
- Create test class in ST with regression tests
    Add test for everything touched.
- Add standard performance test.

Application:
- Enable more class browser Windows?
    Should only ask exit question on closing last one. Implement with counter als class var.

- Create icon for *.st files.
	Should be done be extending a known (GitHub) theme.

Open source development:
- Update ReadMe.md with own info, project purpose.
	Add full change log.
- Create new repository in GitHub

Documentation:
- Image layout.
- Bytecode encoding.

Smalltalk language:
- Rename variable assignment operator from "<-" to ":=" for more compatibility with other Smalltalk implementations.

Source control:
- Smalltalk sources need to be in text files to allow source control.
    Create build (update) image option from text files.
- No file close, that keeps written files locked on Windows.
- Make class file-in remove deleted methods.


- VSCode: Implement debugging support through VSCode.

===== Repair image option

- Create image repair option to add all classes found in the image to the class list.


========= Performance optimization possibilities:
- Create Operations and Primitive tables only once.
- More efficient SmallContext and SmallBlock handling.
    Less new object creations.
- Have single stack, not one per context.
- Merge Operations and Primitives for single lookup table.
- Encode small integers in object pointer.
    Will require some C++ / dirty casting.
- Do GUI event handlers really need to start a new thread for every action?
    E.g. OnMouseMouse seems expensive...


