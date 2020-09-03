CLASS JavaObject subclass: 'GridLayout' variables: '' classVariables: ''
	"Implements java.awt.GridLayout."
META size: point
	"JPanel( new java.awt.GridLayout( rows, columns ) )"
	^ < 37 JavaObject 'java.awt.GridLayout' ( point y ) ( point x ) >.
!
