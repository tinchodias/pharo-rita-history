Extension { #name : 'RiElement' }

{ #category : '*Rita-UI' }
RiElement >> commitText [
	"Return a text describing the commit to display in the UI."

	^ self subclassResponsibility
]

{ #category : '*Rita-UI' }
RiElement >> diffModelsWithPins: pinDiffModels [
	"Answer the diff models to show for me: the diff to my first ancestor, then every pin that applies to me. A pin applies to a single element, never to a range."

	| diffModels |
	diffModels := OrderedCollection new.
	self sourceRiElement ifNotNil: [ :source | diffModels add: (RiParentDiffModel parentRiElement: source) ].
	diffModels addAll: (pinDiffModels select: [ :each | each shouldCompareTo: self ]).
	^ diffModels
]
