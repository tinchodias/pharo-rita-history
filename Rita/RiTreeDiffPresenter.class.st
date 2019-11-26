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
	^ SpPanedLayout newHorizontal
		position: 33 percent;
		add: #treeTable;
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
				evaluated: [ :each | each value ritaKey ];
				yourself);
		yourself
]

{ #category : #accessing }
RiTreeDiffPresenter >> changeSelected [
	^ treeTable selectedItem
]

{ #category : #accessing }
RiTreeDiffPresenter >> initializePresenters [
	treeTable := self newTreeTable.
	diffPanel := self instantiate: RiUnifiedDiffPresenter.

	self initializeTree.

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
	diffPanel reset.
	treeTable roots: (model at: #iceDiff) tree children.
	treeTable whenBuiltDo: [ :ann |
		ann widget dataSource expandAll ].
]

{ #category : #accessing }
RiTreeDiffPresenter >> refreshOnSelectionChanged [
	| itemValue |
	itemValue := treeTable selectedItem value.
	itemValue ifNotNil: [
		diffPanel model: { 
			#from -> itemValue rightContents.
			#to -> itemValue leftContents } asDictionary ]

]

{ #category : #accessing }
RiTreeDiffPresenter >> selectIceNode: anIceNode [

	| nodesPath indexPath currentNodes |
	nodesPath := anIceNode withAllParentNodes.
	
	currentNodes := treeTable roots.
	indexPath := Array streamContents: [ :stream |
		nodesPath do: [ :each |
			| index |
			index := currentNodes indexOf: each.
			stream nextPut: index.
			currentNodes := (currentNodes at: index) children ]].

	treeTable selectPath: indexPath.
]
