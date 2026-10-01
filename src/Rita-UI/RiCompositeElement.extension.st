Extension { #name : 'RiCompositeElement' }

{ #category : '*Rita-UI' }
RiCompositeElement >> commitText [
	"Return a text describing the range of commits to display in the UI."

	| text |
	text := Text streamContents: [ :stream |
			        stream
				        nextPutAll: 'Range of ' asText allBold;
				        nextPutAll: self size printString;
				        nextPutAll: ' commits: ';
				        nextPutAll: self newestElement shortId;
				        nextPutAll: ' to ';
				        nextPutAll: self oldestElement shortId;
				        cr;
				        nextPutAll: 'Cumulative diff: ' asText allBold;
				        nextPutAll: (self sourceRiElement
						         ifNil: [ 'the start of the history' ]
						         ifNotNil: [ :each | each shortId ]);
				        nextPutAll: ' to ';
				        nextPutAll: self targetRiElement shortId ].
	^ text
]
