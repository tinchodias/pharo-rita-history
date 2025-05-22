Extension { #name : 'MCClassDefinition' }

{ #category : '*Rita-Model' }
MCClassDefinition >> basicAtPropertyNamed: aString [ 
	
	^ self instVarNamed: aString
]
