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
			aesthetics pathMorphWith: iceNode allPathSegments.
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

	|  tableItemToSelect |
	tableItemToSelect := table items detect: [ :each |  each first = anIceNode ]  ifNone: [ ^ self ].

	table selectItem: tableItemToSelect

]

{ #category : #initialization }
RiMultipleDiffsPresenter >> setIceNode: iceNode in: presenter [
	iceNode ifNil: [ ^self ].
	presenter model: { 
		#from -> iceNode value rightContents.
		#to -> iceNode value leftContents.
		} asDictionary
]
