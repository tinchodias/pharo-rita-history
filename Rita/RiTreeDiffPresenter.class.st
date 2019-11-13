Class {
	#name : #RiTreeDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'diffPanel',
		'treeTable'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiTreeDiffPresenter class >> defaultSpec [
	<spec: #default>
	^ SpBoxLayout newHorizontal
		add: #treeTable width: 200;
		add: #diffPanel;
		yourself
]

{ #category : #accessing }
RiTreeDiffPresenter >> changeListColumn [
	^ SpCompositeTableColumn new
		addColumn:
			(SpImageTableColumn new
				width: 20;
				evaluated: [ :each | each value icon ];
				yourself);
		addColumn:
			(SpStringTableColumn new
				evaluated: [ :each | each value name ];
				yourself);
		yourself
]

{ #category : #accessing }
RiTreeDiffPresenter >> changeSelected [
	^ treeTable selectedItem
]

{ #category : #initialization }
RiTreeDiffPresenter >> initializeDiffPanel [
	diffPanel showOptions: false
]

{ #category : #accessing }
RiTreeDiffPresenter >> initializePresenters [
	treeTable := self newTreeTable.
	diffPanel := self newDiff.

	self initializeTree.
	self initializeDiffPanel.

	self focusOrder
		add: treeTable;
		add: diffPanel
]

{ #category : #accessing }
RiTreeDiffPresenter >> initializeTree [
	treeTable
		addColumn: self changeListColumn;
		children: [ :each | each children ];
		whenSelectionChangedDo: [ 
			self refreshOnSelectionChanged ]
]

{ #category : #accessing }
RiTreeDiffPresenter >> refreshOnModelUpdate [
	self resetDiffContents.
	treeTable roots: (model at: #iceDiff) tree children.
	treeTable whenBuiltDo: [ :ann |
		ann widget dataSource expandAll ].
]

{ #category : #accessing }
RiTreeDiffPresenter >> refreshOnSelectionChanged [
	| itemValue |
	itemValue := treeTable selectedItem value.
	itemValue ifNotNil: [
		diffPanel
			leftText: itemValue rightContents;
			rightText: itemValue leftContents ]

]

{ #category : #private }
RiTreeDiffPresenter >> resetDiffContents [
	diffPanel
		leftText: '';
		rightText: ''
]
