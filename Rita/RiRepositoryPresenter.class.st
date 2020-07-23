"
I am a Spec2 presenter for RiRepository objects.

"
Class {
	#name : #RiRepositoryPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table',
		'blockForPinToCompareFrom',
		'rowBuilder'
	],
	#category : #'Rita-UI'
}

{ #category : #examples }
RiRepositoryPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
"		add: #menuBar
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];"
		add: #table;
		yourself
]

{ #category : #examples }
RiRepositoryPresenter class >> hiedraExample [
	<example>

	^ self openOnRepositoryNamed: 'Hiedra'
]

{ #category : #examples }
RiRepositoryPresenter class >> mongotalkExample [
	<example>

	^ self openOnRepositoryNamed: 'mongotalk'
]

{ #category : #examples }
RiRepositoryPresenter class >> openOnRepositoryNamed: aName [
	| aRiRepository anIceRepository |
	anIceRepository := IceRepository registry
		detect: [ :each | each name asLowercase beginsWith: aName asLowercase ].
	aRiRepository := (RiRepository iceRepository: anIceRepository)
		process;
		yourself.

	self new
		model: aRiRepository;
		openWithSpec;
		withWindowDo: [ :window | 
			window
				extent: 1000 @ 900;
				title: aName ]
]

{ #category : #examples }
RiRepositoryPresenter class >> ritaExample [
	<example>
	^ self openOnRepositoryNamed: 'pharo-rita-history'
]

{ #category : #examples }
RiRepositoryPresenter class >> roassal3Example [
	<example>

	^ self openOnRepositoryNamed: 'Roassal3'
]

{ #category : #examples }
RiRepositoryPresenter class >> voyageExample [
	<example>

	^ self openOnRepositoryNamed: 'voyage'
]

{ #category : #'pin/unpin commits' }
RiRepositoryPresenter >> actionAddPin: aRiElement [
	(model at: #pinDiffModels)
		add: (RiPinDiffModel sourceRiCommit: aRiElement).
	(model at: #blockWhenPinsChanged) value
]

{ #category : #actions }
RiRepositoryPresenter >> actionLoadBranch: aRiBranchMark [
	aRiBranchMark local checkout.
	self riRepository process.
	self refreshOnModelUpdate.
]

{ #category : #actions }
RiRepositoryPresenter >> actionLoadCommit: aRiCommit [
	aRiCommit iceCommit checkout.
	self riRepository process.
	self refreshOnModelUpdate.
]

{ #category : #'pin/unpin commits' }
RiRepositoryPresenter >> actionRemovePin: aRiElement [
	(model at: #pinDiffModels)
		removeAllSuchThat: [ :each | each sourceRiCommit = aRiElement ].
	(model at: #blockWhenPinsChanged) value
]

{ #category : #initialization }
RiRepositoryPresenter >> blockForElementSelected: aBlock [
	table whenSelectionChangedDo: [:selection |
		selection selectedItem ifNotNil: aBlock ]
]

{ #category : #initialization }
RiRepositoryPresenter >> contextMenuForTable [
	| menu selected |
	menu := self newMenu.
	
	selected := table selection selectedItem.

	menu addGroup: [ :aGroup | 
		(self isPinned: selected)
			ifTrue: [
				aGroup addItem: [ :item | 
					item
						name: 'Remove pin';
						icon: (self iconNamed: #breakpoint);
						action: [ self actionRemovePin: selected ] ] ]
			ifFalse: [
				aGroup addItem: [ :item | 
					item
						name: 'Pin commit (to diff from it)';
						icon: (self iconNamed: #breakpoint);
						action: [ self actionAddPin: selected ] ] ] ].


	menu addGroup: [ :aGroup | 
		aGroup addItem: [ :item |
			item
				name: 'Browse code in this commit';
				action: [ RiCommitBrowseUtility browse: selected iceCommit ] ].

		selected marks select: #isBranchMark thenDo: [ :mark |
			aGroup addItem: [ :item | 
				item
					name: ('Checkout (in IMAGE) branch {1}' format: { mark shortname }); 
					action: [ self actionLoadBranch: mark ] ] ].

		selected isUncommited ifFalse: [
			aGroup addItem: [ :item | 
				item
					name: ('Checkout (in IMAGE) commit {1}' format: { selected shortId });
					action: [ self actionLoadCommit: selected ] ] ] ].

	menu addGroup: [ :aGroup |
		aGroup addItem: [ :item | 
			item
				name: 'Refresh list';
				icon: (self iconNamed: #smallUpdate);
				action: [ self refreshOnModelUpdate ] ].

		aGroup addItem: [ :item | 
			item
				name: 'Inspect object';
				icon: (self iconNamed: #smallInspectIt);
				action: [ selected inspect ] ] ].

	^ menu
]

{ #category : #initialization }
RiRepositoryPresenter >> initializePresenters [

	rowBuilder := RiElementRowBuilder newForRepositoryPresenter: self.

	table := self newTable.
	table
		hideColumnHeaders;
		contextMenu: [ self contextMenuForTable ];
		addColumn: (SpImageTableColumn
			evaluated: [ :item | rowBuilder morphAt: item ]).

	table whenBuiltDo: [ :ann |
		self refreshOnModelUpdate ].

]

{ #category : #'pin/unpin commits' }
RiRepositoryPresenter >> isPinned: aRiElement [
	^ (model at: #pinDiffModels)
		anySatisfy: [ :each | each sourceRiCommit = aRiElement ]
]

{ #category : #accessing }
RiRepositoryPresenter >> refreshOnAvatarsUpdate [
	self defer: [table adapter widget refresh]
]

{ #category : #accessing }
RiRepositoryPresenter >> refreshOnModelUpdate [
	self isBuilt ifFalse: [ ^ self ].

	self riRepository ensureProcessed.

	rowBuilder refresh.

	table items: self riRepository elements
]

{ #category : #accessing }
RiRepositoryPresenter >> refreshOnPinsUpdate [
	self refreshOnAvatarsUpdate
]

{ #category : #accessing }
RiRepositoryPresenter >> riRepository [
	^ model at: #repository
]

{ #category : #accessing }
RiRepositoryPresenter >> rowHeightForHiedra [
	^ table adapter widget rowHeight floor
]
