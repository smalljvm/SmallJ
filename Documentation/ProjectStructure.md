

# Project Structure

The SmallJ repostiory consists of the following folders:

## ./ (root folder)
Contains the usual Git stuff like readme, changelog, license and gitignore.
It also contains the file: SmallJ.code-workspace.
This is the main project file for Visual Studio Code (VSCode).
It's most convenient to associate VSCode startup with this extension.
Starting Run or Debug starts the SmallJ VM, see below.

## [Documentation](/../README.md)
This documentation. All files should be reachable through the index in ReadMe.md.

## [GuiDesign](../GuiDesign/README.md)
Some Java mock-up programs for the various GUIs implemented in SmallJ.
The programs are in an IntelliJ project and use its forms designer for WYSIWIG GUI editing.
The gererated Java code can then be used as a base for creating the Smalltalk code.

## [Smalltalk](../Smalltalk)
The Smalltalk development enviroment.
VSCode is not needed to run SmallJ, allthough it is recommended for code editing.
Important files are:
- SmallJ.cmd - Starts up the SmallJ system, opening the SystemBrowser.
- SmallJ.jar - Compiled Java code for the SmallJ VM.
- SmallJ.sjim - Default Smalltalk image file containing the compiled Smalltalk code.
	When exiting SmallJ this file is overwritten.
	Make regular backups in case something gets broken and the system won't start anymore.

## [VM](../VM)
The SmallJ VM written in Java.
Use the VSCode SmallJ.code-workspace in the root folder to Run or Debug it.
After the VM is altered, a new ../Smalltalk/SmallJ.jar file should be generated
using the VSCode "Export JAR" function.
(This process should be automated, but there does not seem te be a convenient way without having to resort to using to Maven.)

## [VSCode](../VSCode/README.md)
Contains an extension for VSCode for Smalltalk syntax highlighting, that should be installed locally. It's recommended to do Smalltalk development in VSCode and only use the SmallJ SystemBrowser for compilation, testing and small code edits.


## [Website](../Website/Deploy/index.html)
Contains the source of the very simple website running at https://smallj.org.
This folder has purposely not been put on GitHub yet.
Let's make it a more serious site first.
