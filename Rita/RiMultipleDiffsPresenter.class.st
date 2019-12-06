Class {
	#name : #RiMultipleDiffsPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table'
	],
	#category : #'Rita-UI-Diff'
}

{ #category : #specs }
RiMultipleDiffsPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #table;
		yourself
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> diffMorphFor: iceNode [

	| aesthetics |
	aesthetics := model at: #aesthetics.

	^ aesthetics columnMorphWithAll: {
			aesthetics pathMorphWith: iceNode.
			(aesthetics diffMorphFor: iceNode)
				hResizing: #spaceFill;
				vResizing: #spaceFill;
				beWrapped;
				yourself
		}
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> initializePresenters [

	table := self newTable
		hideColumnHeaders;
		addColumn: (SpImageTableColumn evaluated: #second);
		whenBuiltDo: [ :ann | 
			ann widget beRowNotHomogeneous.
			RiMultipleDiffDataSource adoptInstance: ann widget dataSource ];
		yourself
]

{ #category : #initialization }
RiMultipleDiffsPresenter >> refreshOnModelUpdate [
	
	table items: ((model at: #diffQuery) allLeafChildren
		collect: [ :each | { each. self diffMorphFor: each } ])

]

{ #category : #initialization }
RiMultipleDiffsPresenter >> selectIceNode: anIceNode [

	|  index |
	anIceNode ifNil: [ ^self ].
	index := (table items collect: #first) indexOf: anIceNode.
	index < 1 ifTrue: [ ^self ].

	table adapter widget scrollToIndex: index

]

{ #category : #initialization }
RiMultipleDiffsPresenter >> setIceNode: iceNode in: presenter [
	iceNode ifNil: [ ^self ].
	presenter model: { 
		#from -> iceNode value rightContents.
		#to -> iceNode value leftContents.
		} asDictionary
]
