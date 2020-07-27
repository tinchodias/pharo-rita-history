Extension { #name : #IceVariableDefinition }

{ #category : #'*Rita' }
IceVariableDefinition >> ritaBasicDescription [
	^ self typeToShow, ' Variable'
]

{ #category : #'*Rita' }
IceVariableDefinition >> ritaDescription [
	^ (self typeToShow capitalized, ' Variable') asText allBold, ': ', mcVariableDefinition name
]
