Class {
	#name : #HiMSearch,
	#superclass : #Object,
	#instVars : [
		'text',
		'topParentNodes',
		'includeBlock'
	],
	#category : #'Rita-Navigator-Model'
}

{ #category : #accessing }
HiMSearch >> execute [
	| matchingNodes |
	matchingNodes := Array streamContents: [ :stream |
		topParentNodes do: [ :each |
			each withAllChildrenDo: [ :node |
				(includeBlock cull: node cull: text) ifTrue: [
					stream nextPut: node ] ] ] ].

	^ matchingNodes
		ifEmpty: [ HiMNoResults new ] 
		ifNotEmpty: [ HiMSearchResults newWith: matchingNodes ]
]

{ #category : #accessing }
HiMSearch >> includeBlock [
	^ includeBlock
]

{ #category : #accessing }
HiMSearch >> includeBlock: aBlockClosure [
	includeBlock:= aBlockClosure
]

{ #category : #initialization }
HiMSearch >> initialize [
	super initialize.
	
	includeBlock := [ :aHiMNode :aString |
		aHiMNode object includesSubstring: aString caseSensitive: true ].
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
