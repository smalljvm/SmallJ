CLASS Object subclass: 'InspectorTab' variables: 'parent object panel stringTextField variablesTable' classVariables: ''
	"Maintains a single tabbed pane in the Inspector window."
METHOD parent: aParent show: aObject
	"Create new view on aObject"
	parent <- aParent.
	object <- aObject.
	self createPanel.
	self loadObject.
!
METHOD createPanel
	panel <- Panel new.
	panel border: ( BorderLayout emptyBorder: ( Insets top: 4 left: 4 bottom: 4 right: 4 ) ).
	panel layout: ( BorderLayout gap: 0 @ 4 ).
	panel add: self createStringPanel constraints: BorderLayout north.
	panel add: self createVariablesPanel constraints: BorderLayout center.
	^ panel.
!
METHOD panel
	^ panel.
!
METHOD createStringPanel
	| stringLabel stringPanel closeButton |

	stringLabel <- Label new text: 'String'.

	stringTextField <- TextField new.
	stringTextField editable: false.
	stringTextField background: ( Color red: 250 green: 250 blue: 250 ).

	closeButton <- Button new text: 'x' action: [ :actionEvent | parent closeSelectedTab ].

	stringPanel <- Panel new.
	stringPanel layout: ( BorderLayout gap: 4 @ 0 ).
	stringPanel add: stringLabel constraints: BorderLayout west.
	stringPanel add: stringTextField constraints: BorderLayout center.
	stringPanel add: closeButton constraints: BorderLayout east.

	^ stringPanel.
!
METHOD createVariablesPanel
	variablesTable <- Table new.
	variablesTable disableEditing.
	variablesTable model addColumns: #( 'Variable' 'Value' ).

	variablesTable onMouseClicked: [ :mouseEvent | self onTableClicked: mouseEvent ].

	^ ScrollPane view: variablesTable.
!
METHOD loadObject
	| rowData |

	stringTextField text: object printString.

	( object isKindOf: Indexed )
		ifTrue: [ self loadIndexed ]
		ifFalse: [ self loadVariables ].
!
METHOD loadIndexed
	"Object to inspect is an indexed collection."
	| rowData |
	rowData <- Array new: 2.
	1 to: object size do: [ :index |
		rowData at: 1 put: index printString.
		rowData at: 2 put: ( object at: index ) printString.
		variablesTable model addRow: rowData ].
!
METHOD loadVariables
	| variables rowData |
	variables <- object class instanceVariables.

	rowData <- Array new: 2.
	1 to: variables size do: [ :index |
		rowData at: 1 put: ( variables at: index ).
		rowData at: 2 put: ( Object in: object at: index ) printString.
		variablesTable model addRow: rowData ].
!
METHOD onTableClicked: mouseEvent
	"Open new inspector tab on double-clicked row."
	| row newObject |
	"Check for double-click."
	mouseEvent clickCount = 2 ifTrue: [
		row <- variablesTable selectedRow.
		row > 0 ifTrue: [
			newObject <- Object in: object at: row.
			parent addTab: newObject ] ].
!
