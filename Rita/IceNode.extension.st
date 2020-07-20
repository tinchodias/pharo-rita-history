Extension { #name : #IceNode }

{ #category : #'*Rita' }
IceNode >> allChildrenNodes [
	^ Array streamContents: [ :stream |
		self allChildrenDo: [ :each | stream nextPut: each ] ]
]
