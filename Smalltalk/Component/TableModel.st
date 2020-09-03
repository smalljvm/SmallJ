CLASS Component subclass: 'TableModel' variables: '' classVariables: ''
	"Implements javax.swing.table.DefaultTableModel."
META new
	"TableModel()"
	^ < 37 self 'javax.swing.table.DefaultTableModel' >.
!
METHOD addColumns: columnNames
	"Add columns names in arguent to table."
	columnNames do: [ :columnName |
		self addColumn: columnName ].
!
METHOD addColumn: columnName
	"public void addColumn( Object columnName )"
	< 38 nil self 'addColumn' columnName >.
!
METHOD addRow: rowData
	"public void addRow( Vector<?> rowData )"
	< 38 nil self 'addRow' ( JavaArray from: rowData ) >.
!
