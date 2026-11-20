Extension { #name : 'RiceVariableDefinition' }

{ #category : '*Rita-UI' }
RiceVariableDefinition >> ritaAsTextForTree0 [

	^ name
]

{ #category : '*Rita-UI' }
RiceVariableDefinition >> ritaBasicAsText [
	^ self typeToShow = 'instance'
		ifTrue: [ 'Variable' ]
		ifFalse: [ self typeToShow capitalized , ' Variable' ]
]
