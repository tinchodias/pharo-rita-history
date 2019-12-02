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
		whenSelectionChangedDo: [ :selection |
			self refreshOnSelectionChanged: selection ]
]

{ #category : #accessing }
RiTreeDiffPresenter >> refreshOnModelUpdate [
	diffPanel reset.
	treeTable roots: (model at: #iceDiff) tree children.
	treeTable whenBuiltDo: [ :ann |
		ann widget dataSource expandAll ].
]

{ #category : #accessing }
RiTreeDiffPresenter >> refreshOnSelectionChanged: selection [

	(model at: #blockWhenNodeSelected) value: selection selectedItem.

	selection selectedItem value ifNotNil: [ :iceOperation |
		diffPanel model: { 
			#from -> iceOperation rightContents.
			#to -> iceOperation leftContents } asDictionary ]
]

{ #category : #accessing }
RiTreeDiffPresenter >> selectIceNode: anIceNode [
	treeTable selectedItem = anIceNode ifTrue: [ ^ self ].
	treeTable selectPath: (self indexPathFor: anIceNode)
]
