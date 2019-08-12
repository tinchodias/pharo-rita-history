Extension { #name : #RGBehavior }

{ #category : #'*Rita-IceTip' }
RGBehavior >> hasMethodExtensions [
	^ self methods anySatisfy: #isExtension
]
