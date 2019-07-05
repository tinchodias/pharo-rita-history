Extension { #name : #ZnEasy }

{ #category : #'*Rita-Navigator' }
ZnEasy class >> getImage: urlObject [
	| client |
	(client := self client)
		url: urlObject;
		enforceHttpSuccess: true;
		get.
	"ImageReadWriter does automatic type detection"
	^ ImageReadWriter formFromStream: client entity readStream
]