Extension { #name : #IceMethodDefinition }

{ #category : #'*Rita' }
IceMethodDefinition >> linesOfCode [
	^ sourceCode lines size
]

{ #category : #'*Rita' }
IceMethodDefinition >> ritaBasicAsText [
	^ (classIsMeta
		ifTrue: [ 'Class ' ]
		ifFalse: [ '' ]) asText allBold, super ritaBasicAsText
]
