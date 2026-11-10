CLASS JavaEvent subclass: 'TreeSelectionEvent' variables: '' classVariables: ''
	"Implements javax.swing.event.TreeSelectionEvent
	 To receive this event add this code: < 42 aTree 9 aBlock TreeSelectionEvent >"
METHODS
isAddedPath
	"boolean isAddedPath()
	 Return true if the first path of the event was added to the selection, false if it was removed."
	^ < 38 Boolean self 'isAddedPath' >.
!
