Extension { #name : 'RicePropertyDefinition' }

{ #category : '*Rita-UI' }
RicePropertyDefinition >> ritaAsTextForTree0 [

	^ self name = 'superclassName'
		  ifTrue: [ 'superclass' ]
		  ifFalse: [ self name ]
]

{ #category : '*Rita-UI' }
RicePropertyDefinition >> ritaAsTextForTree1 [

	^ super ritaAsTextForTree1, ' of ', self containerIceDefinition ritaBasicAsText
]
