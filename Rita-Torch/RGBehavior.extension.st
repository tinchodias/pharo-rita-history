Extension { #name : #RGBehavior }

{ #category : #'*Rita-Torch' }
RGBehavior >> hasMethodExtensions [
	^ self methods anySatisfy: #isExtension
]
