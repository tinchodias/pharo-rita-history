Extension { #name : #IcePropertyDefinition }

{ #category : #'*Rita-UI' }
IcePropertyDefinition >> ritaAsTextForPRConversation [
	^ self ownerIceDefinition ritaAsTextForPRConversation, ' (', self ritaAsText, ')'
]

{ #category : #'*Rita-UI' }
IcePropertyDefinition >> ritaAsTextForTree0 [
	^ self ritaNameToShow
]

{ #category : #'*Rita-UI' }
IcePropertyDefinition >> ritaAsTextForTree1 [
	^ super ritaAsTextForTree1, ' of ', self ownerIceDefinition ritaBasicAsText
]

{ #category : #'*Rita-UI' }
IcePropertyDefinition >> ritaNameToShow [
	| nameToShow |
	nameToShow := self name.
	nameToShow = 'superclassName'
		ifTrue: [ nameToShow := 'superclass' ].
	^ nameToShow
]
