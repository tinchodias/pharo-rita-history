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
			name: 'Collapse with all children';
			action: [ self doCollapseSelectedNode  ] ].
	menu addItem: [ :item |
		item
			name: 'Expand with all children';
			action: [ self doExpandSelectedNode ] ].
"	menu addItem: [ :item | 
		item
			name: 'Inspect object';
			icon: (self iconNamed: #smallInspectIt);
			action: [ selected inspect ] ].

	^ menu
]

{ #category : #'check/uncheck' }
RiTreeDiffPresenter >> doCheck: anIceNode [
	self shadowedIceNodes
		removeAllFoundIn: anIceNode allChildren;
		removeAllFoundIn: anIceNode withAllParentNodes.

	"Trigger update in self and in Torch view"
	(model at: #blockWhenShadowedIceNodesChanged) value.

]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> doCollapseSelectedNode [
	self doValueOnSelectedFastTableItemToExpandOrCollapse: [ :fastTableItem | 
		(fastTableItem hasChildren and: [ fastTableItem isExpanded ]) 
			ifTrue: [ fastTableItem collapse ]
			ifFalse: [ 
				| path |
				path := treeTable selection selectedPath.
				path size >= 2 ifTrue: [
					treeTable selectPath: path allButLast ] ] ]
]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> doExpandSelectedNode [
	self doValueOnSelectedFastTableItemToExpandOrCollapse: [ :item | item expand ]
]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> doInitialTreeExpansion [
	| expanded items |
	expanded := model at: #expandedIceNodes.
	
	items := OrderedCollection withAll: treeTable adapter widget dataSource rootsItems.
	[ items notEmpty ] whileTrue: [
		| aFastTableItem |
		aFastTableItem := items removeFirst.
		(expanded includes: aFastTableItem data) ifTrue: [
			aFastTableItem expand.
			items addAll: aFastTableItem children ] ].

	treeTable adapter widget refresh.
]

{ #category : #'check/uncheck' }
RiTreeDiffPresenter >> doUncheck: anIceNode [
	self shadowedIceNodes
		add: anIceNode;
		addAll: anIceNode allChildren.

	"Trigger update in self and in Torch view"
	(model at: #blockWhenShadowedIceNodesChanged) value
]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> doValueOnSelectedFastTableItemToExpandOrCollapse: aBlock [
	| fastTableItem |
	fastTableItem := treeTable adapter widget dataSource
		itemAtPath: treeTable selection selectedPath.

	aBlock value: fastTableItem.

	(model at: #expandedIceNodes) add: fastTableItem data.
	(model at: #blockWhenExpandedIceNodesChanged) value
]

{ #category : #highlighting }
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
			toAction: [ self doExpandSelectedNode ].

]

{ #category : #'check/uncheck' }
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

{ #category : #highlighting }
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

{ #category : #'check/uncheck' }
RiTreeDiffPresenter >> refreshOnCheckedIceNodesChanged [
	self defer: [ treeTable adapter widget refresh ]
]

{ #category : #accessing }
RiTreeDiffPresenter >> refreshOnModelUpdate [
	| iceNodes |
	iceNodes := (model at: #iceDiff) tree children.
	treeTable roots: iceNodes.
	treeTable whenBuiltDo: [ :ann | self doInitialTreeExpansion ]
]

{ #category : #highlighting }
RiTreeDiffPresenter >> selectIceNode: anIceNode [
	treeTable selectedItem = anIceNode
		ifTrue: [ ^ self ].
	treeTable
		selectPath: (treeTable selection pathOf: anIceNode)
		scrollToSelection: true
]

{ #category : #'check/uncheck' }
RiTreeDiffPresenter >> shadowedIceNodes [
	^ model at: #shadowedIceNodes
]

{ #category : #'check/uncheck' }
RiTreeDiffPresenter >> toggleSelection [
	| anIceNode |
	anIceNode := treeTable selection selectedItem.
	anIceNode ifNil: [ ^self ].
	(self isChecked: anIceNode)
		ifTrue: [ self doUncheck: anIceNode ]
		ifFalse: [ self doCheck: anIceNode ]
]
