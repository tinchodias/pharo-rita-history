Extension { #name : #IceMethodDefinition }

{ #category : #'*Rita' }
IceMethodDefinition >> linesOfCode [
	^ sourceCode lines size
]

{ #category : #'*Rita' }
IceMethodDefinition >> ritaDescription [
	^ (classIsMeta
		ifTrue: [ 'Class ' ]
		ifFalse: [ 'Instance ' ]) asText allBold, super ritaDescription
]
