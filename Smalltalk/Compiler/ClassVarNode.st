CLASS ParserNode subclass: 'ClassVarNode' variables: 'position' classVariables: ''
METHOD compile: encoder block: inBlock
   encoder genHigh: 14 low: position - 1.
!
METHOD position: p
   position := p.
!
