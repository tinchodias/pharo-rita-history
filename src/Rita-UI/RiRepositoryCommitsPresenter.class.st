"
I am a presenter displaying the list of commits (and their info) in the form of a tree for a `RiRepository`.

I'll display informations such as the commit SHA, the author and the date. 

I also have a toolbar with some actions such as a search, previous, next...
"
Class {
	#name : 'RiRepositoryCommitsPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'table',
		'rowBuilder',
		'actionBar',
		'cleanSearchButton',
		'nextJumpToNextButton',
		'nextJumpToPreviousButton',
		'avatarByEmail'
	],
	#category : 'Rita-UI-Spec2-Repository',
	#package : 'Rita-UI',
	#tag : 'Spec2-Repository'
}

{ #category : 'pin/unpin commits' }
RiRepositoryCommitsPresenter >> actionAddPin: aRiElement [
	(model at: #pinDiffModels)
		add: (RiPinDiffModel sourceRiElement: aRiElement).
	(model at: #blockWhenPinsChanged) value
]

{ #category : 'search' }
RiRepositoryCommitsPresenter >> actionCleanSearchResults [
	model at: #elementsInSearchResult put: #().
	self refreshOnSearchResultsUpdate
]

{ #category : 'actions' }
RiRepositoryCommitsPresenter >> actionForceRefresh [
	self riRepository process.
	self refreshOnModelUpdate
]

{ #category : 'search' }
RiRepositoryCommitsPresenter >> actionJumpToNextInSearchResults [
	| results elementToJump |
	results := model at: #elementsInSearchResult.
	elementToJump := table selection isEmpty
		ifTrue: [ results first ]
		ifFalse: [ | selectedElement |
			selectedElement := table selection selectedItem.
			results after: selectedElement ifAbsent: [ results first ] ].
	table selectItem: elementToJump scrollToSelection: true
]

{ #category : 'search' }
RiRepositoryCommitsPresenter >> actionJumpToPreviousInSearchResults [
	| results elementToJump |
	results := model at: #elementsInSearchResult.
	elementToJump := table selection isEmpty
		ifTrue: [ results last ]
		ifFalse: [ | selectedElement |
			selectedElement := table selection selectedItem.
			results before: selectedElement ifAbsent: [ results last ] ].
	table selectItem: elementToJump scrollToSelection: true

]

{ #category : 'actions' }
RiRepositoryCommitsPresenter >> actionLoadBranch: aRiBranchMark [
	aRiBranchMark local checkout.
	self riRepository process.
	self refreshOnModelUpdate.
]

{ #category : 'actions' }
RiRepositoryCommitsPresenter >> actionLoadCommit: aRiCommit [
	aRiCommit iceGitCommit checkout.
	self riRepository process.
	self refreshOnModelUpdate.
]

{ #category : 'pin/unpin commits' }
RiRepositoryCommitsPresenter >> actionRemovePin: aRiElement [
	(model at: #pinDiffModels)
		removeAllSuchThat: [ :each | each sourceRiElement = aRiElement ].
	(model at: #blockWhenPinsChanged) value
]

{ #category : 'search' }
RiRepositoryCommitsPresenter >> actionSearch [
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

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> avatarFor: email [

	^ avatarByEmail at: email ifAbsentPut: [
			  | hash avatarUrl |
			  hash := (SHA256 hashMessage: email asByteArray) hex.
			  avatarUrl := 'https://www.gravatar.com/avatar/' , hash , '?d=identicon&s=200'.
			  (ImageReadWriter formFromStream: (ZnClient new get: avatarUrl) readStream) scaledToSize: 16 @ 16 ]
]

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> contextMenuForGoToFuture: aRiElement [
	| menu |
	menu := self newMenu.
	
	aRiElement children do: [ :each | 
		menu
			addItem: [ :item | 
				item
					name: ('''{1}'' child commit' format: { each shortId });
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

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> contextMenuForGoToPast: aRiElement [
	| menu |
	menu := self newMenu.
	
	aRiElement ancestors do: [ :each | 
		menu
			addItem: [ :item | 
				item
					name: ('''{1}'' parent commit' format: { each shortId });
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

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> contextMenuForTable [
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
			name: 'Go to future';
			icon: (self iconNamed: #up);
			subMenu: (self contextMenuForGoToFuture: selected) ].
	menu addItem: [ :item |
		item
			name: 'Go to past';
			icon: (self iconNamed: #down);
			subMenu: (self contextMenuForGoToPast: selected) ].


	menu addGroup: [ :aGroup | 
		aGroup addItem: [ :item |
			item
				name: 'Browse code in this commit';
				icon: (self iconNamed: #open);
				action: [ RiCommitBrowseUtility browse: selected iceGitCommit ] ].

		selected marks select: #isBranchMark thenDo: [ :mark |
			aGroup addItem: [ :item | 
				item
					name: ('Checkout ''{1}'' branch (in IMAGE)' format: { mark shortname }); 
					action: [ self actionLoadBranch: mark ] ] ].

		selected isUncommited ifFalse: [
			aGroup addItem: [ :item | 
				item
					name: ('Checkout ''{1}'' commit (in IMAGE)' format: { selected shortId });
					action: [ self actionLoadCommit: selected ] ] ] ].

	menu addGroup: [ :aGroup |
		aGroup addItem: [ :item | 
			item
				name: 'Inspect';
				icon: (self iconNamed: #smallInspectIt);
				action: [ selected inspect ] ] ].

	^ menu
]

{ #category : 'layout' }
RiRepositoryCommitsPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: table;
		  add: actionBar expand: false;
		  yourself
]

{ #category : 'search' }
RiRepositoryCommitsPresenter >> hasSearchResults [
	^ (model at: #elementsInSearchResult) notEmpty
]

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> initialize [

	super initialize.

	avatarByEmail := Dictionary new
]

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> initializeActionBar [

	cleanSearchButton := self newButton
		                     label: 'Clean';
		                     iconName: #windowClose;
		                     help: 'Clean search results.';
		                     action: [ self actionCleanSearchResults ];
		                     addStyle: 'ritaNarrow';
		                     enabled: false;
		                     yourself.
	nextJumpToNextButton := self newButton
		                        iconName: #down;
		                        help: 'Jump to next commit in search results.';
		                        action: [ self actionJumpToNextInSearchResults ];
		                        addStyle: 'ritaNarrow';
		                        enabled: false;
		                        yourself.
	nextJumpToPreviousButton := self newButton
		                            iconName: #up;
		                            help: 'Jump to previous commit in search results.';
		                            action: [ self actionJumpToPreviousInSearchResults ];
		                            addStyle: 'ritaNarrow';
		                            enabled: false;
		                            yourself.

	actionBar := self newActionBar
		             add: (self newButton
				              label: 'Search';
				              iconName: #search;
				              help: 'Search in the commits of this repository.';
				              action: [ self actionSearch ];
				              yourself);
		             add: nextJumpToNextButton;
		             add: nextJumpToPreviousButton;
		             add: cleanSearchButton;
		             addLast: (self newButton
				              iconName: #smallUpdate;
				              help: 'Process again this repository and reload the list of commits.';
				              action: [ self actionForceRefresh ];
				              addStyle: 'ritaNarrow';
				              yourself);
		             yourself
]

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> initializePresenters [
	self initializeTable.
	self initializeActionBar
]

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> initializeTable [

	rowBuilder := RiElementRowBuilder newForRepositoryPresenter: self.
	table := self newTable.
	table
		contextMenu: [ self contextMenuForTable ];
		addStyle: 'ritaTable';
		beResizable;
		addColumn: (SpImageTableColumn new
				 evaluated: [ :item | rowBuilder morphAt: item ];
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Commit';
				 evaluated: [ :item | item shortId ];
				 width: 65;
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Date';
				 evaluated: [ :item | item dateAndTime ];
				 width: 70;
				 yourself);
		addColumn: (SpImageTableColumn new
				 title: 'Author';
				 evaluated: [ :item | self avatarFor: item authorEmail ];
				 width: 40;
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Comment';
				 evaluated: [ :item | item comment ];
				width: 100;
				isSortable: false;
				 yourself).

	table whenBuiltDo: [ :ann | self refreshOnModelUpdate ]
]

{ #category : 'pin/unpin commits' }
RiRepositoryCommitsPresenter >> isPinned: aRiElement [
	^ (model at: #pinDiffModels)
		anySatisfy: [ :each | each sourceRiElement = aRiElement ]
]

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> printStringForMarksOf: aRiElement [
	^ String
		streamContents: [ :stream | 
			aRiElement marks
				do: [ :mark | stream << mark description ]
				separatedBy: [ stream << ', ' ] ]
]

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> refreshOnAvatarsUpdate [
	self defer: [table adapter widget refresh]
]

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> refreshOnModelUpdate [

	self isBuilt ifFalse: [ ^ self ].

	self riRepository ensureProcessed.

	model at: #elementsInSearchResult put: #(  ).
	rowBuilder refresh.

	table items: self riRepository elements.
	self flag: #todo. "Maybe that if we had an element already selected we should keep the same selection?"
	table selectFirst
]

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> refreshOnPinsUpdate [
	self refreshOnAvatarsUpdate
]

{ #category : 'search' }
RiRepositoryCommitsPresenter >> refreshOnSearchResultsUpdate [
	{	cleanSearchButton.
		nextJumpToPreviousButton.
		nextJumpToNextButton}
			do: [ :each | each enabled: self hasSearchResults ].

	"Redraw table cells"
	rowBuilder refresh.
]

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> riRepository [
	^ model at: #repository
]

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> rowHeightForHiedra [
	^ table adapter widget rowHeight floor
]

{ #category : 'search' }
RiRepositoryCommitsPresenter >> searchResultIncudes: aRiElement [
	^ aRiElement isUncommited not
		and: [ (model at: #elementsInSearchResult) includes: aRiElement ]
]

{ #category : 'actions' }
RiRepositoryCommitsPresenter >> selectRiElement: aRiElement [
	table selectItem: aRiElement scrollToSelection: true
]

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> whenSelectionChangedDo: aBlock [

	table whenSelectionChangedDo: [ :selection | selection selectedItem ifNotNil: [ :item | aBlock value: item ] ]
]
