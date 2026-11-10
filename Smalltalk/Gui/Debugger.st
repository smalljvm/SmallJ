CLASS Object subclass: 'Debugger' variables: 'startContext frame frameTabbedPane errorTextField contextListComponent argumentListComponent contexts selectedContext arguments' classVariables: ''
	"The debugger GUI window inspects the call (context) stack and argument variables.
	 It is created by the Object.error: method.
	 It opens InspectorTab panes in new tabs when variables are double-clicked."
METHODS
show: message
	"Set start context for debugging, skipping the first 3 that are always present: Context.current, Debugger.show, String.error:"
	startContext := Context current previousContext previousContext previousContext.
	self createFrame.
	errorTextField text: message.
	self loadContexts.
	frame show.
!
createFrame
	frameTabbedPane := TabbedPane new.
	frameTabbedPane addTab: 'Context' component: self createContextTab.

	frame := Frame new title: 'Debugger'.
	frame setSize: 800 @ 400.
	frame add: frameTabbedPane.
!
createContextTab
	| contextTab |

	contextTab := Panel new.
	contextTab border: ( BorderLayout emptyBorder: ( Insets top: 4 left: 4 bottom: 4 right: 4 ) ).
	contextTab layout: ( BorderLayout gap: 4 @ 0 ).
	contextTab add: self createErrorPanel constraints: BorderLayout north.
	contextTab add: self createContextPane constraints: BorderLayout west.
	contextTab add: self createArgumentPane constraints: BorderLayout center.
	^ contextTab.
!
createErrorPanel
	| errorLabel errorPanel |

	errorLabel := Label new text: 'Error'.

	errorTextField := TextField new.
	errorTextField editable: false.
	errorTextField background: ( Color red: 250 green: 250 blue: 250 ).

	errorPanel := Panel new.
	errorPanel layout: ( BorderLayout gap: 4 @ 0 ).
	errorPanel add: errorLabel constraints: BorderLayout west.
	errorPanel add: errorTextField constraints: BorderLayout center.
	^ errorPanel.
!
createContextPane
	| contextScrollPane |

	contextListComponent := ListComponent new.
	contextListComponent onSelect: [ :listSelectionEvent | self onContextSelected ].

	contextScrollPane := ScrollPane view: contextListComponent.
	contextScrollPane border: ( Border createTitledBorder: 'Call Stack' ).
	^ contextScrollPane.
!
createArgumentPane
	| argumentScrollPane |

	argumentListComponent := ListComponent new.
	argumentListComponent onMouseClicked: [ :mouseEvent | self onArgumentClicked: mouseEvent ].

	argumentScrollPane := ScrollPane view: argumentListComponent.
	argumentScrollPane border: ( Border createTitledBorder: 'Self & Arguments' ).
	^ argumentScrollPane.
!
loadContexts
	"Load context methods names into contextListComponent component."
	|  contextValues context |

	contexts := List new.
	contextValues := List new.
	context := startContext.
	[ context notNil ] whileTrue: [
		contexts add: context.
		contextValues add: ( context arguments first class name + ' - ' + context method name ).
		context := context previousContext ].

	contextListComponent listData: contextValues.
	contextListComponent selectedIndex: 1.
	self onContextSelected.
!
onContextSelected
	"Load arguments for the selected context."
	| context argumentValues |

	context := contexts at: ( contextListComponent selectedIndex ).

	arguments := List new.
	argumentValues := List new.
	context arguments do: [ :argument |
		arguments add: argument.
		argumentValues add: argument printString ].

	argumentListComponent listData: argumentValues.
!
onArgumentClicked: mouseEvent
	"Open Inspector window on double clicked argument."
	| argument |
	"Check for double click."
	mouseEvent clickCount = 2 ifTrue: [
		argument := arguments at: argumentListComponent selectedIndex.
		self addTab: argument ].
!
addTab: object
	"Add new inspector tab on argument."
	| tab |
	tab := InspectorTab new parent: self show: object.
	frameTabbedPane addTab: object class name component: tab panel.
	frameTabbedPane selectedIndex: frameTabbedPane tabCount.
!
closeSelectedTab
	"Close the selected tab.
	 The contex tab will always remain open becuase it does not have a close button."
	| index |
	index := frameTabbedPane selectedIndex.
	index > 1 ifTrue: [
		frameTabbedPane removeTabAt: index. ].
!
