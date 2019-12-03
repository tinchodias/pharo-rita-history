Class {
	#name : #RiTreeDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'treeTable'
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
	self focusOrder add: treeTable
]

{ #category : #accessing }
RiTreeDiffPresenter >> initializeTree [
	treeTable
		addColumn: self changeListColumn;
		children: [ :each | each children ];
		whenSelectionChangedDo: [ :selection |
			(model at: #blockWhenNodeSelected) value: selection selectedItem ]
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
