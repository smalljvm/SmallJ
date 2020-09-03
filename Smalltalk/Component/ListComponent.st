CLASS Component subclass: 'ListComponent' variables: '' classVariables: ''
	"Implements javax.swing.JList"
META new
	| listComponent plainFont |
	"JList()"
	listComponent <- < 37 self 'javax.swing.JList' >.
	"Set detault font style to plain."
	plainFont <- listComponent font style: 0. "plain"
	^ listComponent font: plainFont.
!
METHOD listData: collection
	"void setListData( Object[] listData ).
	 The argument is a Smalltalk collection that is converted to a JavaArray first."
	< 38 nil self 'setListData' ( JavaArray from: collection ) >.
!
METHOD selectionMode: selectionMode
	"void setSelectionMode( int selectionMode )
     selectionMode: 0 = int SINGLE_SELECTION, 1 = SINGLE_INTERVAL_SELECTION, 2 = MULTIPLE_INTERVAL_SELECTION"
	< 38 nil self 'setSelectionMode' selectionMode >.
!
METHOD onSelect: block
	"On selection change in the list component, evaluate block
	 with a new instance of ListSelectionEvent as a parameter, containing the event data.
	 void addListSelectionListener( ListSelectionListener listener )
	 block is callded with selectedIndex, 1-based, nil for none."
	< 42 self 7 block ListSelectionEvent >.
!
METHOD selectedIndex
	"int getSelectedIndex()
	 The first index is 1. Returns 0 if there is no selection."
	^ < 38 SmallInt self 'getSelectedIndex' > + 1.
!
METHOD selectedIndex: index
	"void setSelectedIndex( int index )
	 The first index is 1. 0 clears selection."
	^ < 38 nil self 'setSelectedIndex' ( index - 1 ) >.
!
