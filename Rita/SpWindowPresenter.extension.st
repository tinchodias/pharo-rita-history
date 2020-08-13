Extension { #name : #SpWindowPresenter }

{ #category : #'*Rita' }
SpWindowPresenter >> hasToolbar [
	^ self toolbar notNil and: [ (self toolbar respondsTo: #notEmpty) and: [ self toolbar notEmpty ] ]
]
