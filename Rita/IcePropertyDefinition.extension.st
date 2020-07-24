Extension { #name : #IcePropertyDefinition }

{ #category : #'*Rita' }
IcePropertyDefinition >> ritaDescription [
	^ (self containerIceDefinition ritaBasicDescription , ' ' , self name)
		asText allBold
]
