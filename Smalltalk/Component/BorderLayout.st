CLASS JavaObject subclass: 'BorderLayout' variables: '' classVariables: ''
	"Implements java.awt.BorderLayout."
META new
	"BorderLayout()"
	^ < 37 self 'java.awt.BorderLayout' >.
!
META gap: point
	"BorderLayout( int hgap, int vgap )"
	^ < 37 self 'java.awt.BorderLayout' ( point x ) ( point y ) >.
!
META center
	^ 'Center'.
!
META north
	^ 'North'.
!
META south
	^ 'South'.
!
META east
	^ 'East'.
!
META west
	^ 'West'.
!
META emptyBorder: insets
	"javax.swing.border.EmptyBorder( Insets insets )"
	^ < 37 JavaObject 'javax.swing.border.EmptyBorder' insets >.
!
