CLASS Component subclass: 'OptionPane' variables: '' classVariables: ''
	"Implements Java javax.swing.JOptionPane"
META showMessageDialog: message
	self showMessageDialogOn: nil message: message title: 'Message' messageType: 1
!
META showMessageDialogOn: parentComponent message: message title: title type: type
	"Show modal dialog with message, title and type and OK button to close.
		messageType: -1 PLAIN_MESSAGE (no icon), 0 = ERROR_MESSAGE. 1 = INFORMATION_MESSAGE, 2 = WARNING_MESSAGE, 3 = QUESTION_MESSAGE"

	"void showMessageDialog( Component parentComponent, Object message, String title, int messageType )
	 Must call typed FFI primitive to match parentComponent argument type correctly if it is nil."
	^ < 45 String 'javax.swing.JOptionPane' 'showMessageDialog' 'java.awt.Component' parentComponent 'java.lang.Object' message 'java.lang.String' title 'java.lang.Integer' type >.
!
META showConfirmDialogOn: parentComponent message: message title: title option: option
	"Show conformation dialog with options yes, no and cancel.
	 Return values: true for yes, false for no and nil for cancel or close."

	"public static int showConfirmDialog( Component parentComponent, Object message, String title, int optionType ).
		Option types: 0 = YES_NO_OPTION, 1 = YES_NO_CANCEL_OPTION, 2 = OK_CANCEL_OPTION, -1 = DEFAULT_OPTION.
		Return values: 0 = YES_OPTION, 1 NO_OPTION, 2 = CANCEL_OPTION, -1 = CLOSED_OPTION.
	 Must call typed FFI primitive to match parentComponent argument type correctly if it is nil."
	| answer |
	answer := < 45 String 'javax.swing.JOptionPane' 'showConfirmDialog' 'java.awt.Component' parentComponent 'java.lang.Object' message 'java.lang.String' title 'java.lang.Integer' option >.
	answer = 0 ifTrue: [ ^ true ].
	answer = 1 ifTrue: [ ^ false ].
	^ nil.		"Cancel or close."
!
META showInputDialogOn: parentComponent message: message title: title type: type
	"String showInputDialog( Component parentComponent, Object message, String title, int messageType )
	 Must call typed FFI primitive to match parentComponent argument type correctly if it is nil."
	^ < 45 String 'javax.swing.JOptionPane' 'showInputDialog' 'java.awt.Component' parentComponent 'java.lang.Object' message 'java.lang.String' title 'java.lang.Integer' type >.
!
