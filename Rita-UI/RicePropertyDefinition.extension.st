Extension { #name : 'RicePropertyDefinition' }

{ #category : '*Rita-UI' }
RicePropertyDefinition >> ritaAsTextForPRConversation [
	^ self containerIceDefinition ritaAsTextForPRConversation, ' (', self ritaAsText, ')'
]

{ #category : '*Rita-UI' }
RicePropertyDefinition >> ritaAsTextForTree0 [
	^ self ritaNameToShow
]

{ #category : '*Rita-UI' }
RicePropertyDefinition >> ritaAsTextForTree1 [
	^ super ritaAsTextForTree1, ' of ', self containerIceDefinition ritaBasicAsText
]

{ #category : '*Rita-UI' }
RicePropertyDefinition >> ritaNameToShow [
	| nameToShow |
	nameToShow := self name.
	nameToShow = 'superclassName'
		ifTrue: [ nameToShow := 'superclass' ].
	^ nameToShow
]
