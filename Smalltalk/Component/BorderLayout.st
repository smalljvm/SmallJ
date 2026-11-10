CLASS JavaObject subclass: 'BorderLayout' variables: '' classVariables: ''
	"Implements java.awt.BorderLayout."
CLASSMETHODS
new
	"BorderLayout()"
	^ < 37 self 'java.awt.BorderLayout' >.
!
gap: point
	"BorderLayout( int hgap, int vgap )"
	^ < 37 self 'java.awt.BorderLayout' ( point x ) ( point y ) >.
!
center
	^ 'Center'.
!
north
	^ 'North'.
!
south
	^ 'South'.
!
east
	^ 'East'.
!
west
	^ 'West'.
!
emptyBorder: insets
	"javax.swing.border.EmptyBorder( Insets insets )"
	^ < 37 JavaObject 'javax.swing.border.EmptyBorder' insets >.
!
