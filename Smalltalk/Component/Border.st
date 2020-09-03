CLASS JavaObject subclass: 'Border' variables: '' classVariables: ''
	"Implements javax.swing.border.AbstractBorder subclasses."
META createTitledBorder: title
"TitledBorder javax.swing.BorderFactory.createTitledBorder( String title )"
^ < 39 self 'javax.swing.BorderFactory' 'createTitledBorder' title >.
!
