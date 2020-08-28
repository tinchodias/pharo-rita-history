Extension { #name : #IcePropertyDefinition }

{ #category : #'*Rita' }
IcePropertyDefinition >> ritaAsTextForPRConversation [
	^ self containerIceDefinition ritaAsTextForPRConversation, ' (', self ritaAsText, ')'
]

{ #category : #'*Rita' }
IcePropertyDefinition >> ritaAsTextForTree0 [
	^ self ritaNameToShow
]

{ #category : #'*Rita' }
IcePropertyDefinition >> ritaAsTextForTree1 [
	^ super ritaAsTextForTree1, ' of ', self containerIceDefinition ritaBasicAsText
]

{ #category : #'*Rita' }
IcePropertyDefinition >> ritaNameToShow [
	| nameToShow |
	nameToShow := self name.
	nameToShow = 'superclassName'
		ifTrue: [ nameToShow := 'superclass' ].
	^ nameToShow
]
