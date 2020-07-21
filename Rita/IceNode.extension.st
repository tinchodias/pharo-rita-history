Extension { #name : #IceNode }

{ #category : #'*Rita' }
IceNode >> allChildren [
	^ Array streamContents: [ :stream |
		self allChildrenDo: [ :each | stream nextPut: each ] ]
]
