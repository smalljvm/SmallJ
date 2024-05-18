# SmallJ  ReadMe

SmallJ is a simple Smalltalk virtual machine written in Java.
It was originally created as SmallWorld by Timothy Budd (http://web.engr.oregonstate.edu/~budd/SmallWorld/).
This specific version was built from Eric Scharff's update (https://github.com/ericscharff/SmallWorld)

But a *lot* was changed and rewritten... in summary:
- More OO Java code; more classes, longer variable names, fewer globals, smaller functions.
- Use of modern Java features like lambda functions and method references.
- More OO Smalltalk code; longer variable names, shorter statements, MVC separation, code formatting.
- Created Smalltalk primitives for manipulating arbitrary Java objects (FFI) using reflection.
  So now, the full Java framework can be used from Smalltalk without modifying the VM.
- Reimplemented the VM GUI classes in Smalltalk using the FFI, that now closely mirror the Java Swing framework.
  So now, all Java GUI operations can be easily added with one-line methods in Smalltalk.
  Further abstractions can be built on top of this, if desired.
  Removed now redundant GUI wrapper classes and associated primitives from the VM.
- Changed the development workflow to be source file based, preferably using the rich Visual Studio Code IDE.
  Created a new class browser in Smalltalk for testing / debugging this way.
  Removed source code from the image, making it a lot smaller.

With these changes, the interpreter will may run slower than it did before.
Maybe, because adding primitive tables with direct function references probably helped performance a lot.
Speed is not an issue for regular development operations, the system is snappy.
Recompiling all sources takes about 8 seconds on my sub-top Core-i7 from 2017.
Anyway, performance testing and hotspot optimizations are still to come...

# Smalltalk startup & development
- Use of Visual Studio Code (VSCode) is strongly recommended for Smalltalk development.
  There's a VSCode workspace file, SmallJ.code-workspace, in the root folder.
- The folder "./VSCode" contains an extension with basic syntax coloring support.
  On Windows, run "Deploy.cmd" to deploy it in your VSCode IDE (it's a simple copy).
- Smalltalk development is done in the "./Smalltalk" folder.
- SmallJ can be started by selecting Run or Debug from VSCode,
  or by running SmallJ.cmd from the ./Smalltalk folder to start Java with SmallJ.jar.
- The default Smalltalk image file is 'Image.sjim'.
- Smalltalk class source files (*.st) are organized in subfolders that could be called packages.
- By default, the main development window, the System Browser, is shown.
  There, folders, classes and methods can be selected to edit their source.
- The [ Save & Compile ] button saves and compiles the modified class.
  Note: If the source file was modifield outside SmallJ, e.g. in VSCode, that file will be compiled and loaded.
- The image contains the compiled methods, so be sure to save it if you are happy with your changes.
  Make regular backups of the image, in case something breakes that prevents SmallJ from starting up.
- At the bottom of the System Browser, you can evaluate any Smalltalk expression.
  [ Evaluate ] prints the result while [ Inspect ] additionally opens and object inspector on the result.
  Double-click on variables to inspect contained member variables in new window tabs.
- When a Smalltalk runtime error occurs, the Debugger window is opened,
  displaying the method call stack and argument variables per method.
  Double-click on a variables to inspect it.

# VM startup & development
- The VM is located in the ./VM folder.
- It is developed with OpenJDK v15, so install that first, or something similar.
  Using for modern Java features is encouraged to keep the VM source code compact.
- For VM development, using Visual Studio Code is recommended also.
  The VSCode workspace in the root folder contains the settings to build, run and debug the VM.
  This includes starting it in the ./Smalltalk folder, which is required.

# Vision
For now, SmallJ is an intended to be an educational system, as was SmallWorld.
Is shows the beauty of the elegant, clean and fully object oriented Smalltalk programming language,
to be compared to the many hybrid OO languages that are out there currently.
In the future, SmallJ could be expanded to being a useful scripting language for smaller tasks
and for creating quick GUIs.

# Roadmap
The development philosophy of SmallJ is to keep it tightly bound to the Java framework,
to enable full use of its features when adding more parts of it to Smalltalk, using the FFI.
On top of that, powerful Smalltalk abstractions of the, somewhat overdesigned, Java framework can be added.

Other Java libraries could be encapsulated by Smalltalk,
in stead of rewriting them in Smalltalk from the ground up.
Support for databases / persistence is a todo.
GUI wise, HTML support is desired, probably with its own web server.
New: For browser client development, check out [SmallJS](https://github.com/Small-JS/SmallJS) !

Regression testing needs to added for maintaining stability with open source development.
VM performance optimization is also needed to make it more suitable for CPU intensive tasks.

For coding, the Smalltalk support within VSCode could be improved with a grammar parser.
Source level step-debugging seems the ultimate goal there.

# Personal
For me personally, this is continuing to be a fun hobby development project.
Working hours on it have to fit in with a busy daytime job and a social life :).
If you have any questions, remarks, or would like to join SmallJ main development,
you can contact me on as user FunctionPoint on GitHub.

Cheers, RichardR
