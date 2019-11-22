Extension { #name : #IceOperation }

{ #category : #'*Rita-Torch' }
IceOperation >> ritaChangeSize [
	^ definition sourceCode lines size sqrt
]

{ #category : #'*Rita-Torch' }
IceOperation >> ritaIsNoModification [
	^ false
]
