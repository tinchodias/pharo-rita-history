Class {
	#name : #RiTreeDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'treeTable',
		'highlightDeferrer',
		'iceNodeCollectionToHighlight',
		'expandDeferrer'
	],
	#category : #'Rita-UI-Spec2-Diff'
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

	menu addItem: [ :item |
		item
			name: 'Expand with all children';
			action: [ self doExpandWithAllChildren ] ].
	menu addItem: [ :item |
		item
			name: 'Collapse with all children';
			action: [ self doCollapseWithAllChildren  ] ].
	menu addItem: [ :item | 
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
RiTreeDiffPresenter >> doCollapseOneLevel [
	self doValueOnSelectedFastTableItemToExpandOrCollapse: [ :fastTableItem | 
		(fastTableItem hasChildren and: [ fastTableItem isExpanded ]) 
			ifTrue: [ fastTableItem collapse ]
			ifFalse: [ 
				| path |
				path := treeTable selection selectedPath.
				path size >= 2 ifTrue: [
					treeTable
						selectPath: path allButLast
						scrollToSelection: true ] ] ]
]

{ #category : #'expanding-collapsing' }
RiTreeDiffPresenter >> doCollapseWithAllChildren [
	self
		doValueOnSelectedFastTableItemToExpandOrCollapse: [ :fastTableItem | 
			treeTable unselectAll. "This seems to avoid a random error"
			fastTableItem
				collapseAll";
				refreshTable" ]
]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> doExpandOneLevel [
	self
		doValueOnSelectedFastTableItemToExpandOrCollapse: [ :fastTableItem | fastTableItem expand ]
]

{ #category : #'collapse/expand' }
RiTreeDiffPresenter >> doExpandWithAllChildren [
	self
		doValueOnSelectedFastTableItemToExpandOrCollapse: [ :fastTableItem | 
			treeTable unselectAll. "This seems to avoid a random error"
			fastTableItem
				expandAll";
				refreshTable" ]
]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> doInitialTreeExpansionOn: aFastTable [
	| expanded items |
	expanded := model at: #expandedIceNodes.
	
	"Initially, all items are collapsed. Iterate from roots to expand those marked in the model."
	items := OrderedCollection withAll: aFastTable dataSource rootsItems.
	[ items notEmpty ] whileTrue: [
		| aFastTableItem |
		aFastTableItem := items removeFirst.
		(expanded includes: aFastTableItem data) ifTrue: [
			aFastTableItem expand.
			items addAll: aFastTableItem children ] ].

	aFastTable refresh.
]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> doToggleExpandOneLevel [
	self
		doValueOnSelectedFastTableItemToExpandOrCollapse: [ :fastTableItem | 
			fastTableItem toggle ]
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

	aBlock value: fastTableItem
]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> hackFastTableForExpandCollapse: aFastTable [
	RiFTRootItem adoptInstance: aFastTable dataSource rootItem.
	aFastTable dataSource rootItem
		allChildrenDo: [ :each | RiFTBasicItem adoptInstance: each ].

	RiFTBasicItem hackyAnnouncer weak
		when: RiFTHackyExpand
		send: #onHackyExpand:
		to: self.
		
	RiFTBasicItem hackyAnnouncer weak
		when: RiFTHackyCollapse
		send: #onHackyCollapse:
		to: self
]

{ #category : #highlighting }
RiTreeDiffPresenter >> hackFastTableForSecondaryHighligthing: table [
	table beRitaContainer.
	table container
		blockForMouseEnter: [ :rowIndex | 
			(model at: #blockWhenNodesHighlighted)
				value: {(table dataSource realElementAt: rowIndex)} ];
		blockForMouseLeave: [ :rowIndex |
			(model at: #blockWhenNodesHighlighted) value: #() ].


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
			after: 100 milliSeconds.

	expandDeferrer :=
		OmDeferrer 
			send: #refreshExpand
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
	
	treeTable whenBuiltDo: [:ann |
		"Note: All items are already instantiated at this point"
		| table |
		table := ann widget.
		self hackFastTableForSecondaryHighligthing: table.
		self doInitialTreeExpansionOn: table.
		self hackFastTableForExpandCollapse: table.
		self initializeTreeKeyCombinations ]
]

{ #category : #initialization }
RiTreeDiffPresenter >> initializeTreeKeyCombinations [
		
	treeTable
		bindKeyCombination: Character space 
			toAction: [ self toggleSelection ].

	treeTable
		bindKeyCombination: Character arrowLeft
			toAction: [ self doCollapseOneLevel ].

	treeTable
		bindKeyCombination: Character arrowRight
			toAction: [ self doExpandOneLevel ].

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
				onDeactivation: [ :iceNode | self doUncheck: iceNode ];
				width: 20;
				yourself);
		yourself
]

{ #category : #initialization }
RiTreeDiffPresenter >> newColumnWithIceNodes [
	^ SpCompositeTableColumn withAll: {
		(SpImageTableColumn evaluated: [ :each |
			(model at: #aesthetics) iconForChange: each value ]).
		(SpStringTableColumn evaluated: [ :each |
			' ', each value definition ritaAsTextForTree0 ]).
		(SpStringTableColumn evaluated: [ :each |
			(' ·  ', each value definition ritaAsTextForTree1) asText
				addAttribute: (TextFontReference toFont: StandardFonts balloonFont);
				makeAllColor: (model at: #aesthetics) secondaryTextColor;
				yourself]) }
]

{ #category : #initialization }
RiTreeDiffPresenter >> newColumnWithIceNodesOld [
	self flag: #todo. "Delete with unused methods"
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
				evaluated: [ :each | (model at: #aesthetics) rowForChange: each ];
				yourself);
		yourself
]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> onHackyCollapse: anAnnouncement [
	self flag: #todo. "Make not hacky"
	(anAnnouncement belongsToSpTableTree: treeTable) ifFalse: [ ^ self ].
	(model at: #expandedIceNodes)
		remove: anAnnouncement fastTableItem data
		ifAbsent: [].
	expandDeferrer schedule.

]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> onHackyExpand: anAnnouncement [
	self flag: #todo. "Make not hacky"
	(anAnnouncement belongsToSpTableTree: treeTable) ifFalse: [ ^ self ].
	(model at: #expandedIceNodes)
		add: anAnnouncement fastTableItem data.
	expandDeferrer schedule.

]

{ #category : #'expand/collapse' }
RiTreeDiffPresenter >> refreshExpand [
	self flag: #todo. "Try to avoid race conditions..."
	highlightDeferrer flush.
	(model at: #blockWhenExpandedIceNodesChanged) value
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

]

{ #category : #highlighting }
RiTreeDiffPresenter >> selectIceNode: anIceNode [
	treeTable selectedItem = anIceNode
		ifTrue: [ ^ self ].
	treeTable
		selectPath: (treeTable selection pathOf: anIceNode)
		scrollToSelection: true
]

{ #category : #accessing }
RiTreeDiffPresenter >> selectedIceNode [
	^ treeTable selectedItem
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
