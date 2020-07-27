Extension { #name : #RGBehavior }

{ #category : #'*Zurich' }
RGBehavior >> allSubclasses [
	"Answer an orderedCollection of the receiver's and the receiver's descendent's subclasses. "

	| scan scanTop |
	scan := OrderedCollection withAll: self subclasses.
	scanTop := 1.
	[scanTop > scan size]
		whileFalse: [scan addAll: (scan at: scanTop) subclasses.
			scanTop := scanTop + 1].
	^ scan
]

{ #category : #'*Zurich' }
RGBehavior >> withAllSubclasses [
	"Answer a Set of the receiver, the receiver's descendent's, and the  
	receiver's descendent's subclasses."

	^ self allSubclasses add: self;
		 yourself
]

{ #category : #'*Zurich' }
RGBehavior >> withAllSuperAndSubclasses [
	"Answer the receiver's class hierarchy"

	^self allSuperclasses, self withAllSubclasses
]
