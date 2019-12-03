Extension { #name : #FTTreeDataSource }

{ #category : #'*Rita' }
FTTreeDataSource >> indexOfElement: anObject [
	1 to: self numberOfRows do: [ :index |
		(self realElementAt: index) = anObject 
			ifTrue: [ ^ index ] ].
	^ 0
]
