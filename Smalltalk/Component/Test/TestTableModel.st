CLASS TestCase subclass: 'TestTableModel' variables: '' classVariables: ''
	"Unit tests for TableModel, a javax.swing.table.DefaultTableModel.
	 Run with: TestTableModel run"
METHODS
testColumnsRows
	| model |
	model := TableModel new.
	model addColumn: 'Name'.
	model addColumns: #( 'Value' ).
	model addRow: #( 'x' 'y' ).
	self assert: < 38 SmallInt model 'getColumnCount' > = 2.
	self assert: < 38 SmallInt model 'getRowCount' > = 1.
	self assert: < 38 String model 'getColumnName' 0 > = 'Name'.
	self assert: < 38 String model 'getValueAt' 0 1 > = 'y'.
!
