"
I am a presenter displaying the list of commits (and their info) for a `RiRepository`.

I display information such as the commit SHA, the author and the date, with the git tree (Hiedra) and the marks (branches, tags, pins and working copy) in the last column.

The commits can be restricted to a scope selected in my scope drop down:
- the local clone (the whole history),
- a branch,
- a tag (a release: the commits from the previous release, exclusive, up to the tag, inclusive),
- a pull request (the commits of its range, from its merge base to its head).

Selecting a scope fills my table with the elements of that scope (see `RiScope>>elementsIn:`).

The local clone, branch and tag scopes come directly from the repository marks. Pull requests require the GitHub API and a slow network request, so I do not fetch them by default: the button at the right of the scope drop down fetches them in the background and adds one scope per open pull request. That button is only enabled for repositories with a GitHub remote, and it is disabled once the pull requests are fetched.

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
		'avatarByEmail',
		'presenterWidthInPercent',
		'scopeDropDown',
		'pullRequests',
		'fetchPullRequestsButton',
		'fetchingPullRequests'
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
RiRepositoryCommitsPresenter >> actionFetchPullRequests [
	"Fetch the pull requests in the background, and add them to my scope drop down when done.
	I disable the button so the fetch is not started twice, and it stays disabled once the pull requests are loaded."

	fetchingPullRequests := true.
	fetchPullRequestsButton enabled: false.
	[ self fetchPullRequests ] future
		onSuccessDo: [ :fetchedPullRequests |
				fetchingPullRequests := false.
				pullRequests := fetchedPullRequests.
				self defer: [ self refreshOnScopeDropDown ] ];
		onFailureDo: [ :error |
				fetchingPullRequests := false.
				self defer: [
							self refreshOnFetchPullRequestsButton.
							self reportWarning: error ] ]
]

{ #category : 'actions' }
RiRepositoryCommitsPresenter >> actionForceRefresh [

	self invalidatePullRequests.
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
	searchDialog := searchPresenter openModal.
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
RiRepositoryCommitsPresenter >> connectPresenters [

	super connectPresenters.

	scopeDropDown whenSelectedItemChangedDo: [ :scope | scope ifNotNil: [ self selectScope: scope ] ]
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
		  add: (SpBoxLayout newHorizontal
				   add: scopeDropDown;
				   add: fetchPullRequestsButton expand: false fill: false;
				   yourself)
		  expand: false
		  fill: false
		  padding: 5;
		  add: table;
		  add: actionBar expand: false;
		  yourself
]

{ #category : 'private' }
RiRepositoryCommitsPresenter >> fetchPullRequests [

	| remotes api result |
	result := OrderedCollection new.
	remotes := self riRepository iceRepository remotes select: [ :aRemote | aRemote host = 'github.com' ].

	api := IceGitHubAPI new.
	remotes do: [ :remote |
			result addAll: ((api getPullRequests: remote owner project: remote projectName) all collect: [ :json |
					 RiPullRequest from: (IceGitHubPullRequest fromJSON: json) repository: self riRepository remote: remote ]) ].
	^ result
]

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> fetchPullRequestsButton [
	^ fetchPullRequestsButton
]

{ #category : 'testing' }
RiRepositoryCommitsPresenter >> hasGitHubRemote [

	^ self riRepository iceRepository remotes anySatisfy: [ :each | each host = 'github.com' ]
]

{ #category : 'search' }
RiRepositoryCommitsPresenter >> hasSearchResults [
	^ (model at: #elementsInSearchResult) notEmpty
]

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> initialize [

	super initialize.

	avatarByEmail := Dictionary new.
	presenterWidthInPercent := 15.
	fetchingPullRequests := false
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
		             addLast: (self newButton
				              iconName: #changeUpdate;
				              help: 'Expands/Collapses the repository commit panel.';
				              action: [ "Expands or collapse the panel and rebuild my owner"
						              presenterWidthInPercent := presenterWidthInPercent = 15
							                                         ifTrue: [ 75 ]
							                                         ifFalse: [ 15 ].
						              self owner layout: self owner defaultLayout ];
				              addStyle: 'ritaNarrow';
				              yourself);
		             yourself
]

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> initializePresenters [

	scopeDropDown := self newDropList.
	fetchPullRequestsButton := self newButton.

	self initializeTable.

	scopeDropDown
		display: [ :scope | scope label ];
		displayIcon: [ :scope | self iconNamed: scope iconName ];
		help: 'Restrict the displayed commits to a branch or a tag.'.

	fetchPullRequestsButton
		iconName: #down;
		help: 'Pull requests are not fetched by default because it is a slow network request. Click to fetch them.';
		action: [ self actionFetchPullRequests ];
		addStyle: 'ritaNarrow'.

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
		beMultipleSelection;
		addColumn: (SpStringTableColumn new
				 title: 'Commit';
				 evaluated: [ :item | item shortId ];
				 width: 65;
				 yourself);
		addColumn: (SpStringTableColumn new
				 title: 'Comment';
				 evaluated: [ :item | item comment ];
				 width: 300;
				 isSortable: false;
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
		addColumn: (SpImageTableColumn new
				 displayAlignment: [ :each | SpColumnAlignment left ];
				 evaluated: [ :item | rowBuilder morphAt: item ];
				 yourself).

	table whenBuiltDo: [ :ann | self refreshOnModelUpdate ]
]

{ #category : 'private' }
RiRepositoryCommitsPresenter >> invalidatePullRequests [

	pullRequests := nil
]

{ #category : 'pin/unpin commits' }
RiRepositoryCommitsPresenter >> isPinned: aRiElement [

	^ (model at: #pinDiffModels ifAbsent: [ OrderedCollection new ]) anySatisfy: [ :each | each sourceRiElement = aRiElement ]
]

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> presenterWidthInPercent [
	"I have a button to expand me in my parent via this variable."

	^ presenterWidthInPercent
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
RiRepositoryCommitsPresenter >> pullRequests [
	"Answer the pull requests fetched so far, or nil if they were not fetched yet.
	They are not fetched by default: the user fetches them with the dedicated button."

	^ pullRequests
]

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> refreshOnAvatarsUpdate [
	self defer: [table adapter widget refresh]
]

{ #category : 'refreshing' }
RiRepositoryCommitsPresenter >> refreshOnFetchPullRequestsButton [
	"Update the state of my fetch-pull-requests button: it is only usable for GitHub repositories, and only until the pull requests are fetched."

	self hasGitHubRemote
		ifTrue: [
				fetchPullRequestsButton
					help: 'Pull requests are not fetched by default because it is a slow network request. Click to fetch them.';
					enabled: (pullRequests isNil and: [ fetchingPullRequests not ]) ]
		ifFalse: [
				fetchPullRequestsButton
					help: 'Fetching pull requests is only supported for repositories with a GitHub remote.';
					enabled: false ]
]

{ #category : 'refreshing' }
RiRepositoryCommitsPresenter >> refreshOnModelUpdate [

	self isBuilt ifFalse: [ ^ self ].

	self riRepository ensureProcessed.

	model at: #elementsInSearchResult put: #(  ).
	rowBuilder refresh.

	self refreshOnScopeDropDown.

	table items: self riRepository elements.
	self flag: #todo. "Maybe that if we had an element already selected we should keep the same selection?"
	table selectFirst
]

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> refreshOnPinsUpdate [
	self refreshOnAvatarsUpdate
]

{ #category : 'refreshing' }
RiRepositoryCommitsPresenter >> refreshOnScopeDropDown [
	"Fill my scope drop down with the scopes of my repository.
	I keep the current selection when I can: pull request scopes are appended at the end, so the other indices do not shift."

	| indexToSelect |
	self refreshOnFetchPullRequestsButton.
	indexToSelect := scopeDropDown selectedIndex max: 1.
	scopeDropDown items: self riScopes.
	scopeDropDown selectIndex: (indexToSelect min: scopeDropDown items size)
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
RiRepositoryCommitsPresenter >> riScopes [
	"Answer the scopes the user can browse: the whole local clone, then every branch and every tag, then one scope per fetched pull request.
	Pull requests are not fetched by default: the user fetches them with the dedicated button.
	Each scope is a RiScope that knows its own label and icon."

	^ Array streamContents: [ :stream |
			  stream nextPut: RiLocalCloneScope new.
			  self riRepository elementMarks
				  select: [ :mark | mark isBranchMark or: [ mark isTagMark ] ]
				  thenDo: [ :mark | stream nextPut: (RiScope forMark: mark) ].
			  self pullRequests ifNotNil: [ :prs | prs do: [ :pullRequest | stream nextPut: (RiPullRequestScope pullRequest: pullRequest) ] ] ]
]

{ #category : 'accessing' }
RiRepositoryCommitsPresenter >> scopeDropDown [
	^ scopeDropDown
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

{ #category : 'actions' }
RiRepositoryCommitsPresenter >> selectScope: aScope [
	"Fill the table with the commits that belong to aScope."

	| elements |
	elements := aScope elementsIn: self riRepository.
	table items: elements.
	rowBuilder refreshForElements: elements.
	table selectFirst
]

{ #category : 'initialization' }
RiRepositoryCommitsPresenter >> whenSelectionChangedDo: aBlock [
	"The block receives all the selected elements, in the order the table lists them (newest first)."

	table whenSelectionChangedDo: [ :selection |
		selection selectedItems ifNotEmpty: [ :items | aBlock value: (table items select: [ :element | items includes: element ]) ] ]
]
