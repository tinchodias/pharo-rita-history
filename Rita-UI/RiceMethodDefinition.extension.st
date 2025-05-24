Extension { #name : 'RiceMethodDefinition' }

{ #category : '*Rita-UI' }
RiceMethodDefinition >> linesOfCode [
	^ sourceCode lineCount
]

{ #category : '*Rita-UI' }
RiceMethodDefinition >> ritaBasicAsText [

	^ (classIsMeta
		ifTrue: [ 'Class ' ]
		ifFalse: [ '' ]) asText allBold, super ritaBasicAsText
]
