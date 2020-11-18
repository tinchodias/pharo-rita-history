Extension { #name : #IceMethodDefinition }

{ #category : #'*Rita-Roassal3' }
IceMethodDefinition >> isUnitTest [
	^ self name beginsWith: 'test'
]
