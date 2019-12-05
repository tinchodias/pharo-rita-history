Extension { #name : #RubAbstractTextArea }

{ #category : #'*Rita' }
RubAbstractTextArea >> removeAllSegments [
	"Remove all segments"

	"Each segment's #delete removes itself from the collection."
	[ self segments isEmpty ] whileFalse: [ self segments anyOne delete ]
]
