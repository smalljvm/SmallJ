CLASS TestCase subclass: 'TestOptionPane' variables: '' classVariables: ''
	"Unit tests for OptionPane.
	 OptionPane only has methods that show modal dialogs, which wait for the user, so they are not run.
	 This test only checks that the dialog methods exist.
	 Run with: TestOptionPane run"
METHODS
testMethods
	| methodNames |
	methodNames := OptionPane class methods collect: [ :method | method name ].
	self assert: ( methodNames includes: 'showMessageDialog:' ).
	self assert: ( methodNames includes: 'showMessageDialogOn:message:title:type:' ).
	self assert: ( methodNames includes: 'showConfirmDialogOn:message:title:option:' ).
	self assert: ( methodNames includes: 'showInputDialogOn:message:title:type:' ).
!
