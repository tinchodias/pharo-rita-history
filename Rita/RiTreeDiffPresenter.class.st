Class {
	#name : #RiTreeDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'treeTable',
		'highlightDeferrer',
		'iceNodeCollectionToHighlight',
		'checkedNodes'
	],
	#category : #'Rita-UI-Diff'
}

{ #category : #specs }
RiTreeDiffPresenter class >> defaultSpec [
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

{ #category : #private }
RiTreeDiffPresenter >> checkedNodes [
	^ model at: #checkedIceNodes
]

{ #category : #accessing }
RiTreeDiffPresenter >> contextMenuForTable [
	| menu selected |
	menu := self newMenu.
	
	selected := treeTable selection selectedItem.

"	menu addItem: [ :item |
		item
			name: 'Check all children';
			action: [ self doCheckAllChildrenOf: selected  ] ].
	menu addItem: [ :item |
		item
			name: 'Uncheck all children';
			action: [ self doUncheckAllChildrenOf: selected  ] ].
"	menu addItem: [ :item | 
		item
			name: 'Inspect object';
			action: [ selected inspect ] ].

	^ menu
]

{ #category : #private }
RiTreeDiffPresenter >> doCheck: anIceNode [
	self checkedNodes add: anIceNode.
	anIceNode allChildrenDo: [ :each |
		self checkedNodes add: each ].

	"Trigger update in self and in Torch view"
	(model at: #blockWhenCheckedNodesChanged) value.

]

{ #category : #private }
RiTreeDiffPresenter >> doExpandSelectedNodeAndSelectFirstChild [
	(treeTable adapter widget dataSource
		itemAtPath: treeTable selection selectedPath) expand.
	(model at: #collapsedIceNodes)
		remove: treeTable selection selectedItem
		ifAbsent: [ ^ self ].
	(model at: #blockWhenCollapsedIceNodesChanged) value
]

{ #category : #private }
RiTreeDiffPresenter >> doUncheck: anIceNode [
	self checkedNodes remove: anIceNode ifAbsent: [ ].
	anIceNode allChildrenDo: [ :each |
		self checkedNodes remove: each ifAbsent: [ ] ].

	"Trigger update in self and in Torch view"
	(model at: #blockWhenCheckedNodesChanged) value.

]

{ #category : #accessing }
RiTreeDiffPresenter >> highlightIceNode: iceNodeCollection [
	iceNodeCollectionToHighlight := iceNodeCollection.
	highlightDeferrer schedule.
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
		children: [ :each | each children ];
		whenSelectionChangedDo: [ :selection |
			(model at: #blockWhenNodeSelected) value: selection selectedItem ];
		contextMenu: [ self contextMenuForTable ];
		addColumn: self newColumn.

	self initializeTreeKeyCombinations.
	
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
RiTreeDiffPresenter >> initializeTreeKeyCombinations [
		
	treeTable
		bindKeyCombination: Character space 
			toAction: [ self toggleSelection ].

	treeTable
		bindKeyCombination: Character arrowLeft
			toAction: [ self doCollapseSelectedNode ].

	treeTable
		bindKeyCombination: Character arrowRight
			toAction: [ self doExpandSelectedNodeAndSelectFirstChild ].

]

{ #category : #private }
RiTreeDiffPresenter >> isChecked: anIceNode [
	^ self checkedNodes includes: anIceNode
]

{ #category : #accessing }
RiTreeDiffPresenter >> newColumn [
	^ SpCompositeTableColumn new
		title: ' ';
		addColumn: 
			(SpCheckBoxTableColumn new
				title: ' ';
				evaluated: [ :iceNode | self isChecked: iceNode ];
				onActivation: [ :iceNode | self doCheck: iceNode ];
				onDesactivation: [ :iceNode | self doUncheck: iceNode ];
				width: 20;
				yourself);
		addColumn: self changeListColumn;
		yourself
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

{ #category : #private }
RiTreeDiffPresenter >> refreshOnCheckedIceNodesChanged [
	self defer: [ treeTable adapter widget refresh ]
]

{ #category : #accessing }
RiTreeDiffPresenter >> refreshOnModelUpdate [
	treeTable roots: (model at: #iceDiff) tree children.

	treeTable whenBuiltDo: [ :ann |
		ann widget dataSource expandAll ]

]

{ #category : #accessing }
RiTreeDiffPresenter >> selectIceNode: anIceNode [
	treeTable selectedItem = anIceNode
		ifTrue: [ ^ self ].
	treeTable
		selectPath: (treeTable selection pathOf: anIceNode)
		scrollToSelection: true
]

{ #category : #private }
RiTreeDiffPresenter >> toggleSelection [
	| anIceNode |
	anIceNode := treeTable selection selectedItem.
	anIceNode ifNil: [ ^self ].
	(self isChecked: anIceNode)
		ifTrue: [ self doUncheck: anIceNode ]
		ifFalse: [ self doCheck: anIceNode ]
]
