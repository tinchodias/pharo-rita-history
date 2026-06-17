Class {
	#name : 'RiTreeDiffPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'treeTable',
		'highlightDeferrer',
		'iceNodeCollectionToHighlight',
		'checkedSelectionUpdateBlock'
	],
	#category : 'Rita-UI-Spec2-Diff',
	#package : 'Rita-UI',
	#tag : 'Spec2-Diff'
}

{ #category : 'layout' }
RiTreeDiffPresenter class >> defaultLayout [
	^ SpBoxLayout newHorizontal
		add: #treeTable;
		yourself
]

{ #category : 'private' }
RiTreeDiffPresenter >> actOnSelectionChange [

	checkedSelectionUpdateBlock value.
	
	"We refresh the table to propagate changes to children"
	treeTable refresh
]

{ #category : 'initialization' }
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

{ #category : 'check/uncheck' }
RiTreeDiffPresenter >> doCheck: anIceNode [

	self shadowedIceNodes
		removeAllFoundIn: anIceNode allChildren;
		removeAllFoundIn: anIceNode withAllParentNodes.

	self actOnSelectionChange
]

{ #category : 'expand/collapse' }
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

{ #category : 'expanding-collapsing' }
RiTreeDiffPresenter >> doCollapseWithAllChildren [
	self
		doValueOnSelectedFastTableItemToExpandOrCollapse: [ :fastTableItem | 
			treeTable unselectAll. "This seems to avoid a random error"
			fastTableItem
				collapseAll";
				refreshTable" ]
]

{ #category : 'expand/collapse' }
RiTreeDiffPresenter >> doExpandOneLevel [
	self
		doValueOnSelectedFastTableItemToExpandOrCollapse: [ :fastTableItem | fastTableItem expand ]
]

{ #category : 'collapse/expand' }
RiTreeDiffPresenter >> doExpandWithAllChildren [
	self
		doValueOnSelectedFastTableItemToExpandOrCollapse: [ :fastTableItem | 
			treeTable unselectAll. "This seems to avoid a random error"
			fastTableItem
				expandAll";
				refreshTable" ]
]

{ #category : 'expand/collapse' }
RiTreeDiffPresenter >> doInitialTreeExpansion [
	"We expand all expanded nodes."

	self expandedIceNodes reverseDo: [ :each |
			[ treeTable expandPath: (treeTable selection pathOf: each) ]
				on: NotFound
				do: [ "If a node is not in the list, we just ignore it" ] ]
]

{ #category : 'expand/collapse' }
RiTreeDiffPresenter >> doToggleExpandOneLevel [
	self
		doValueOnSelectedFastTableItemToExpandOrCollapse: [ :fastTableItem | 
			fastTableItem toggle ]
]

{ #category : 'check/uncheck' }
RiTreeDiffPresenter >> doUncheck: anIceNode [

	self shadowedIceNodes
		add: anIceNode;
		addAll: anIceNode allChildren.

	self actOnSelectionChange
]

{ #category : 'expand/collapse' }
RiTreeDiffPresenter >> doValueOnSelectedFastTableItemToExpandOrCollapse: aBlock [
	| fastTableItem |
	fastTableItem := treeTable adapter widget dataSource
		itemAtPath: treeTable selection selectedPath.

	aBlock value: fastTableItem
]

{ #category : 'expand/collapse' }
RiTreeDiffPresenter >> expandedIceNodes [

	^ model at: #expandedIceNodes
]

{ #category : 'highlighting' }
RiTreeDiffPresenter >> hackFastTableForSecondaryHighligthing: table [
	table beRitaContainer.
	table container
		blockForMouseEnter: [ :rowIndex | 
			(model at: #blockWhenNodesHighlighted)
				value: {(table dataSource realElementAt: rowIndex)} ];
		blockForMouseLeave: [ :rowIndex |
			(model at: #blockWhenNodesHighlighted) value: #() ].


]

{ #category : 'highlighting' }
RiTreeDiffPresenter >> highlightIceNode: iceNodeCollection [
	iceNodeCollectionToHighlight := iceNodeCollection.
	highlightDeferrer schedule.
]

{ #category : 'initialization' }
RiTreeDiffPresenter >> initialize [

	super initialize.

	highlightDeferrer := OmDeferrer send: #refreshHighlight to: self after: 100 milliSeconds
]

{ #category : 'initialization' }
RiTreeDiffPresenter >> initializePresenters [

	treeTable := self newTreeTable.
	treeTable
		children: [ :each | each children ];
		whenSelectionChangedDo: [ :selection | (model at: #blockWhenNodeSelected) value: selection selectedItem ];
		contextMenu: [ self contextMenuForTable ];
		addColumn: (SpCompositeTableColumn withAll: {
						 (SpCheckBoxTableColumn new
							  evaluated: [ :iceNode | self isChecked: iceNode ];
							  onActivation: [ :iceNode | self doCheck: iceNode ];
							  onDeactivation: [ :iceNode | self doUncheck: iceNode ];
							  width: 20;
							  yourself).
						 (SpImageTableColumn evaluated: [ :each | each value icon ]).
						 (SpStringTableColumn evaluated: [ :each | ' ' , each value definition ritaAsTextForTree0 ]).
						 (SpStringTableColumn evaluated: [ :each |
								  (' ·  ' , each value definition ritaAsTextForTree1) asText
									  addAttribute: (TextFontReference toFont: StandardFonts balloonFont);
									  makeAllColor: self aesthetics secondaryTextColor;
									  yourself ]) });
		whenExpandChangedDo: [ :ann |
				| oldSize |
				oldSize := self expandedIceNodes size.
				self flag: #todo. "Maybe the expanded Ice nodes should be a set to avoid the duplication check. Also we should set this after setting the model."
				ann expanded
					ifTrue: [ ann item withAllChildrenDo: [ :element | (self expandedIceNodes includes: element) ifFalse: [ self expandedIceNodes add: element ] ] ]
					ifFalse: [ ann item withAllChildrenDo: [ :element | self expandedIceNodes remove: element ifAbsent: [ ] ] ].
				oldSize = self expandedIceNodes size ifFalse: [ self refreshExpand ] ].

	treeTable
		bindKeyCombination: Character space toAction: [ self toggleSelection ];
		bindKeyCombination: Character arrowLeft toAction: [ self doCollapseOneLevel ];
		bindKeyCombination: Character arrowRight toAction: [ self doExpandOneLevel ].

	treeTable whenBuiltDo: [ :ann | "Note: All items are already instantiated at this point"
			self hackFastTableForSecondaryHighligthing: ann widget.
			self doInitialTreeExpansion ]
]

{ #category : 'check/uncheck' }
RiTreeDiffPresenter >> isChecked: anIceNode [
	^ (self shadowedIceNodes includes: anIceNode) not
]

{ #category : 'accessing' }
RiTreeDiffPresenter >> model: aModel [

	super model: aModel
]

{ #category : 'expand/collapse' }
RiTreeDiffPresenter >> refreshExpand [
	self flag: #todo. "Try to avoid race conditions..."
	highlightDeferrer flush.
	(model at: #blockWhenExpandedIceNodesChanged) value
]

{ #category : 'highlighting' }
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

{ #category : 'check/uncheck' }
RiTreeDiffPresenter >> refreshOnCheckedIceNodesChanged [
	self defer: [ treeTable adapter widget refresh ]
]

{ #category : 'updating' }
RiTreeDiffPresenter >> refreshOnModelUpdate [
	| iceNodes |
	iceNodes := (model at: #iceDiff) tree children.
	treeTable roots: iceNodes.

]

{ #category : 'highlighting' }
RiTreeDiffPresenter >> selectIceNode: anIceNode [
	treeTable selectedItem = anIceNode
		ifTrue: [ ^ self ].
	treeTable
		selectPath: (treeTable selection pathOf: anIceNode)
		scrollToSelection: true
]

{ #category : 'accessing' }
RiTreeDiffPresenter >> selectedIceNode [
	^ treeTable selectedItem
]

{ #category : 'check/uncheck' }
RiTreeDiffPresenter >> shadowedIceNodes [
	^ model at: #shadowedIceNodes
]

{ #category : 'check/uncheck' }
RiTreeDiffPresenter >> toggleSelection [
	| anIceNode |
	anIceNode := treeTable selection selectedItem.
	anIceNode ifNil: [ ^self ].
	(self isChecked: anIceNode)
		ifTrue: [ self doUncheck: anIceNode ]
		ifFalse: [ self doCheck: anIceNode ]
]

{ #category : 'enumerating' }
RiTreeDiffPresenter >> whenCheckedSelectionChangedDo: aBlock [
	"I save an action to execute when the use click the checkboxes of the tree."

	checkedSelectionUpdateBlock := aBlock
]
