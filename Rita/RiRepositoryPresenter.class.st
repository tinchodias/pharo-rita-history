"
I am a Spec2 presenter for RiRepository objects.

"
Class {
	#name : #RiRepositoryPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table',
		'blockForPinToCompareFrom',
		'rowBuilder',
		'actionBar',
		'cleanSearchButton',
		'nextJumpToNextButton',
		'nextJumpToPreviousButton'
	],
	#category : #'Rita-UI'
}

{ #category : #examples }
RiRepositoryPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #table;
		add: #actionBar
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
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

{ #category : #search }
RiRepositoryPresenter >> actionCleanSearchResults [
	model at: #elementsInSearchResult put: #().
	self refreshOnSearchResultsUpdate
]

{ #category : #actions }
RiRepositoryPresenter >> actionForceRefresh [
	self riRepository process.
	self refreshOnModelUpdate
]

{ #category : #search }
RiRepositoryPresenter >> actionJumpToNextInSearchResults [
	| results elementToJump |
	results := model at: #elementsInSearchResult.
	elementToJump := table selection isEmpty
		ifTrue: [ results first ]
		ifFalse: [ | selectedElement |
			selectedElement := table selection selectedItem.
			results after: selectedElement ifAbsent: [ results first ] ].
	table selectItem: elementToJump scrollToSelection: true
]

{ #category : #search }
RiRepositoryPresenter >> actionJumpToPreviousInSearchResults [
	| results elementToJump |
	results := model at: #elementsInSearchResult.
	elementToJump := table selection isEmpty
		ifTrue: [ results last ]
		ifFalse: [ | selectedElement |
			selectedElement := table selection selectedItem.
			results before: selectedElement ifAbsent: [ results last ] ].
	table selectItem: elementToJump scrollToSelection: true

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

{ #category : #search }
RiRepositoryPresenter >> actionSearch [
	| searchPresenter searchDialog results |
	searchPresenter := self instantiate: RiRepositorySearchPresenter.
	searchPresenter model: model.
	searchDialog := searchPresenter openModalWithSpec.
	searchDialog isCancelled ifTrue: [ ^ self ].
	searchPresenter checkIfInvalid: [ :message |
		^ self inform: message ].

	UIManager default
		informUser: 'Searching in repository'
		during: [
			results := searchPresenter searchResults ].

	self inform: results size asString, ' commits found'.
	model at: #elementsInSearchResult put: results.
	self refreshOnSearchResultsUpdate.
	results ifNotEmpty: [
		self actionJumpToNextInSearchResults ].

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

	menu addItem: [ :item |
		item
			name: 'Jump Up';
			icon: (self iconNamed: #up);
			subMenu: (self contextMenuToJumpUpFor: selected) ].
	menu addItem: [ :item |
		item
			name: 'Jump Down';
			icon: (self iconNamed: #down);
			subMenu: (self contextMenuToJumpDownFor: selected) ].


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
				name: 'Inspect object';
				icon: (self iconNamed: #smallInspectIt);
				action: [ selected inspect ] ] ].

	^ menu
]

{ #category : #initialization }
RiRepositoryPresenter >> contextMenuToJumpDownFor: aRiElement [
	| menu |
	menu := self newMenu.
	
	aRiElement ancestors do: [ :each | 
		menu
			addItem: [ :item | 
				item
					name: 'Previous commit'; "each shortDescription"
					icon: (self iconNamed: #down);
					action: [ self selectRiElement: each ] ] ].

	aRiElement
		detectInAllAncestors: [:each | each marks notEmpty ]
		ifFound: [ :each | 
			menu
				addItem: [ :item | 
					item
						name: (self printStringForMarksOf: each);
						icon: (self iconNamed: #down);
						action: [ self selectRiElement: each ] ] ].

	^ menu
]

{ #category : #initialization }
RiRepositoryPresenter >> contextMenuToJumpUpFor: aRiElement [
	| menu |
	menu := self newMenu.
	
	aRiElement children do: [ :each | 
		menu
			addItem: [ :item | 
				item
					name: 'Next commit';
					icon: (self iconNamed: #up);
					action: [ self selectRiElement: each ] ] ].

	aRiElement
		detectInAllChildren: [:each | each marks notEmpty ]
		ifFound: [ :each | 
			menu
				addItem: [ :item | 
					item
						name: (self printStringForMarksOf: each);
						icon: (self iconNamed: #up);
						action: [ self selectRiElement: each ] ] ].

	^ menu
]

{ #category : #search }
RiRepositoryPresenter >> hasSearchResults [
	^ (model at: #elementsInSearchResult) notEmpty
]

{ #category : #initialization }
RiRepositoryPresenter >> initializeActionBar [
	
	| refreshButton |
	cleanSearchButton := self newButton
			label: 'Clean';
			icon: (self iconNamed: #windowClose);
			help: 'Clean search results.';
			action: [ self actionCleanSearchResults ];
			addStyle: 'ritaNarrow';
			enabled: false;
			yourself.
	nextJumpToNextButton := self newButton
			icon: (self iconNamed: #down);
			help: 'Jump to next commit in search results.';
			action: [ self actionJumpToNextInSearchResults ];
			addStyle: 'ritaNarrow';
			enabled: false;
			yourself.
	nextJumpToPreviousButton := self newButton
			icon: (self iconNamed: #up);
			help: 'Jump to previous commit in search results.';
			action: [ self actionJumpToPreviousInSearchResults ];
			addStyle: 'ritaNarrow';
			enabled: false;
			yourself.

	refreshButton := self newButton
			icon: (self iconNamed: #smallUpdate);
			help: 'Process again this repository and reload the list of commits.';
			action: [ self actionForceRefresh ];
			addStyle: 'ritaNarrow';
			yourself.
		
	actionBar := self newActionBar
		add: (self newButton
			label: 'Search';
			icon: (self iconNamed: #glamorousSearch);
			help: 'Search in the commits of this repository.';
			action: [ self actionSearch ];
			yourself);
		add: nextJumpToNextButton;
		add: nextJumpToPreviousButton;
		add: cleanSearchButton;
		addLast: refreshButton;
		yourself.

]

{ #category : #initialization }
RiRepositoryPresenter >> initializePresenters [
	self initializeTable.
	self initializeActionBar
]

{ #category : #initialization }
RiRepositoryPresenter >> initializeTable [

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

{ #category : #initialization }
RiRepositoryPresenter >> printStringForMarksOf: aRiElement [
	^ String
		streamContents: [ :stream | 
			aRiElement marks
				do: [ :mark | stream << mark description ]
				separatedBy: [ stream << ', ' ] ]
]

{ #category : #accessing }
RiRepositoryPresenter >> refreshOnAvatarsUpdate [
	self defer: [table adapter widget refresh]
]

{ #category : #accessing }
RiRepositoryPresenter >> refreshOnModelUpdate [
	self isBuilt ifFalse: [ ^ self ].

	self riRepository ensureProcessed.

	model at: #elementsInSearchResult put: #().
	rowBuilder refresh.

	table items: self riRepository elements
]

{ #category : #accessing }
RiRepositoryPresenter >> refreshOnPinsUpdate [
	self refreshOnAvatarsUpdate
]

{ #category : #search }
RiRepositoryPresenter >> refreshOnSearchResultsUpdate [
	{	cleanSearchButton.
		nextJumpToPreviousButton.
		nextJumpToNextButton}
			do: [ :each | each enabled: self hasSearchResults ].

	"Redraw table cells"
	rowBuilder refresh.
]

{ #category : #accessing }
RiRepositoryPresenter >> riRepository [
	^ model at: #repository
]

{ #category : #accessing }
RiRepositoryPresenter >> rowHeightForHiedra [
	^ table adapter widget rowHeight floor
]

{ #category : #search }
RiRepositoryPresenter >> searchResultIncudes: aRiElement [
	^ aRiElement isUncommited not
		and: [ (model at: #elementsInSearchResult) includes: aRiElement ]
]

{ #category : #actions }
RiRepositoryPresenter >> selectRiElement: aRiElement [
	table selectItem: aRiElement scrollToSelection: true
]
