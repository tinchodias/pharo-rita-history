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

{ #category : '*Rita-UI' }
RiCompositeElement >> diffModelsWithPins: pinDiffModels [
	"Answer the single cumulative diff model for my whole range. Pins compare to a single element, so none of them applies to me."

	^ (self sourceRiElement isNotNil and: [ self targetRiElement isNotNil ])
		  ifTrue: [ { (RiCompositeDiffModel riCompositeElement: self) } ]
		  ifFalse: [ #(  ) ]
]
