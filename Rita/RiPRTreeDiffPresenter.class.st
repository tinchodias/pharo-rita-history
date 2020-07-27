Class {
	#name : #RiPRTreeDiffPresenter,
	#superclass : #RiTreeDiffPresenter,
	#category : #'Rita-UI-PullRequests'
}

{ #category : #initialization }
RiPRTreeDiffPresenter >> boldPartFor: iceNode [
	| parts |
	parts := (self descriptionPartsFor: iceNode).
	^ parts size > 1 ifTrue: [ ('· ', parts first) asText addAttribute: (TextFontReference toFont: StandardFonts balloonFont)] ifFalse: [ ' ' join: parts ].
]

{ #category : #initialization }
RiPRTreeDiffPresenter >> colorForNames [
		
	^ self theme caretColor mixed: 0.5 with: self theme textColor
]

{ #category : #initialization }
RiPRTreeDiffPresenter >> descriptionPartsFor: iceNode [
	| description |
	description := iceNode value definition ritaDescription asString.
	^ ':' split: description
]

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

{ #category : #initialization }
RiPRTreeDiffPresenter >> newColumnWithIceNodes [
	^ SpCompositeTableColumn new
		addColumn:
			(SpImageTableColumn new
				evaluated: [ :each | (model at: #aesthetics) iconForChange: each value ];
				yourself);
		addColumn:
			(SpStringTableColumn new
				evaluated: [ :each | (' ', (self normalPartFor: each)) asText makeAllColor: self colorForNames ];
				yourself);
		addColumn:
			(SpStringTableColumn new
				evaluated: [ :each | (self boldPartFor: each) "asText allBold "];
				yourself);
		yourself
]

{ #category : #initialization }
RiPRTreeDiffPresenter >> normalPartFor: iceNode [
	| parts |
	parts := (self descriptionPartsFor: iceNode).
	^ parts size > 1 ifTrue: [ parts second ] ifFalse: [ '' ].
]
