# SmallJ  ReadMe

SmallJ is a simple Smalltalk virtual machine written in Java.
It was originally created as SmallWorld by Tim Budd (http://web.engr.oregonstate.edu/~budd/SmallWorld/).
This specific version was built from Eric Sharff's update (https://github.com/ericscharff/SmallWorld)

But a *lot* was changed and rewritten... in summary:
- More OO Java code; more classes, longer variable names, fewer globals, smaller functions.
- Use of modern Java features like lambda functions and method references.
- More OO Smalltalk code; longer variable names, shorter statements, MVC separation, code formatting.
- Created Smalltalk primitives for manipulating arbitrary Java objects (FFI) using reflection.
  So now, the full Java framework can be used from Smalltalk without modifying the VM.
- Reimplemented the VM GUI classes in Smalltalk using the FFI, that now closely mirror the Java Swing framework.
  So now, all Java GUI operations can be easily added with one 1-line methods in Smalltalk.
  Further abstractions can be built on top of this, if desired.
  Removed now redundant GUI wrapper classes and associated primitives from the VM.
- Changed the development workflow to be source file based, preferably using the rich Visual Studio Code IDE.
  Created a new class browser in Smalltalk for testing / debugging this way.
  Remove source code from the image anymore, making it a lot smaller.

With all these changes, the interpreter will probably run slower than it did before,
but it's not really noticeable now for regular development operations.
Performance testing and hotspot optimizations are still to come.

# Smalltalk startup & development
- Use of Visual Studio Code is strongly recommended.
  There's a Visual Studio Code workspace (SmallJ.code-workspace) file in the root folder.
- The folder "./VSCode" contains an extension with basic syntax coloring support.
  On Windows, run "Deploy.cmd" to deploy it in your VSCode IDE.
  For other OSs look in the file to see the folder copy that's done.
- Smalltalk development is done in the "./Smalltalk" folder.
- Starting SmallJ.jar with Java starts the VM. See SmallJ.cmd for an example.
- The default Smalltalk image file is 'Image.sjim'.
- Smalltalk class source files (*.st) are organized in subfolders that could be called packages.
- By default, the main IDE Window, the System Browser, is shown.
  There folders, classes and methods can be selected to edit their source.
- The [ Save & Compile ] button saves changes and compiles the modified class.
  Note: If the source file was modifield outside SmallJ, e.g. in VSCode, that will compiled and loaded.
- The image contains the compiled methods, so be sure to save it if you are happy with your changes.
  Make regular backups of the image, in case something breakes that prevents IDE startup.
- At the bottom of the System Browser, you can evaluate any Smalltalk expression.
  [ Evaluate ] prints the result. [ Inspect ] opens and object inspector on the result.
  Double-click on variables to inspect contained variables in new window tabs.
- When a Smalltalk runtime error occurs, the Debugger window is opened,
  displaying the method call stack and their argument variables.
  Double-click on the variables to inspect them.

# VM startup & development
- The VM is located in the ./VM folder.
- It was developed with OpenJDK v14, so install that first, or something similar.
  Using for modern Java features is encouraged to keep the VM source code compact.
- Use of the IntelliJ IDE is recommended.
  An IntelliJ project file is located in the /.idea folder.
  For other IDEs: The main() function is located in the SmallJApp class.
  (If someone wants to add other project file types (e.g. Maven), please do.)
- The VM should be started from the ./Smalltalk folder,
  where the default Smalltalk image file "image.sjim" is located and the source files.

 # Vision
For now, SmallJ is an intended to be an educational system, as is SmallWorld by T. Budd.
Is shows the beauty of the elegant, clean and fully object oriented Smalltalk language,
to be compared to the many hybrid OO languages that are out there currently.
In the future, SmallJ could be expanded to being a useful scripting language for smaller tasks and quick GUIs.

# Roadmap
The development philosophy of SmallJ is to keep it tightly bound to the Java framework,
to enable full use of its features when adding more parts of it to Smalltalk, using the FFI.
On top of that, powerful Smalltalk abstractions of the overdesigned Java framework can be added.

Other Java libraries should be encapsulated by Smalltalk,
in stead of rewriting them in Smalltalk from the ground up.
Database / persistence support is a todo.
GUI wise, HTML support is desired, probably with its own web server.
(And for browser client development, a SmallJS VM would be nice... :)

Regression testing needs to added for maintaining stability with open source development.
VM performance optimization is also needed to make it more suitable for CPU intensive tasks.

For coding, the Smalltalk support within VSCode could be improved with a grammar parser.
Source level step-debugging seems the ultimate goal there.

# Personal
For me personally, this is continuing to be a fun hobby development project.
Working hours on it have to fit in with a busy daytime job and a social life :).
If you have any questions or remarks, you can contact me on GitHub or through info@smallj.org.

Cheers, RichardR