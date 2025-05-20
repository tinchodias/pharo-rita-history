Extension { #name : #RiceDefinition }

{ #category : #'*Rita-UI' }
RiceDefinition >> ritaAsText [
	^ self ritaAsTextForTree0, ' · ', self ritaAsTextForTree1
]

{ #category : #'*Rita-UI' }
RiceDefinition >> ritaAsTextForPRConversation [
	^ self ritaAsText
]

{ #category : #'*Rita-UI' }
RiceDefinition >> ritaAsTextForTree0 [
	^ self name
]

{ #category : #'*Rita-UI' }
RiceDefinition >> ritaAsTextForTree1 [
	^ self ritaBasicAsText asString asText
]

{ #category : #'*Rita-UI' }
RiceDefinition >> ritaBasicAsText [
	^ (self class name allButFirst: 'Ice' size)
		allButLast: 'Definition' size
]
