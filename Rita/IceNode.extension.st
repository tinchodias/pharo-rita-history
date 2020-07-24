Extension { #name : #IceNode }

{ #category : #'*Rita' }
IceNode >> allChildren [
	^ Array streamContents: [ :stream |
		self allChildrenDo: [ :each | stream nextPut: each ] ]
]

{ #category : #'*Rita' }
IceNode >> allParentNodes [

	self isRoot ifTrue: [ ^ #() ].
	self parent isRoot ifTrue: [ ^ { self } ].
	^ self parent withAllParentNodes
]
