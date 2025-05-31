Extension { #name : 'MCDefinition' }

{ #category : '*Rita-Model' }
MCDefinition >> basicAtPropertyNamed: aString [

	^ self instVarNamed: aString
]

{ #category : '*Rita-Model' }
MCDefinition >> basicAtPropertyNamed: aString put: anObject [

	^ self instVarNamed: aString put: anObject
]
