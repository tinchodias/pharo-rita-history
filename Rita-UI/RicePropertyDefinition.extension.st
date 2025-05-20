Extension { #name : #RicePropertyDefinition }

{ #category : #'*Rita-UI' }
RicePropertyDefinition >> ritaAsTextForPRConversation [
	^ self ownerIceDefinition ritaAsTextForPRConversation, ' (', self ritaAsText, ')'
]

{ #category : #'*Rita-UI' }
RicePropertyDefinition >> ritaAsTextForTree0 [
	^ self ritaNameToShow
]

{ #category : #'*Rita-UI' }
RicePropertyDefinition >> ritaAsTextForTree1 [
	^ super ritaAsTextForTree1, ' of ', self ownerIceDefinition ritaBasicAsText
]

{ #category : #'*Rita-UI' }
RicePropertyDefinition >> ritaNameToShow [
	| nameToShow |
	nameToShow := self name.
	nameToShow = 'superclassName'
		ifTrue: [ nameToShow := 'superclass' ].
	^ nameToShow
]
