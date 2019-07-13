Class {
	#name : #HiMSearch,
	#superclass : #Object,
	#instVars : [
		'text',
		'topParentNodes'
	],
	#category : #'Rita-Navigator-Model'
}

{ #category : #accessing }
HiMSearch >> execute [
	| matchingNodes |
	matchingNodes := Array streamContents: [ :stream |
		topParentNodes do: [ :each |
			each withAllChildrenDo: [ :node |
				(node object includesSubstring: text caseSensitive: true) ifTrue: [ 
					stream nextPut: node ] ] ] ].

	^ HiMSearchResults newWith: matchingNodes
]

{ #category : #accessing }
HiMSearch >> text [
	^ text
]

{ #category : #accessing }
HiMSearch >> text: anObject [
	text := anObject
]

{ #category : #accessing }
HiMSearch >> topParentNodes [
	^ topParentNodes
]

{ #category : #accessing }
HiMSearch >> topParentNodes: anObject [
	topParentNodes := anObject
]
