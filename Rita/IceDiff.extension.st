Extension { #name : #IceDiff }

{ #category : #'*Rita' }
IceDiff >> ritaShortId [
	^ '{1}...{2}'
		format:
			{self sourceVersion shortId.
			self targetVersion shortId}
]
