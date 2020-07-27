Extension { #name : #IceDefinition }

{ #category : #'*Rita' }
IceDefinition >> ritaBasicDescription [
	^ (self class name allButFirst: 'Ice' size)
		allButLast: 'Definition' size
]

{ #category : #'*Rita' }
IceDefinition >> ritaDescription [
	^ self ritaBasicDescription asText allBold , ': ' , self name
]

{ #category : #'*Rita' }
IceDefinition >> ritaGlobalDescription [
	^ self ritaDescription asString
]
