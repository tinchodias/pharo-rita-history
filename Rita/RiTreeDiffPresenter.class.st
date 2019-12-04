Class {
	#name : #RiTreeDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'treeTable',
		'highlightDeferrer',
		'iceNodeCollectionToHighlight'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiTreeDiffPresenter class >> defaultSpec [
	<spec: #default>
	^ SpBoxLayout newHorizontal
		add: #treeTable;
		yourself
]

{ #category : #accessing }
RiTreeDiffPresenter >> changeListColumn [
	^ SpCompositeTableColumn new
		addColumn:
			(SpImageTableColumn new
				evaluated: [ :each | (model at: #aesthetics) iconForChange: each value ];
				yourself);
		addColumn:
			(SpImageTableColumn new
				evaluated: [ :each | (model at: #aesthetics) iconForDefinition: each value definition ];
				yourself);
		addColumn:
			(SpImageTableColumn new
				evaluated: [ :each | (model at: #aesthetics) rowForChange: each value ];
				yourself);
		yourself
]

{ #category : #accessing }
RiTreeDiffPresenter >> highlightIceNode: iceNodeCollection [
	iceNodeCollectionToHighlight := iceNodeCollection.
	highlightDeferrer schedule.
]

{ #category : #accessing }
RiTreeDiffPresenter >> indexPathFor: anIceNode [
	"Answer the sequence of indices of anIceNode in the treeTable"

	^ Array streamContents: [ :stream |
		| currentNodes |
		currentNodes := treeTable roots.
		anIceNode withAllParentNodes do: [ :each |
			| index |
			index := currentNodes indexOf: each.
			stream nextPut: index.
			currentNodes := (currentNodes at: index) children ]]
]

{ #category : #accessing }
RiTreeDiffPresenter >> initializePresenters [
	treeTable := self newTreeTable.
	self initializeTree.

	highlightDeferrer :=
		OmDeferrer 
			send: #refreshHighlight
			to: self
			after: 100 milliSeconds
]

{ #category : #accessing }
RiTreeDiffPresenter >> initializeTree [
	treeTable
		addColumn: self changeListColumn;
		children: [ :each | each children ];
		whenSelectionChangedDo: [ :selection |
			(model at: #blockWhenNodeSelected) value: selection selectedItem ].
	
	treeTable whenBuiltDo: [:ann |
		| table | 
		table := ann widget.
		table beRitaContainer.
		table container
			blockForMouseEnter: [ :rowIndex | 
				(model at: #blockWhenNodesHighlighted) value: {
					table dataSource realElementAt: rowIndex } ];
			blockForMouseLeave: [ :rowIndex | 
				(model at: #blockWhenNodesHighlighted) value: #() ] ]
]

{ #category : #accessing }
RiTreeDiffPresenter >> refreshHighlight [
	| table indices |
	table := treeTable adapter widget.

	indices := iceNodeCollectionToHighlight collect: [ :each |
		table dataSource indexOfElement: each  ].

	table highlightedIndexes = indices ifTrue: [ ^self ].
	
	(table highlightedIndexes isEmpty and: [ 
		indices noneSatisfy: [ :each | table isIndexVisible: each ] ])
			ifTrue: [ ^self ].

	"Do #highlightIndexes: but without auto-scrolling."
	self defer: [
		table
			basicHighlightIndexes: indices;
			refresh ]
]

{ #category : #accessing }
RiTreeDiffPresenter >> refreshOnModelUpdate [
	treeTable roots: (model at: #iceDiff) tree children.
	treeTable whenBuiltDo: [ :ann |
		ann widget dataSource expandAll ].
]

{ #category : #accessing }
RiTreeDiffPresenter >> selectIceNode: anIceNode [
	treeTable selectedItem = anIceNode ifTrue: [ ^ self ].
	treeTable selectPath: (self indexPathFor: anIceNode)
]
