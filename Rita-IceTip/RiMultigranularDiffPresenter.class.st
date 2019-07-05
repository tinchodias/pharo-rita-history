Class {
	#name : #RiMultigranularDiffPresenter,
	#superclass : #RiDiffPresenter,
	#instVars : [
		'labelStrategy'
	],
	#category : #'Rita-IceTip'
}

{ #category : #private }
RiMultigranularDiffPresenter >> buildDiffOn: view [

	TSLine delta: 1.	"Note: global effect!"

	(HiMNavigator newOn: view)
		labelStrategy: self labelStrategy;
		addElementsFor: self initialNodes;
		yourself.

"	view @ RSControlsView."
	view camera scale: 5.
]

{ #category : #private }
RiMultigranularDiffPresenter >> initialNodes [
	
	| visitor |
	visitor := RiIceDiffEntityCollector new.
	iceDiffModel tree accept: visitor.

	^ visitor nodesWithPackages collect: [:each | self nodeForPackageNode: each ].
	

]

{ #category : #accessing }
RiMultigranularDiffPresenter >> labelStrategy [
	^ labelStrategy
]

{ #category : #accessing }
RiMultigranularDiffPresenter >> labelStrategy: anObject [
	labelStrategy := anObject
]

{ #category : #private }
RiMultigranularDiffPresenter >> nodeForClassLevelNode: node [
	| result |
	result := HiMNode for: node.
	node children
		collect: [ :each | HiMNode for: each key ]
		thenDo: [:each | result addChild: each ].
	^ result

]

{ #category : #private }
RiMultigranularDiffPresenter >> nodeForPackageNode: node [
	| result |
	result := HiMNode for: node.
	node children
		collect: [ :each | self nodeForClassLevelNode: each ]
		thenDo: [ :each | result addChild: each ].
	^ result
]