CLASS Component subclass: 'Table' variables: 'model' classVariables: ''
	"Implements javax.swing.JTable on model javax.swing.table.DefaultTableModel."
CLASSMETHODS
new
	| model |
	model := TableModel new.
	"JTable()"
	^ < 37 self 'javax.swing.JTable' model > model: model.
!
METHODS
disableEditing
	| columnClass |
	"void setDefaultEditor( Class<?> columnClass, TableCellEditor cellEditor )
	 Must call typed FFI primitive to match null argument type correctly.
	 We want to call like this: setDefaultEditor( Object.class, null )."
	columnClass := < 46 JavaObject 'java.lang.Object' >.
	< 44 nil self 'setDefaultEditor' 'java.lang.Class' columnClass 'javax.swing.DefaultCellEditor' nil >.
!
model
	^ model.
!
model: aModel
	model := aModel.
!
selectedRow
	"Return selected row in table, 1-based, 0 if none."
	"public int getSelectedRow()"
	^ < 38 SmallInt self 'getSelectedRow' > + 1.
!
