Extension { #name : #SpMorphicTreeTableDataSource }

{ #category : #'*Rita' }
SpMorphicTreeTableDataSource >> cellIndentFor: item [ 

	^ item depth * 8 "FIX: it was hardcoded at 16 but was too much"
]
