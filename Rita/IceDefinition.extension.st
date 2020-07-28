Extension { #name : #IceDefinition }

{ #category : #'*Rita' }
IceDefinition >> ritaAsText [
	^ self ritaAsTextForTree0, ' · ', self ritaAsTextForTree1
]

{ #category : #'*Rita' }
IceDefinition >> ritaAsTextForPRConversation [
	^ self ritaAsText
]

{ #category : #'*Rita' }
IceDefinition >> ritaAsTextForTree0 [
	^ self name
]

{ #category : #'*Rita' }
IceDefinition >> ritaAsTextForTree1 [
	^ self ritaBasicAsText asString asText
]

{ #category : #'*Rita' }
IceDefinition >> ritaBasicAsText [
	^ (self class name allButFirst: 'Ice' size)
		allButLast: 'Definition' size
]
