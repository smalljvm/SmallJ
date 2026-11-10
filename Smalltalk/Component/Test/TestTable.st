CLASS TestCase subclass: 'TestTable' variables: '' classVariables: ''
	"Unit tests for Table.
	 Run with: TestTable run"
METHODS
testDisableEditing
	"Editing is disabled by removing the default cell editor for all column classes."
	| table objectClass |
	table := Table new.
	objectClass := < 46 JavaObject 'java.lang.Object' >.
	self assert: < 38 JavaObject table 'getDefaultEditor' objectClass > notNil.
	table disableEditing.
	self assert: < 38 JavaObject table 'getDefaultEditor' objectClass > isNil.
!
testModel
	| table |
	table := Table new.
	self assert: ( table model isKindOf: TableModel ).
	table model addColumns: #( 'a' 'b' ).
	table model addRow: #( 1 2 ).
	self assert: < 38 SmallInt table 'getColumnCount' > = 2.
	self assert: < 38 SmallInt table 'getRowCount' > = 1.
!
testSelectedRow
	"Rows start at 1, 0 means no selection."
	| table |
	table := Table new.
	table model addColumns: #( 'a' ).
	table model addRow: #( 1 ).
	table model addRow: #( 2 ).
	self assert: table selectedRow = 0.
	< 38 nil table 'setRowSelectionInterval' 1 1 >.
	self assert: table selectedRow = 2.
!
