Extension { #name : #IceDefinition }

{ #category : #'*Rita-UI' }
IceDefinition >> ritaAsText [
	^ self ritaAsTextForTree0, ' · ', self ritaAsTextForTree1
]

{ #category : #'*Rita-UI' }
IceDefinition >> ritaAsTextForPRConversation [
	^ self ritaAsText
]

{ #category : #'*Rita-UI' }
IceDefinition >> ritaAsTextForTree0 [
	^ self name
]

{ #category : #'*Rita-UI' }
IceDefinition >> ritaAsTextForTree1 [
	^ self ritaBasicAsText asString asText
]

{ #category : #'*Rita-UI' }
IceDefinition >> ritaBasicAsText [
	^ (self class name allButFirst: 'Ice' size)
		allButLast: 'Definition' size
]
