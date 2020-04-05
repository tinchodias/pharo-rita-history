Extension { #name : #LGitSignature }

{ #category : #'*Rita' }
LGitSignature >> email [
	^ self prim_email readStringUTF8
]

{ #category : #'*Rita' }
LGitSignature >> name [
	^ self prim_name readStringUTF8
]
