Class {
	#name : 'RiTreeDiffPresenter2',
	#superclass : 'RiPresenter',
	#instVars : [
		'treeTable',
		'highlightDeferrer',
		'iceNodeCollectionToHighlight',
		'expandDeferrer',
		'checkedSelectionUpdateBlock'
	],
	#category : 'Rita-UI-Spec2-Diff',
	#package : 'Rita-UI',
	#tag : 'Spec2-Diff'
}

{ #category : 'private' }
RiTreeDiffPresenter2 >> actOnSelectionChange [

	checkedSelectionUpdateBlock value.
	
	"We refresh the table to propagate changes to children"
	treeTable refresh
]

{ #category : 'initialization' }
RiTreeDiffPresenter2 >> contextMenuForTable [
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

{ #category : 'layout' }
RiTreeDiffPresenter2 >> defaultLayout [

	^ SpBoxLayout newHorizontal
		  add: treeTable;
		  yourself
]

{ #category : 'check/uncheck' }
RiTreeDiffPresenter2 >> doCheck: anIceNode [

	self shadowedIceNodes
		removeAllFoundIn: anIceNode allChildren;
		removeAllFoundIn: anIceNode withAllParentNodes.

	self actOnSelectionChange
]

{ #category : 'check/uncheck' }
RiTreeDiffPresenter2 >> doUncheck: anIceNode [

	self shadowedIceNodes
		add: anIceNode;
		addAll: anIceNode allChildren.

	self actOnSelectionChange
]

{ #category : 'initialization' }
RiTreeDiffPresenter2 >> initializePresenters [

	treeTable := self newEasyTreeColumnView.
	treeTable
		children: [ :each | each children ];
		whenSelectionChangedDo: [ :selection | (model at: #blockWhenNodeSelected) value: selection selectedItem ];
		contextMenu: [ self contextMenuForTable ];
		addColumn: (SpCheckBoxTableColumn new
				 evaluated: [ :iceNode | self isChecked: iceNode ];
				 onActivation: [ :iceNode | self doCheck: iceNode ];
				 onDeactivation: [ :iceNode | self doUncheck: iceNode ];
				 beNotExpandable;
				 yourself);
		addColumn: ((SpImageTableColumn evaluated: [ :each | each value icon ])
				 beNotExpandable;
				 yourself);
		addColumn: (SpStringTableColumn evaluated: [ :each | each value definition ritaAsTextForTree0 ])
]

{ #category : 'testing' }
RiTreeDiffPresenter2 >> isChecked: anIceNode [

	^ (self shadowedIceNodes includes: anIceNode) not
]

{ #category : 'accessing' }
RiTreeDiffPresenter2 >> model: aModel [

	super model: aModel.
	
	"We expand all expanded nodes."
	(aModel at: #expandedIceNodes) reverseDo: [ :each |
			[ treeTable expandPath: (treeTable selection pathOf: each) ]
				on: NotFound
				do: [ "If a node is not in the list, we just ignore it" ] ]
]

{ #category : 'updating' }
RiTreeDiffPresenter2 >> refreshOnModelUpdate [

	treeTable roots: (model at: #iceDiff) tree children
]

{ #category : 'highlighting' }
RiTreeDiffPresenter2 >> selectIceNode: anIceNode [

	treeTable selectedItem = anIceNode ifTrue: [ ^ self ].

	treeTable selectPath: (treeTable selection pathOf: anIceNode) scrollToSelection: true
]

{ #category : 'check/uncheck' }
RiTreeDiffPresenter2 >> shadowedIceNodes [
	^ model at: #shadowedIceNodes
]

{ #category : 'enumerating' }
RiTreeDiffPresenter2 >> whenCheckedSelectionChangedDo: aBlock [
	"I save an action to execute when the use click the checkboxes of the tree."

	checkedSelectionUpdateBlock := aBlock
]
