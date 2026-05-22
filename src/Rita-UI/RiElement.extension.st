Extension { #name : 'RiElement' }

{ #category : '*Rita-UI' }
RiElement >> commitText [
	"Return a text describing the commit to display in the UI."

	^ self subclassResponsibility
]
