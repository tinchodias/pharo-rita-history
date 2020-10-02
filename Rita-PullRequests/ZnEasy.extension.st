Extension { #name : #ZnEasy }

{ #category : #'*Rita-PullRequests' }
ZnEasy class >> getImage: urlObject [
	| client |
	(client := self client)
		url: urlObject;
		enforceHttpSuccess: true;
		get.
	"ImageReadWriter does automatic type detection"
	^ ImageReadWriter formFromStream: client entity readStream
]
