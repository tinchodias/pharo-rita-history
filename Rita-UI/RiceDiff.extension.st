Extension { #name : 'RiceDiff' }

{ #category : '*Rita-UI' }
RiceDiff >> ritaShortId [
	^ '{1}...{2}'
		format:
			{self sourceVersion shortId.
			self targetVersion shortId}
]
