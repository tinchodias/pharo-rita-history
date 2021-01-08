Class {
	#name : #RiPRTreeDiffPresenter,
	#superclass : #RiTreeDiffPresenter,
	#category : #'Rita-PullRequests-UI'
}

{ #category : #initialization }
RiPRTreeDiffPresenter >> iconNameFor: iceNode [

	^ (model at: #conversationItemsByIceNode) 
		at: iceNode
		ifPresent: [ :items |
			ZuTheme current conversationIconSelector ]
		ifAbsent: [ #blank ]
]

{ #category : #initialization }
RiPRTreeDiffPresenter >> initializePresenters [

	treeTable := self newTreeTable.
	treeTable
		children: [ :each | each children ];
		whenSelectionChangedDo: [ :selection |
			(model at: #blockWhenNodeSelected) value: selection selectedItem ];
		contextMenu: [ self contextMenuForTable ];
		addColumn: self newColumnWithConversationInfo.
	
	treeTable whenBuiltDo: [:ann |
		"Note: All items are already instantiated at this point"
		| table |
		table := ann widget.
		self doInitialTreeExpansionOn: table ]
]

{ #category : #initialization }
RiPRTreeDiffPresenter >> newColumnWithConversationInfo [

	^ self newColumnWithIceNodes 
		addColumn: (SpImageTableColumn evaluated: [ :iceNode | 
			self iconNamed: (self iconNameFor: iceNode) ]);
		addColumn: (SpStringTableColumn evaluated: [ :iceNode | 
			self stringFor: iceNode ]);
		yourself
]

{ #category : #initialization }
RiPRTreeDiffPresenter >> stringFor: iceNode [

	^ (model at: #conversationItemsByIceNode) 
		at: iceNode
		ifPresent: [ :items |
			(items sum: [ :each | each numberOfComments ]) asString ]
		ifAbsent: [ '' ]
]
