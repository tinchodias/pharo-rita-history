Extension { #name : #IceOperation }

{ #category : #'*Rita-Torch' }
IceOperation >> ritaChangeSize [
	^ definition sourceCode lines size log
]

{ #category : #'*Rita-Torch' }
IceOperation >> ritaColor [
	^ Color cyan muchDarker mixed: 0.5 with: Color blue
]

{ #category : #'*Rita-Torch' }
IceOperation >> ritaIsNoModification [
	^ false
]
