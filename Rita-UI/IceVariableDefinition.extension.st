Extension { #name : #IceVariableDefinition }

{ #category : #'*Rita-UI' }
IceVariableDefinition >> ritaAsTextForTree0 [
	^ mcVariableDefinition name
]

{ #category : #'*Rita-UI' }
IceVariableDefinition >> ritaBasicAsText [
	^ self typeToShow = 'instance'
		ifTrue: [ 'Variable' ]
		ifFalse: [ self typeToShow capitalized , ' Variable' ]
]
