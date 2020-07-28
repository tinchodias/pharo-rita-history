Extension { #name : #IceVariableDefinition }

{ #category : #'*Rita' }
IceVariableDefinition >> ritaAsTextForTree0 [
	^ mcVariableDefinition name
]

{ #category : #'*Rita' }
IceVariableDefinition >> ritaBasicAsText [
	^ self typeToShow = 'instance'
		ifTrue: [ 'Variable' ]
		ifFalse: [ self typeToShow capitalized , ' Variable' ]
]
