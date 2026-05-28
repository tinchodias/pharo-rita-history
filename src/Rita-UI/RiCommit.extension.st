Extension { #name : 'RiCommit' }

{ #category : '*Rita-UI' }
RiCommit >> commitText [

	| signaturesText text |
	signaturesText := self committer = self author
		                  ifTrue: [ self textForSignature: self author role: 'Author & Committer' ]
		                  ifFalse: [ (self textForSignature: self author role: 'Author') , ' - ' , (self textForSignature: self committer role: 'Committer') ].

	text := Text streamContents: [ :stream |
			        stream
				        nextPutAll: 'SHA: ' asText allBold;
				        nextPutAll: self shortId;
				        nextPutAll: ' - ';
				        nextPutAll: signaturesText;
				        cr;
				        nextPutAll: 'Comment: ' asText allBold;
				        nextPutAll: self comment trimBoth ].

	^ text
]

{ #category : '*Rita-UI' }
RiCommit >> textForSignature: aLGitSignature role: aString [

	^ Text streamContents: [ :stream |
			  stream
				  nextPutAll: aString asText allBold;
				  nextPutAll: ': ';
				  nextPutAll: ('{1} ({2}) - {3}' format: {
								   aLGitSignature name.
								   aLGitSignature email.
								   aLGitSignature dateAndTime asEmailString }) ]
]
