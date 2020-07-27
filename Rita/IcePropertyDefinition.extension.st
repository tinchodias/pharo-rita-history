Extension { #name : #IcePropertyDefinition }

{ #category : #'*Rita' }
IcePropertyDefinition >> ritaDescription [

	| nameToShow |
	self flag: #fix.
	nameToShow := self name.
	nameToShow = 'superclassName' ifTrue: [ nameToShow := 'superclass' ].
	nameToShow = 'source' ifTrue: [ nameToShow := 'source code' ].
	^ (self containerIceDefinition ritaBasicDescription , ' ' , nameToShow)
		asText allBold
]
