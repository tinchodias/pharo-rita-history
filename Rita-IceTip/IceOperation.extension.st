Extension { #name : #IceOperation }

{ #category : #'*Rita-IceTip' }
IceOperation >> ritaChangeSize [
	^ definition sourceCode lines size log
]

{ #category : #'*Rita-IceTip' }
IceOperation >> ritaColor [
	^ Color cyan muchDarker mixed: 0.5 with: Color blue
]

{ #category : #'*Rita-IceTip' }
IceOperation >> ritaIsNoModification [
	^ false
]
