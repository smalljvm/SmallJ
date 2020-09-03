CLASS JavaObject subclass: 'System' variables: '' classVariables: ''
	"Implements java.lang.System"
META in
	"static InputStream in - The standard input stream."
	^ < 41 JavaObject 'java.lang.System' 'in' >.
!
META out
	"static PrintStream out - The standard output stream."
	^ < 41 PrintStream 'java.lang.System' 'out' >.
!
META err
	"static PrintStream err - The standard error output stream."
	^ < 41 PrintStream 'java.lang.System' 'err' >.
!
META log: text
	self out println: text.
!
META exit: status
	"public static void exit( int status )"
	< 39 nil 'java.lang.System' 'exit' status >.
!
META imageFileName
	^ < 27 >.
!
META saveImage
	"Save image under current file name."
	self saveImage: self imageFileName
!
META saveImage: fileName
   < 29 fileName >.
!
META sleep: time
	"Sleep for milliseconds time in argument.
	 void java.lang.Thread.sleep( long time )."
	< 45 nil 'java.lang.Thread' 'sleep' 'java.lang.Long' time >
!
META currentDirectoryName
	^ < 39 String 'java.lang.System' 'getProperty' 'user.dir' >.
!
