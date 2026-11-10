CLASS Component subclass: 'TableModel' variables: '' classVariables: ''
	"Implements javax.swing.table.DefaultTableModel."
CLASSMETHODS
new
	"TableModel()"
	^ < 37 self 'javax.swing.table.DefaultTableModel' >.
!
METHODS
addColumns: columnNames
	"Add columns names in arguent to table."
	columnNames do: [ :columnName |
		self addColumn: columnName ].
!
addColumn: columnName
	"public void addColumn( Object columnName )"
	< 38 nil self 'addColumn' columnName >.
!
addRow: rowData
	"public void addRow( Vector<?> rowData )"
	< 38 nil self 'addRow' ( JavaArray from: rowData ) >.
!
