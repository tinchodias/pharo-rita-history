Extension { #name : #IcePropertyDefinition }

{ #category : #'*Rita' }
IcePropertyDefinition >> ritaDescription [

	^ (self containerIceDefinition ritaBasicDescription , ' ' , self ritaNameToShow)
		asText allBold
]

{ #category : #'*Rita' }
IcePropertyDefinition >> ritaGlobalDescription [

	^ self containerIceDefinition ritaGlobalDescription, ' (', self ritaDescription, ')'
]

{ #category : #'*Rita' }
IcePropertyDefinition >> ritaNameToShow [
	| nameToShow |
	self flag: #fix.
	nameToShow := self name.
	nameToShow = 'superclassName'
		ifTrue: [ nameToShow := 'superclass' ].
	nameToShow = 'source'
		ifTrue: [ nameToShow := 'source code' ].
	^ nameToShow
]
