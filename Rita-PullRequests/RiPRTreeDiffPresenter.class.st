Class {
	#name : #RiPRTreeDiffPresenter,
	#superclass : #RiTreeDiffPresenter,
	#category : #'Rita-PullRequests-UI'
}

{ #category : #initialization }
RiPRTreeDiffPresenter >> initializePresenters [
	treeTable := self newTreeTable.
	treeTable
		children: [ :each | each children ];
		whenSelectionChangedDo: [ :selection |
			(model at: #blockWhenNodeSelected) value: selection selectedItem ];
		contextMenu: [ self contextMenuForTable ];
		addColumn: self newColumnWithIceNodes.
	
	treeTable whenBuiltDo: [:ann |
		"Note: All items are already instantiated at this point"
		| table |
		table := ann widget.
		self doInitialTreeExpansionOn: table ]
]
