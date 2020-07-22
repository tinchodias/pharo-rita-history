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

{ #category : #initialization }
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
	self shadowedIceNodes
		removeAllFoundIn: anIceNode allChildren;
		removeAllFoundIn: anIceNode withAllParentNodes.

	"Trigger update in self and in Torch view"
	(model at: #blockWhenShadowedIceNodesChanged) value.

]

{ #category : #private }
RiTreeDiffPresenter >> doCollapseSelectedNode [
	| item |
	item := treeTable adapter widget dataSource
		itemAtPath: treeTable selection selectedPath.
	(item hasChildren and: [ item isExpanded ]) 
		ifTrue: [ item collapseAndRefresh ]
		ifFalse: [ 
			| path |
			path := treeTable selection selectedPath.
			path size >= 2 ifTrue: [
				treeTable selectPath: path allButLast ] ].

	(model at: #collapsedIceNodes)
		add: treeTable selection selectedItem.
	(model at: #blockWhenCollapsedIceNodesChanged) value
]

{ #category : #private }
RiTreeDiffPresenter >> doExpandSelectedNodeAndSelectFirstChild [
	(treeTable adapter widget dataSource
		itemAtPath: treeTable selection selectedPath) expandAndRefresh.
	(model at: #collapsedIceNodes)
		remove: treeTable selection selectedItem
		ifAbsent: [].
	(model at: #blockWhenCollapsedIceNodesChanged) value
]

{ #category : #private }
RiTreeDiffPresenter >> doUncheck: anIceNode [
	self shadowedIceNodes
		add: anIceNode;
		addAll: anIceNode allChildren.

	"Trigger update in self and in Torch view"
	(model at: #blockWhenShadowedIceNodesChanged) value
]

{ #category : #accessing }
RiTreeDiffPresenter >> highlightIceNode: iceNodeCollection [
	iceNodeCollectionToHighlight := iceNodeCollection.
	highlightDeferrer schedule.
]

{ #category : #initialization }
RiTreeDiffPresenter >> initialize [
	super initialize.

	highlightDeferrer :=
		OmDeferrer 
			send: #refreshHighlight
			to: self
			after: 100 milliSeconds
]

{ #category : #initialization }
RiTreeDiffPresenter >> initializePresenters [
	treeTable := self newTreeTable.
	treeTable
		children: [ :each | each children ];
		whenSelectionChangedDo: [ :selection |
			(model at: #blockWhenNodeSelected) value: selection selectedItem ];
		contextMenu: [ self contextMenuForTable ];
		addColumn: self newColumnWithCheckboxes.

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

{ #category : #initialization }
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
	^ (self shadowedIceNodes includes: anIceNode) not
]

{ #category : #initialization }
RiTreeDiffPresenter >> newColumnWithCheckboxes [
	^ self newColumnWithIceNodes 
		addColumnFirst:
			(SpCheckBoxTableColumn new
				evaluated: [ :iceNode | self isChecked: iceNode ];
				onActivation: [ :iceNode | self doCheck: iceNode ];
				onDesactivation: [ :iceNode | self doUncheck: iceNode ];
				width: 20;
				yourself);
		yourself
]

{ #category : #initialization }
RiTreeDiffPresenter >> newColumnWithIceNodes [
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
	"Set tree roots starting at package level."
	| nodes |
	nodes := (model at: #iceDiff) tree children.
	(nodes allSatisfy: [ :each | each value definition isPackageDefinition ])
		ifFalse: [ nodes := nodes flatCollect: [ :each | each children ] ].
	treeTable roots: nodes.

	treeTable whenBuiltDo: [ :ann |
		ann widget dataSource expandAllTo: 1 ]

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
RiTreeDiffPresenter >> shadowedIceNodes [
	^ model at: #shadowedIceNodes
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
