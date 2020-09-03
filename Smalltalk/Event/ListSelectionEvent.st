CLASS JavaEvent subclass: 'ListSelectionEvent' variables: '' classVariables: ''
	"Implements javax.swing.event.ListSelectionEvent
	 To receive this event add this code: < 42 aListComponent 7 aBlock ListSelectionEvent >"
!
META new
	^ < 37 self 'javax.swing.event.ListSelectionEvent' >.
!
METHOD valueIsAdjusting
	"public boolean getValueIsAdjusting()"
	^ < 38 Boolean self 'getValueIsAdjusting' >.
!
