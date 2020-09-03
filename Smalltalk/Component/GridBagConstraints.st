CLASS JavaObject subclass: 'GridBagConstraints' variables: '' classVariables: ''
	"Implements java.awt.GridBagConstraints."
META new
	"GridBagConstraints()"
	^ < 37 self 'java.awt.GridBagConstraints' >.
!
META grid: grid size: aSize weight: weight anchor: anchor fill: fill insets: insets ipad: ipad
	"GridBagConstraints​( int gridX, int gridY, int gridWidth, int gridHeight,
		double weightX, double weightY, int anchor, int fill, Insets insets, int ipadx, int ipady )"
	^ < 37 self 'java.awt.GridBagConstraints' ( grid x ) ( grid y ) ( aSize x ) ( aSize y )
		( weight x ) ( weight y ) anchor fill insets ( ipad x ) ( ipad y ) >.
!
META west
	"GridBagConstraints.WEST"
	^ 17.
!
META horizontal
	"GridBagConstraints.HORIZONTAL"
	^ 2.
!
META none
	"GridBagConstraints.NONE"
	^ 0.
!
META both
	"GridBagConstraints.BOTH"
	^ 1.
!
