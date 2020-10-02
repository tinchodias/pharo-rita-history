Extension { #name : #IceMethodDefinition }

{ #category : #'*Rita-UI' }
IceMethodDefinition >> linesOfCode [
	^ sourceCode lines size
]

{ #category : #'*Rita-UI' }
IceMethodDefinition >> ritaBasicAsText [
	^ (classIsMeta
		ifTrue: [ 'Class ' ]
		ifFalse: [ '' ]) asText allBold, super ritaBasicAsText
]
